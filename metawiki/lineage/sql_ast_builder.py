from __future__ import annotations

import re
import sys
from dataclasses import asdict
from json import dumps
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Set, Tuple

from .canonical_models import (
    Dataset,
    DatasetType,
    DocumentType,
    ExpressionType,
    Field,
    FieldExpression,
    FieldLineage,
    FieldRole,
    Job,
    JobModel,
    LineageType,
    SemanticDocument,
    Stage,
    StageGroupBy,
    StageInput,
    StageJoin,
    StagePredicate,
    StageType,
    WriteMode,
    PredicateType,
)


def _load_sqlglot():
    try:
        from sqlglot import exp, parse_one  # type: ignore
    except ImportError:
        vendor_path = Path(__file__).resolve().parent.parent / "vendor"
        if str(vendor_path) not in sys.path and vendor_path.exists():
            sys.path.insert(0, str(vendor_path))
        from sqlglot import exp, parse_one  # type: ignore
    return exp, parse_one


exp, parse_one = _load_sqlglot()


def _sanitize_name(value: str) -> str:
    text = value.strip().lower()
    text = re.sub(r"[^a-z0-9_]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text or "unknown"


def _field_id(dataset_id: str, field_name: str) -> str:
    return f"field.{dataset_id}.{_sanitize_name(field_name)}"


# 行哨兵: 代表一个数据集"整行/行集"的合成字段, 用于表示 COUNT(*)/无列源聚合这类
# "无来源列但依赖来源行"的血缘, 可从输出行一路递归到物理源表的行。
ROW_SENTINEL_NAME = "*"


def _row_sentinel_field_id(dataset_id: str) -> str:
    return f"field.{dataset_id}.__rows__"


def _dataset_id_for_table(table: "exp.Table") -> str:
    # CTE/子查询带显式列名(如 t(a,b))时, sqlglot 给的是 exp.Schema, 先解包到内层 Table
    if isinstance(table, exp.Schema):
        table = table.this
    parts = [part for part in [getattr(table, "catalog", None),
                               getattr(table, "db", None),
                               getattr(table, "name", None)] if part]
    return f"table.{'.'.join(parts)}"


class SqlAstJobModelBuilder:
    def __init__(
        self,
        dialect: str = "hive",
        known_fields: Optional[Set[Tuple[str, str]]] = None,
    ) -> None:
        self.dialect = dialect
        self.known_fields = known_fields or set()
        self._reset()

    def parse_file(self, path: str | Path) -> JobModel:
        file_path = Path(path)
        sql = file_path.read_text(encoding="utf-8")
        return self.parse_sql(sql=sql, job_name=file_path.stem, source_path=str(file_path))

    def parse_directory(self, directory: str | Path) -> List[JobModel]:
        base = Path(directory)
        return [self.parse_file(path) for path in sorted(base.glob("*.sql"))]

    def parse_sql(self, sql: str, job_name: str, source_path: str = "") -> JobModel:
        self._reset()
        root = parse_one(sql, read=self.dialect)
        job_id = f"job.{_sanitize_name(job_name)}"
        self._job_namespace = _sanitize_name(job_name)
        self.job = Job(
            job_id=job_id,
            job_name=job_name,
            engine=self.dialect,
            write_mode=self._detect_write_mode(root),
            raw_sql=sql,
            description=f"Parsed from {source_path or job_name}",
        )

        with_clause = root.args.get("with_")
        if with_clause:
            for cte in with_clause.expressions:
                self._parse_cte(cte)

        target_dataset_id = self._target_dataset_id(root)
        if isinstance(root, exp.Insert):
            if target_dataset_id:
                target_dataset = self._ensure_dataset_from_insert_target(root.this)
            else:
                target_dataset = self._ensure_dataset(
                    dataset_id=self._unique_dataset_id(job_name),
                    dataset_name=job_name,
                    dataset_type=DatasetType.TEMP,
                    is_materialized=False,
                )
            self._process_query_expression(
                query=root.expression,
                output_dataset_id=target_dataset.dataset_id,
                stage_name_hint="final_insert",
                is_final=True,
            )
            self._attach_insert_partitions(root)
        else:
            output_dataset = self._ensure_dataset(
                dataset_id=self._unique_dataset_id(f"{job_name}_result"),
                dataset_name=f"{job_name}_result",
                dataset_type=DatasetType.TEMP,
                job_id=job_id,
                is_materialized=False,
            )
            self._process_query_expression(
                query=root,
                output_dataset_id=output_dataset.dataset_id,
                stage_name_hint="result",
                is_final=True,
            )

        self._add_semantic_documents()
        return self._build_job_model()

    def to_json(self, model: JobModel) -> str:
        return dumps(asdict(model), ensure_ascii=False, indent=2)

    def _reset(self) -> None:
        self.job: Optional[Job] = None
        self.stages: List[Stage] = []
        self.datasets: List[Dataset] = []
        self.fields: List[Field] = []
        self.stage_inputs: List[StageInput] = []
        self.stage_predicates: List[StagePredicate] = []
        self.stage_joins: List[StageJoin] = []
        self.stage_group_bys: List[StageGroupBy] = []
        self.field_expressions: List[FieldExpression] = []
        self.field_lineage: List[FieldLineage] = []
        self.semantic_documents: List[SemanticDocument] = []
        self.notes: List[str] = []
        self.cte_dataset_ids: Dict[str, str] = {}
        self._stage_seq = 0
        self._dataset_name_counts: Dict[str, int] = {}
        self._stage_name_counts: Dict[str, int] = {}
        self._predicate_counts: Dict[str, int] = {}
        self._join_counts: Dict[str, int] = {}
        self._expression_counts: Dict[str, int] = {}
        # 已发出的 PK(dataset_id/stage_id/expression_id),防止 "_count" 后缀
        # 与字面 "_N" 名撞车(例如 buff 第2次 → buff_2 撞上字面列 buff_2)。
        self._issued_ids: set = set()
        self._job_namespace = "job"

    def _build_job_model(self) -> JobModel:
        assert self.job is not None
        return JobModel(
            job=self.job,
            stages=self.stages,
            datasets=self.datasets,
            fields=self.fields,
            stage_inputs=self.stage_inputs,
            stage_predicates=self.stage_predicates,
            stage_joins=self.stage_joins,
            stage_group_bys=self.stage_group_bys,
            field_expressions=self.field_expressions,
            field_lineage=self.field_lineage,
            semantic_documents=self.semantic_documents,
            notes=self.notes,
        )

    def _detect_write_mode(self, root: "exp.Expression") -> WriteMode:
        if isinstance(root, exp.Insert):
            if root.args.get("overwrite"):
                return WriteMode.INSERT_OVERWRITE
            return WriteMode.INSERT_INTO
        if isinstance(root, exp.Create):
            kind = (root.args.get("kind") or "").lower()
            if kind == "view":
                return WriteMode.CREATE_VIEW_AS
            return WriteMode.CREATE_TABLE_AS
        return WriteMode.SELECT_ONLY

    def _parse_cte(self, cte: "exp.CTE") -> None:
        cte_name = cte.alias_or_name
        dataset_id = self._ensure_dataset(
            dataset_id=self._unique_dataset_id(cte_name, preferred=f"ds.{_sanitize_name(cte_name)}"),
            dataset_name=cte_name,
            dataset_type=DatasetType.CTE,
            job_id=self.job.job_id if self.job else "",
            is_materialized=False,
            description=f"CTE {cte_name}",
        ).dataset_id
        self.cte_dataset_ids[cte_name.lower()] = dataset_id
        self._process_query_expression(
            query=cte.this,
            output_dataset_id=dataset_id,
            stage_name_hint=cte_name,
            is_final=False,
        )

    def _target_dataset_id(self, root: "exp.Expression") -> Optional[str]:
        if isinstance(root, exp.Insert):
            return _dataset_id_for_table(root.this)
        return None

    def _ensure_dataset_from_insert_target(self, table: "exp.Table") -> Dataset:
        # INSERT 带列名清单 (INSERT ... TABLE foo(c1,c2)) 时 target 是 exp.Schema, 解包到 Table
        if isinstance(table, exp.Schema):
            table = table.this
        return self._ensure_dataset(
            dataset_id=_dataset_id_for_table(table),
            dataset_name=".".join(part for part in [table.db, table.name] if part),
            dataset_type=DatasetType.TABLE,
            job_id=self.job.job_id if self.job else "",
            database_name=table.db,
            object_name=table.name,
            is_materialized=True,
            description=f"Target table {table.sql()}",
        )

    def _ensure_dataset(
        self,
        dataset_id: str,
        dataset_name: str,
        dataset_type: DatasetType,
        producer_stage_id: Optional[str] = None,
        job_id: str = "",
        database_name: Optional[str] = None,
        object_name: Optional[str] = None,
        is_materialized: bool = False,
        description: str = "",
    ) -> Dataset:
        for dataset in self.datasets:
            if dataset.dataset_id == dataset_id:
                if producer_stage_id and not dataset.producer_stage_id:
                    dataset.producer_stage_id = producer_stage_id
                return dataset
        dataset = Dataset(
            dataset_id=dataset_id,
            dataset_name=dataset_name,
            dataset_type=dataset_type,
            producer_stage_id=producer_stage_id,
            job_id=job_id,
            database_name=database_name,
            object_name=object_name,
            is_materialized=is_materialized,
            description=description,
        )
        self.datasets.append(dataset)
        return dataset

    def _unique_dataset_id(self, base_name: str, preferred: Optional[str] = None) -> str:
        base_key = preferred or f"ds.{_sanitize_name(base_name)}"
        if base_key.startswith("ds."):
            base_key = f"ds.{self._job_namespace}.{base_key[3:]}"
        count = self._dataset_name_counts.get(base_key, 0) + 1
        candidate = base_key if count == 1 else f"{base_key}_{count}"
        while candidate in self._issued_ids:
            count += 1
            candidate = f"{base_key}_{count}"
        self._dataset_name_counts[base_key] = count
        self._issued_ids.add(candidate)
        return candidate

    def _unique_stage_id(self, base_name: str) -> str:
        base_key = f"stage.{self._job_namespace}.{_sanitize_name(base_name)}"
        count = self._stage_name_counts.get(base_key, 0) + 1
        candidate = base_key if count == 1 else f"{base_key}_{count}"
        while candidate in self._issued_ids:
            count += 1
            candidate = f"{base_key}_{count}"
        self._stage_name_counts[base_key] = count
        self._issued_ids.add(candidate)
        return candidate

    def _next_ordinal(self) -> int:
        self._stage_seq += 1
        return self._stage_seq

    def _process_query_expression(
        self,
        query: "exp.Expression",
        output_dataset_id: str,
        stage_name_hint: str,
        is_final: bool,
    ) -> None:
        local_with = query.args.get("with_")
        if local_with:
            for cte in local_with.expressions:
                self._parse_cte(cte)

        if isinstance(query, exp.Subquery):
            self._process_query_expression(query.this, output_dataset_id, stage_name_hint, is_final)
            return
        if isinstance(query, exp.Union):
            self._process_union(query, output_dataset_id, stage_name_hint, is_final)
            return
        if isinstance(query, exp.Select):
            self._process_select(query, output_dataset_id, stage_name_hint, is_final)
            return
        if isinstance(query, exp.Paren):
            self._process_query_expression(query.this, output_dataset_id, stage_name_hint, is_final)
            return
        raise ValueError(f"Unsupported query expression type: {type(query).__name__}")

    def _process_union(
        self,
        union: "exp.Union",
        output_dataset_id: str,
        stage_name_hint: str,
        is_final: bool,
    ) -> None:
        branch_exprs = self._flatten_union_branches(union)
        branch_dataset_ids: List[str] = []
        for index, branch in enumerate(branch_exprs, start=1):
            branch_name = f"{stage_name_hint}_branch_{index}"
            branch_dataset = self._ensure_dataset(
                dataset_id=self._unique_dataset_id(branch_name),
                dataset_name=branch_name,
                dataset_type=DatasetType.SUBQUERY,
                job_id=self.job.job_id if self.job else "",
                is_materialized=False,
                description=f"Union branch {index} for {stage_name_hint}",
            )
            self._process_query_expression(branch, branch_dataset.dataset_id, branch_name, is_final=False)
            branch_dataset_ids.append(branch_dataset.dataset_id)

        stage_id = self._unique_stage_id(stage_name_hint)
        stage = Stage(
            stage_id=stage_id,
            job_id=self.job.job_id if self.job else "",
            stage_name=stage_name_hint,
            stage_type=StageType.FINAL if is_final else StageType.TRANSFORM,
            ordinal_no=self._next_ordinal(),
            description="UNION/UNION ALL stage",
            # exp.Union.distinct=True 表示 UNION(去重), False 表示 UNION ALL
            is_distinct=bool(union.args.get("distinct")),
        )
        self.stages.append(stage)
        output_dataset = self._ensure_dataset(
            dataset_id=output_dataset_id,
            dataset_name=output_dataset_id.split(".", 1)[-1],
            dataset_type=self._dataset_type_from_id(output_dataset_id, is_final),
            producer_stage_id=stage_id,
            job_id=self.job.job_id if self.job else "",
            is_materialized=is_final and output_dataset_id.startswith("table."),
            description=f"Output dataset for {stage_name_hint}",
        )
        output_dataset.producer_stage_id = stage_id

        branch_field_lists = [self._fields_for_dataset(dataset_id) for dataset_id in branch_dataset_ids]
        first_branch_fields = branch_field_lists[0] if branch_field_lists else []

        for input_order, dataset_id in enumerate(branch_dataset_ids, start=1):
            self.stage_inputs.append(StageInput(stage_id=stage_id, dataset_id=dataset_id, input_order=input_order))
        # 行级血缘: union 输出行 <= 各分支的行
        self._link_output_rows(output_dataset_id, branch_dataset_ids)

        for position, source_field in enumerate(first_branch_fields, start=1):
            field_name = source_field.field_name
            expression_id = self._unique_expression_id(stage_id, field_name)
            target_field = self._ensure_field(
                dataset_id=output_dataset_id,
                field_name=field_name,
                field_role=source_field.field_role,
                expression_id=expression_id,
            )
            source_ids = []
            for branch_fields in branch_field_lists:
                if position - 1 < len(branch_fields):
                    source_ids.append(branch_fields[position - 1].field_id)
                    self.field_lineage.append(
                        FieldLineage(
                            target_field_id=target_field.field_id,
                            source_field_id=branch_fields[position - 1].field_id,
                            lineage_type=LineageType.DERIVED,
                        )
                    )
            self.field_expressions.append(
                FieldExpression(
                    expression_id=expression_id,
                    stage_id=stage_id,
                    expression_type=ExpressionType.UNKNOWN,
                    expression_sql=f"UNION_BRANCH_COLUMN[{position}]",
                    source_field_ids=source_ids,
                    description="Union output column",
                )
            )

    def _flatten_union_branches(self, expr_: "exp.Expression") -> List["exp.Expression"]:
        if isinstance(expr_, exp.Union):
            return self._flatten_union_branches(expr_.left) + self._flatten_union_branches(expr_.right)
        return [expr_]

    def _process_select(
        self,
        select: "exp.Select",
        output_dataset_id: str,
        stage_name_hint: str,
        is_final: bool,
    ) -> None:
        stage_id = self._unique_stage_id(stage_name_hint)

        output_dataset = self._ensure_dataset(
            dataset_id=output_dataset_id,
            dataset_name=output_dataset_id.split(".", 1)[-1],
            dataset_type=self._dataset_type_from_id(output_dataset_id, is_final),
            producer_stage_id=stage_id,
            job_id=self.job.job_id if self.job else "",
            is_materialized=is_final and output_dataset_id.startswith("table."),
            description=f"Output dataset for {stage_name_hint}",
        )
        output_dataset.producer_stage_id = stage_id

        relation_scope: Dict[str, str] = {}
        source_relations: List[Tuple[str, str]] = []  # (dataset_id, alias) 保留原 SQL 别名, 渲染整条链路 SQL 用

        from_clause = select.args.get("from_")
        if from_clause and from_clause.this is not None:
            dataset_id, alias = self._process_relation(from_clause.this)
            source_relations.append((dataset_id, alias))
            relation_scope[alias] = dataset_id

        for join in select.args.get("joins", []):
            dataset_id, alias = self._process_relation(join.this)
            source_relations.append((dataset_id, alias))
            relation_scope[alias] = dataset_id

        source_dataset_ids: List[str] = [dataset_id for dataset_id, _ in source_relations]
        for input_order, (dataset_id, alias) in enumerate(source_relations, start=1):
            self.stage_inputs.append(
                StageInput(stage_id=stage_id, dataset_id=dataset_id, input_order=input_order, alias=alias)
            )

        for join in select.args.get("joins", []):
            join_id = self._unique_join_id(stage_id)
            left_dataset_id = source_dataset_ids[0] if source_dataset_ids else ""
            right_dataset_id = relation_scope.get(join.this.alias_or_name or "", "")
            join_type = " ".join(part for part in [str(join.args.get("side") or "").lower(), str(join.args.get("kind") or "join").lower()] if part).strip()
            self.stage_joins.append(
                StageJoin(
                    join_id=join_id,
                    stage_id=stage_id,
                    join_type=join_type or "join",
                    left_dataset_id=left_dataset_id,
                    right_dataset_id=right_dataset_id,
                    condition_sql=join.args.get("on").sql(dialect=self.dialect) if join.args.get("on") else "",
                    description="Parsed join condition",
                )
            )

        predicate_ord = 1
        for where_expr in self._extract_stage_predicates(select):
            self.stage_predicates.append(
                StagePredicate(
                    predicate_id=self._unique_predicate_id(stage_id),
                    stage_id=stage_id,
                    predicate_type=where_expr[0],
                    predicate_sql=where_expr[1],
                    ordinal_no=predicate_ord,
                    description=where_expr[2],
                )
            )
            predicate_ord += 1

        projection_lookup: Dict[str, str] = {}
        group_sqls = self._normalized_sql_set(group_expression.this if isinstance(group_expression, exp.Ordered) else group_expression for group_expression in self._group_expressions(select))

        for projection in select.expressions:
            field_name = projection.alias_or_name or projection.sql(dialect=self.dialect)
            field_role = self._infer_field_role(projection, field_name, group_sqls, is_final)
            expression_id = self._unique_expression_id(stage_id, field_name)
            source_field_ids = self._resolve_source_field_ids(projection, relation_scope)
            if projection.find(exp.AggFunc):
                # 所有聚合都同时依赖【值列】和【输入行集】。只追 SUM(CASE tag...)
                # 的 tag 会在常量 tag 处错误终止，却遗漏真正提供行的物理源表。
                for dataset_id in source_dataset_ids:
                    row_field_id = self._ensure_row_sentinel(dataset_id).field_id
                    if row_field_id not in source_field_ids:
                        source_field_ids.append(row_field_id)
            target_field = self._ensure_field(
                dataset_id=output_dataset_id,
                field_name=field_name,
                field_role=field_role,
                expression_id=expression_id,
            )
            self.field_expressions.append(
                FieldExpression(
                    expression_id=expression_id,
                    stage_id=stage_id,
                    expression_type=self._infer_expression_type(projection),
                    expression_sql=projection.sql(dialect=self.dialect),
                    source_field_ids=source_field_ids,
                    description="Parsed projection expression",
                )
            )
            projection_lookup[_sanitize_name(field_name)] = expression_id
            projection_lookup[self._normalize_sql(projection)] = expression_id
            for source_field_id in source_field_ids:
                self.field_lineage.append(
                    FieldLineage(
                        target_field_id=target_field.field_id,
                        source_field_id=source_field_id,
                        lineage_type=self._infer_lineage_type(projection),
                    )
                )

        for ordinal_no, group_expression in enumerate(self._group_expressions(select), start=1):
            normalized = self._normalize_sql(group_expression)
            expression_id = projection_lookup.get(normalized)
            if expression_id is None and isinstance(group_expression, exp.Column):
                expression_id = projection_lookup.get(_sanitize_name(group_expression.alias_or_name or group_expression.name))
            if expression_id is None:
                expression_id = self._unique_expression_id(stage_id, f"group_{ordinal_no}")
                self.field_expressions.append(
                    FieldExpression(
                        expression_id=expression_id,
                        stage_id=stage_id,
                        expression_type=self._infer_expression_type(group_expression),
                        expression_sql=group_expression.sql(dialect=self.dialect),
                        source_field_ids=self._resolve_source_field_ids(group_expression, relation_scope),
                        description="Synthetic group by expression",
                    )
                )
            self.stage_group_bys.append(
                StageGroupBy(stage_id=stage_id, expression_id=expression_id, ordinal_no=ordinal_no)
            )

        # 行级血缘: 本 stage 输出行 <= 各来源关系的行(放在投影之后, 复用可能已建的 '*' 真实列)
        self._link_output_rows(output_dataset_id, source_dataset_ids)

        stage_type = self._infer_stage_type(select, is_final)
        self.stages.append(
            Stage(
                stage_id=stage_id,
                job_id=self.job.job_id if self.job else "",
                stage_name=stage_name_hint,
                stage_type=stage_type,
                ordinal_no=self._next_ordinal(),
                description=f"Parsed from {stage_name_hint}",
                is_distinct=select.args.get("distinct") is not None,
            )
        )

    def _group_expressions(self, select: "exp.Select") -> List["exp.Expression"]:
        group = select.args.get("group")
        if not group:
            return []
        return list(group.expressions or [])

    def _extract_stage_predicates(self, select: "exp.Select") -> List[Tuple[PredicateType, str, str]]:
        predicates: List[Tuple[PredicateType, str, str]] = []
        where = select.args.get("where")
        if where is not None:
            predicates.append((PredicateType.WHERE, where.this.sql(dialect=self.dialect), "Parsed WHERE predicate"))
        having = select.args.get("having")
        if having is not None:
            predicates.append((PredicateType.HAVING, having.this.sql(dialect=self.dialect), "Parsed HAVING predicate"))
        return predicates

    def _attach_insert_partitions(self, insert: "exp.Insert") -> None:
        target_stage_id = None
        target_dataset_id = self._target_dataset_id(insert)
        for dataset in self.datasets:
            if dataset.dataset_id == target_dataset_id:
                target_stage_id = dataset.producer_stage_id
                break
        if not target_stage_id:
            return
        partition = insert.this.args.get("partition")
        if not partition:
            return
        start_no = len([item for item in self.stage_predicates if item.stage_id == target_stage_id]) + 1
        for offset, assignment in enumerate(partition.expressions or [], start=0):
            self.stage_predicates.append(
                StagePredicate(
                    predicate_id=self._unique_predicate_id(target_stage_id),
                    stage_id=target_stage_id,
                    predicate_type=PredicateType.PARTITION,
                    predicate_sql=assignment.sql(dialect=self.dialect),
                    ordinal_no=start_no + offset,
                    description="Parsed INSERT PARTITION binding",
                )
            )

    def _process_relation(self, relation: "exp.Expression") -> Tuple[str, str]:
        if isinstance(relation, exp.Subquery):
            alias = relation.alias_or_name or f"subquery_{len(self.datasets) + 1}"
            dataset = self._ensure_dataset(
                dataset_id=self._unique_dataset_id(alias),
                dataset_name=alias,
                dataset_type=DatasetType.SUBQUERY,
                job_id=self.job.job_id if self.job else "",
                is_materialized=False,
                description=f"Subquery {alias}",
            )
            self._process_query_expression(relation.this, dataset.dataset_id, alias, is_final=False)
            return dataset.dataset_id, alias
        if isinstance(relation, exp.Table):
            table_name = relation.name.lower()
            if table_name in self.cte_dataset_ids:
                return self.cte_dataset_ids[table_name], relation.alias_or_name or relation.name
            dataset = self._ensure_dataset(
                dataset_id=_dataset_id_for_table(relation),
                dataset_name=".".join(part for part in [relation.db, relation.name] if part),
                dataset_type=DatasetType.TABLE,
                database_name=relation.db,
                object_name=relation.name,
                is_materialized=True,
                description=f"Source table {relation.sql(dialect=self.dialect)}",
            )
            return dataset.dataset_id, relation.alias_or_name or relation.name
        if isinstance(relation, exp.Paren):
            return self._process_relation(relation.this)
        raise ValueError(f"Unsupported relation type: {type(relation).__name__}")

    def _ensure_row_sentinel(self, dataset_id: str) -> Field:
        """确保某数据集有行哨兵字段(*), 代表其行集。

        若该数据集已有名为 '*' 的字段(如 `SELECT *` 的真实投影), 直接复用它 ——
        避免与 (dataset_id, field_name) 唯一约束冲突, 语义上 `*` 也正是"整行"。
        """
        field_id = _row_sentinel_field_id(dataset_id)
        for field in self.fields:
            if field.field_id == field_id or (
                field.dataset_id == dataset_id and field.field_name == ROW_SENTINEL_NAME
            ):
                return field
        field = Field(
            field_id=field_id,
            dataset_id=dataset_id,
            field_name=ROW_SENTINEL_NAME,
            field_role=FieldRole.ATTRIBUTE,
            description="row sentinel (行级血缘)",
        )
        self.fields.append(field)
        return field

    def _link_output_rows(self, output_dataset_id: str, source_dataset_ids: List[str]) -> None:
        """输出行 <= 各来源关系的行(DERIVED), 支撑行级血缘一路递归到物理源表。"""
        output_row = self._ensure_row_sentinel(output_dataset_id)
        for source_dataset_id in source_dataset_ids:
            if source_dataset_id == output_dataset_id:
                continue
            source_row = self._ensure_row_sentinel(source_dataset_id)
            self.field_lineage.append(
                FieldLineage(
                    target_field_id=output_row.field_id,
                    source_field_id=source_row.field_id,
                    lineage_type=LineageType.DERIVED,
                )
            )

    def _ensure_field(
        self,
        dataset_id: str,
        field_name: str,
        field_role: FieldRole,
        expression_id: Optional[str] = None,
    ) -> Field:
        # 名为 '*' 的列(SELECT * / 行哨兵)统一用行哨兵 id, 避免与 (dataset_id, '*') 唯一约束撞车
        target_field_id = (
            _row_sentinel_field_id(dataset_id)
            if field_name == ROW_SENTINEL_NAME
            else _field_id(dataset_id, field_name)
        )
        for field in self.fields:
            if field.field_id == target_field_id:
                if expression_id and not field.expression_id:
                    field.expression_id = expression_id
                return field
        field = Field(
            field_id=target_field_id,
            dataset_id=dataset_id,
            field_name=field_name,
            field_role=field_role,
            expression_id=expression_id,
        )
        self.fields.append(field)
        return field

    def _resolve_source_field_ids(
        self,
        expression: "exp.Expression",
        relation_scope: Dict[str, str],
    ) -> List[str]:
        source_field_ids: List[str] = []
        for column in expression.find_all(exp.Column):
            dataset_id = None
            if column.table:
                dataset_id = relation_scope.get(column.table)
            if dataset_id is None:
                candidates = list(relation_scope.values())
                matching_datasets = [
                    dataset for dataset in candidates
                    if self._dataset_contains_field(dataset, column.name)
                ]
                if len(matching_datasets) == 1:
                    dataset_id = matching_datasets[0]
                elif len(candidates) == 1:
                    dataset_id = candidates[0]
            if dataset_id is None:
                continue
            source_field = self._ensure_field(dataset_id, column.name, FieldRole.ATTRIBUTE)
            self._materialize_wildcard_field(source_field)
            if source_field.field_id not in source_field_ids:
                source_field_ids.append(source_field.field_id)
        return source_field_ids

    def _dataset_contains_field(
        self,
        dataset_id: str,
        field_name: str,
        visited: Optional[Set[str]] = None,
    ) -> bool:
        if any(
            item.field_name == field_name
            for item in self._fields_for_dataset(dataset_id)
        ):
            return True
        visited = visited or set()
        if dataset_id in visited:
            return False
        visited.add(dataset_id)
        dataset = next(
            (item for item in self.datasets if item.dataset_id == dataset_id), None
        )
        if dataset is None:
            return False
        if dataset.dataset_type == DatasetType.TABLE:
            return (dataset.dataset_name, field_name) in self.known_fields

        wildcard = next(
            (
                item for item in self.fields
                if item.dataset_id == dataset_id
                and item.field_name == ROW_SENTINEL_NAME
                and item.expression_id is not None
            ),
            None,
        )
        if wildcard is None:
            return False
        wildcard_expression = next(
            (
                item for item in self.field_expressions
                if item.expression_id == wildcard.expression_id
            ),
            None,
        )
        if wildcard_expression is None:
            return False
        input_dataset_ids = [
            item.dataset_id for item in self.stage_inputs
            if item.stage_id == wildcard_expression.stage_id
        ]
        return any(
            self._dataset_contains_field(item, field_name, visited)
            for item in input_dataset_ids
        )

    def _materialize_wildcard_field(self, field: Field) -> None:
        """Resolve ``SELECT *`` lazily when an outer query requests a real column.

        sqlglot cannot expand ``*`` without catalog schema.  Once an outer query
        references ``subquery.some_col``, however, we know the requested name and
        can create a producer-scoped passthrough definition from each relation
        feeding the wildcard stage.
        """
        if field.expression_id is not None or field.field_name == ROW_SENTINEL_NAME:
            return
        wildcard = next(
            (
                item for item in self.fields
                if item.dataset_id == field.dataset_id
                and item.field_name == ROW_SENTINEL_NAME
                and item.expression_id is not None
            ),
            None,
        )
        if wildcard is None:
            return
        wildcard_expression = next(
            (
                item for item in self.field_expressions
                if item.expression_id == wildcard.expression_id
            ),
            None,
        )
        if wildcard_expression is None:
            return
        source_dataset_ids = [
            item.dataset_id for item in sorted(
                (
                    item for item in self.stage_inputs
                    if item.stage_id == wildcard_expression.stage_id
                ),
                key=lambda item: item.input_order,
            )
        ]
        if not source_dataset_ids:
            return

        source_fields = [
            self._ensure_field(dataset_id, field.field_name, FieldRole.ATTRIBUTE)
            for dataset_id in source_dataset_ids
        ]
        expression_id = self._unique_expression_id(
            wildcard_expression.stage_id, field.field_name
        )
        field.expression_id = expression_id
        self.field_expressions.append(
            FieldExpression(
                expression_id=expression_id,
                stage_id=wildcard_expression.stage_id,
                expression_type=ExpressionType.ALIAS,
                expression_sql=field.field_name,
                source_field_ids=[item.field_id for item in source_fields],
                description="Lazily expanded SELECT * passthrough",
            )
        )
        for source_field in source_fields:
            self.field_lineage.append(
                FieldLineage(
                    target_field_id=field.field_id,
                    source_field_id=source_field.field_id,
                    lineage_type=LineageType.DIRECT,
                )
            )

    def _fields_for_dataset(self, dataset_id: str) -> List[Field]:
        return [field for field in self.fields if field.dataset_id == dataset_id]

    def _infer_stage_type(self, select: "exp.Select", is_final: bool) -> StageType:
        if is_final:
            return StageType.FINAL
        if select.args.get("joins"):
            return StageType.JOIN
        if select.args.get("group"):
            return StageType.AGGREGATE
        from_clause = select.args.get("from_")
        if from_clause and isinstance(from_clause.this, exp.Table):
            return StageType.SOURCE
        return StageType.TRANSFORM

    def _dataset_type_from_id(self, dataset_id: str, is_final: bool) -> DatasetType:
        if dataset_id.startswith("table."):
            return DatasetType.TABLE
        if dataset_id.startswith("ds.") and "main_data" in dataset_id:
            return DatasetType.CTE
        if is_final and dataset_id.startswith("ds."):
            return DatasetType.TEMP
        return DatasetType.SUBQUERY

    def _normalize_sql(self, expression: "exp.Expression") -> str:
        return " ".join(expression.sql(dialect=self.dialect).lower().split())

    def _normalized_sql_set(self, expressions: Iterable["exp.Expression"]) -> set[str]:
        return {self._normalize_sql(expression) for expression in expressions}

    def _infer_field_role(
        self,
        projection: "exp.Expression",
        field_name: str,
        group_sqls: set[str],
        is_final: bool,
    ) -> FieldRole:
        normalized = self._normalize_sql(projection)
        if normalized in group_sqls or _sanitize_name(field_name) in group_sqls:
            return FieldRole.DIMENSION
        if projection.find(exp.AggFunc):
            return FieldRole.METRIC if is_final else FieldRole.ATTRIBUTE
        if field_name.lower().endswith("id"):
            return FieldRole.JOIN_KEY
        return FieldRole.ATTRIBUTE

    def _infer_expression_type(self, expression: "exp.Expression") -> ExpressionType:
        if isinstance(expression, exp.Column):
            return ExpressionType.SOURCE_COLUMN
        if isinstance(expression, exp.Alias):
            return self._infer_expression_type(expression.this)
        if expression.find(exp.Case):
            return ExpressionType.CASE_WHEN
        if expression.find(exp.AggFunc):
            return ExpressionType.AGGREGATION
        if expression.find(exp.Func):
            return ExpressionType.FUNCTION
        if isinstance(expression, exp.Literal):
            return ExpressionType.LITERAL
        return ExpressionType.UNKNOWN

    def _infer_lineage_type(self, expression: "exp.Expression") -> LineageType:
        if expression.find(exp.AggFunc):
            return LineageType.AGGREGATED
        if self._infer_expression_type(expression) in {ExpressionType.CASE_WHEN, ExpressionType.FUNCTION, ExpressionType.BINARY_OP, ExpressionType.UNKNOWN}:
            return LineageType.DERIVED
        return LineageType.DIRECT

    def _unique_predicate_id(self, stage_id: str) -> str:
        count = self._predicate_counts.get(stage_id, 0) + 1
        self._predicate_counts[stage_id] = count
        return f"pred.{_sanitize_name(stage_id)}_{count}"

    def _unique_join_id(self, stage_id: str) -> str:
        count = self._join_counts.get(stage_id, 0) + 1
        self._join_counts[stage_id] = count
        return f"join.{_sanitize_name(stage_id)}_{count}"

    def _unique_expression_id(self, stage_id: str, field_name: str) -> str:
        base = f"expr.{_sanitize_name(stage_id)}.{_sanitize_name(field_name)}"
        count = self._expression_counts.get(base, 0) + 1
        candidate = base if count == 1 else f"{base}_{count}"
        while candidate in self._issued_ids:
            count += 1
            candidate = f"{base}_{count}"
        self._expression_counts[base] = count
        self._issued_ids.add(candidate)
        return candidate

    def _add_semantic_documents(self) -> None:
        if not self.job:
            return
        self.semantic_documents.append(
            SemanticDocument(
                doc_id=f"doc.{_sanitize_name(self.job.job_name)}.summary",
                doc_type=DocumentType.SQL_SUMMARY,
                title=self.job.job_name,
                content=(
                    f"job={self.job.job_id}; stages={len(self.stages)}; datasets={len(self.datasets)}; "
                    f"fields={len(self.fields)}; write_mode={self.job.write_mode.value}"
                ),
                ref_type="job",
                ref_id=self.job.job_id,
                keywords=[self.job.job_name, self.job.write_mode.value],
            )
        )


def parse_sql_file_to_job_model(path: str | Path, dialect: str = "hive") -> JobModel:
    return SqlAstJobModelBuilder(dialect=dialect).parse_file(path)


def parse_sql_directory_to_job_models(directory: str | Path, dialect: str = "hive") -> List[JobModel]:
    return SqlAstJobModelBuilder(dialect=dialect).parse_directory(directory)


def job_model_to_json(model: JobModel) -> str:
    return dumps(asdict(model), ensure_ascii=False, indent=2)
