from __future__ import annotations

import json
import os
import re
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple

from .repository import PostgresJobModelRepository


TOKEN_RE = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)\b")
AS_ALIAS_RE = re.compile(r"\s+AS\s+[A-Za-z_][A-Za-z0-9_]*\s*$", re.IGNORECASE)
BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)


def _normalize_sql(sql: str) -> str:
    # 先剥块注释(GROUP BY 表达式常带内联 /* ... */, 否则与字段自身表达式归一化后不相等, 漏匹配维度列)
    sql = BLOCK_COMMENT_RE.sub("", sql)
    sql = AS_ALIAS_RE.sub("", sql.strip())
    return " ".join(sql.lower().split())


def _dataset_alias(dataset_name: str) -> str:
    return dataset_name.split(".")[-1]


@dataclass
class FieldMeta:
    field_id: str
    dataset_id: str
    dataset_name: str
    field_name: str
    expression_id: Optional[str]
    stage_id: Optional[str]
    expression_sql: Optional[str]
    source_field_ids: List[str] = field(default_factory=list)


@dataclass
class StageMeta:
    stage_id: str
    stage_name: str
    stage_type: str
    ordinal_no: int
    output_dataset_id: str
    output_dataset_name: str
    is_distinct: bool = False
    inputs: List[dict] = field(default_factory=list)
    joins: List[dict] = field(default_factory=list)
    predicates: List[dict] = field(default_factory=list)
    group_bys: List[dict] = field(default_factory=list)


class FieldLogicExtractor:
    def __init__(self, repo: PostgresJobModelRepository) -> None:
        self.repo = repo
        self.schema = repo.schema

    def _fetchall(self, sql: str, params: Tuple | List | None = None) -> List[tuple]:
        with self.repo.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params or ())
                return list(cur.fetchall())

    def resolve_target_field(self, dataset_name: str, field_name: str) -> dict:
        rows = self._fetchall(
            f"""
            select
              f.field_id,
              f.dataset_id,
              d.dataset_name,
              f.field_name,
              f.expression_id,
              e.stage_id,
              e.expression_sql,
              -- 物理表可能被多个 job 产出, dataset.job_id 与该字段表达式所属 stage 的 job 可能不一致。
              -- 重建 SQL 要用"产出该字段表达式的那个 job", 否则 fetch_job_metadata 里找不到它的 stage。
              coalesce(st.job_id, d.job_id) as job_id
            from {self.schema}.field f
            join {self.schema}.dataset d on d.dataset_id = f.dataset_id
            left join {self.schema}.field_expression e on e.expression_id = f.expression_id
            left join {self.schema}.stage st on st.stage_id = e.stage_id
            where d.dataset_name = %s and f.field_name = %s
            """,
            (dataset_name, field_name),
        )
        if not rows:
            raise ValueError(f"Field not found: {dataset_name}.{field_name}")
        row = rows[0]
        return {
            "field_id": row[0],
            "dataset_id": row[1],
            "dataset_name": row[2],
            "field_name": row[3],
            "expression_id": row[4],
            "stage_id": row[5],
            "expression_sql": row[6],
            "job_id": row[7],
        }

    def fetch_job_metadata(self, job_id: str) -> tuple[Dict[str, FieldMeta], Dict[str, StageMeta], Dict[Tuple[str, str], str]]:
        field_rows = self._fetchall(
            f"""
            select
              f.field_id,
              f.dataset_id,
              d.dataset_name,
              f.field_name,
              f.expression_id,
              e.stage_id,
              e.expression_sql,
              e.source_field_ids
            from {self.schema}.field f
            join {self.schema}.dataset d on d.dataset_id = f.dataset_id
            left join {self.schema}.field_expression e on e.expression_id = f.expression_id
            where d.job_id = %s
               or d.dataset_id in (
                    select distinct si.dataset_id
                    from {self.schema}.stage_input si
                    join {self.schema}.stage s on s.stage_id = si.stage_id
                    where s.job_id = %s
               )
            """,
            (job_id, job_id),
        )

        fields: Dict[str, FieldMeta] = {}
        field_by_dataset_name: Dict[Tuple[str, str], str] = {}
        for row in field_rows:
            source_field_ids = json.loads(row[7]) if row[7] else []
            fields[row[0]] = FieldMeta(
                field_id=row[0],
                dataset_id=row[1],
                dataset_name=row[2],
                field_name=row[3],
                expression_id=row[4],
                stage_id=row[5],
                expression_sql=row[6],
                source_field_ids=source_field_ids,
            )
            field_by_dataset_name[(row[1], row[3])] = row[0]

        stage_rows = self._fetchall(
            f"""
            select
              s.stage_id,
              s.stage_name,
              s.stage_type,
              s.ordinal_no,
              d.dataset_id,
              d.dataset_name,
              s.is_distinct
            from {self.schema}.stage s
            join {self.schema}.dataset d on d.producer_stage_id = s.stage_id
            where s.job_id = %s
            order by s.ordinal_no
            """,
            (job_id,),
        )
        stages: Dict[str, StageMeta] = {
            row[0]: StageMeta(
                stage_id=row[0],
                stage_name=row[1],
                stage_type=row[2],
                ordinal_no=row[3],
                output_dataset_id=row[4],
                output_dataset_name=row[5],
                is_distinct=bool(row[6]),
            )
            for row in stage_rows
        }

        input_rows = self._fetchall(
            f"""
            select
              si.stage_id,
              si.input_order,
              d.dataset_id,
              d.dataset_name,
              d.dataset_type,
              si.alias
            from {self.schema}.stage_input si
            join {self.schema}.stage s on s.stage_id = si.stage_id
            join {self.schema}.dataset d on d.dataset_id = si.dataset_id
            where s.job_id = %s
            order by s.ordinal_no, si.input_order
            """,
            (job_id,),
        )
        for row in input_rows:
            stages[row[0]].inputs.append(
                {
                    "input_order": row[1],
                    "dataset_id": row[2],
                    "dataset_name": row[3],
                    "dataset_type": row[4],
                    # 优先用建模持久化的原 SQL 别名; 回退到数据集名末段(兼容旧数据)
                    "alias": row[5] or _dataset_alias(row[3]),
                }
            )

        join_rows = self._fetchall(
            f"""
            select
              j.stage_id,
              j.join_type,
              j.left_dataset_id,
              ld.dataset_name,
              j.right_dataset_id,
              rd.dataset_name,
              j.condition_sql
            from {self.schema}.stage_join j
            join {self.schema}.stage s on s.stage_id = j.stage_id
            join {self.schema}.dataset ld on ld.dataset_id = j.left_dataset_id
            join {self.schema}.dataset rd on rd.dataset_id = j.right_dataset_id
            where s.job_id = %s
            order by s.ordinal_no, j.join_id
            """,
            (job_id,),
        )
        for row in join_rows:
            stages[row[0]].joins.append(
                {
                    "join_type": row[1],
                    "left_dataset_id": row[2],
                    "left_dataset_name": row[3],
                    "right_dataset_id": row[4],
                    "right_dataset_name": row[5],
                    "condition_sql": row[6],
                }
            )

        predicate_rows = self._fetchall(
            f"""
            select
              p.stage_id,
              p.predicate_type,
              p.predicate_sql,
              p.ordinal_no
            from {self.schema}.stage_predicate p
            join {self.schema}.stage s on s.stage_id = p.stage_id
            where s.job_id = %s
            order by s.ordinal_no, p.ordinal_no
            """,
            (job_id,),
        )
        for row in predicate_rows:
            stages[row[0]].predicates.append(
                {
                    "predicate_type": row[1],
                    "predicate_sql": row[2],
                    "ordinal_no": row[3],
                }
            )

        group_rows = self._fetchall(
            f"""
            select
              g.stage_id,
              g.expression_id,
              g.ordinal_no,
              e.expression_sql
            from {self.schema}.stage_group_by g
            join {self.schema}.stage s on s.stage_id = g.stage_id
            join {self.schema}.field_expression e on e.expression_id = g.expression_id
            where s.job_id = %s
            order by s.ordinal_no, g.ordinal_no
            """,
            (job_id,),
        )
        for row in group_rows:
            stages[row[0]].group_bys.append(
                {
                    "expression_id": row[1],
                    "ordinal_no": row[2],
                    "expression_sql": row[3],
                }
            )

        return fields, stages, field_by_dataset_name

    def fetch_recursive_lineage(self, target_field_id: str) -> List[dict]:
        rows = self._fetchall(
            f"""
            with recursive lineage as (
              select
                1 as depth,
                l.target_field_id,
                l.source_field_id,
                l.lineage_type,
                array[l.target_field_id, l.source_field_id] as path
              from {self.schema}.field_lineage l
              where l.target_field_id = %s
              union all
              select
                lineage.depth + 1,
                l.target_field_id,
                l.source_field_id,
                l.lineage_type,
                lineage.path || l.source_field_id
              from {self.schema}.field_lineage l
              join lineage on l.target_field_id = lineage.source_field_id
              -- 环检测 + 深度上限: 行哨兵在共享物理表节点上易成环, 否则递归 CTE 会无限展开
              where lineage.depth < 30
                and not l.source_field_id = any(lineage.path)
            )
            select distinct on (edge.target_field_id, edge.source_field_id)
              edge.depth,
              edge.target_field_id,
              tf.field_name,
              td.dataset_name,
              te.expression_sql,
              edge.source_field_id,
              sf.field_name,
              sd.dataset_name,
              se.expression_sql,
              edge.lineage_type
            from lineage edge
            join {self.schema}.field tf on tf.field_id = edge.target_field_id
            join {self.schema}.dataset td on td.dataset_id = tf.dataset_id
            left join {self.schema}.field_expression te on te.expression_id = tf.expression_id
            join {self.schema}.field sf on sf.field_id = edge.source_field_id
            join {self.schema}.dataset sd on sd.dataset_id = sf.dataset_id
            left join {self.schema}.field_expression se on se.expression_id = sf.expression_id
            order by edge.target_field_id, edge.source_field_id, edge.depth
            """,
            (target_field_id,),
        )
        items = [
            {
                "depth": row[0],
                "target_field_id": row[1],
                "target_field_name": row[2],
                "target_dataset_name": row[3],
                "target_expression_sql": row[4],
                "source_field_id": row[5],
                "source_field_name": row[6],
                "source_dataset_name": row[7],
                "source_expression_sql": row[8],
                "lineage_type": row[9],
            }
            for row in rows
        ]
        # SQL 里按 (target, source) 去重, 这里回到按深度展示
        items.sort(key=lambda item: (item["depth"], item["target_dataset_name"], item["source_dataset_name"]))
        return items

    def _groupby_field_ids(self, stage: StageMeta, fields: Dict[str, FieldMeta]) -> Set[str]:
        output_field_ids = {
            field.field_id
            for field in fields.values()
            if field.dataset_id == stage.output_dataset_id
        }
        matched: Set[str] = set()
        for group_item in stage.group_bys:
            normalized_group = _normalize_sql(group_item["expression_sql"])
            for field_id in output_field_ids:
                field = fields[field_id]
                if field.expression_id == group_item["expression_id"]:
                    matched.add(field_id)
                    break
                if field.expression_sql and _normalize_sql(field.expression_sql) == normalized_group:
                    matched.add(field_id)
                    break
        return matched

    def _join_condition_field_ids(
        self,
        stage: StageMeta,
        included_dataset_ids: Set[str],
        field_by_dataset_name: Dict[Tuple[str, str], str],
    ) -> Set[str]:
        alias_to_dataset = {item["alias"]: item["dataset_id"] for item in stage.inputs}
        required: Set[str] = set()
        for join in stage.joins:
            if join["right_dataset_id"] not in included_dataset_ids:
                continue
            for alias, field_name in TOKEN_RE.findall(join["condition_sql"]):
                dataset_id = alias_to_dataset.get(alias)
                if dataset_id and dataset_id in {join["left_dataset_id"], join["right_dataset_id"]}:
                    field_id = field_by_dataset_name.get((dataset_id, field_name))
                    if field_id:
                        required.add(field_id)
        return required

    def _predicate_referenced_dataset_ids(self, stage: StageMeta) -> Set[str]:
        """WHERE/HAVING 谓词里通过别名引用到的输入数据集(如反连 `WHERE b.roleid IS NULL` 的 b)。"""
        alias_to_dataset = {item["alias"]: item["dataset_id"] for item in stage.inputs}
        result: Set[str] = set()
        for predicate in stage.predicates:
            if predicate["predicate_type"] not in ("where", "having"):
                continue
            for alias, _field_name in TOKEN_RE.findall(predicate["predicate_sql"] or ""):
                dataset_id = alias_to_dataset.get(alias)
                if dataset_id:
                    result.add(dataset_id)
        return result

    def _predicate_referenced_field_ids(
        self,
        stage: StageMeta,
        included_dataset_ids: Set[str],
        field_by_dataset_name: Dict[Tuple[str, str], str],
    ) -> Set[str]:
        """谓词里引用的、且属于已纳入数据集的列(保证反连表投影出被过滤的列)。"""
        alias_to_dataset = {item["alias"]: item["dataset_id"] for item in stage.inputs}
        required: Set[str] = set()
        for predicate in stage.predicates:
            if predicate["predicate_type"] not in ("where", "having"):
                continue
            for alias, field_name in TOKEN_RE.findall(predicate["predicate_sql"] or ""):
                dataset_id = alias_to_dataset.get(alias)
                if dataset_id and dataset_id in included_dataset_ids:
                    field_id = field_by_dataset_name.get((dataset_id, field_name))
                    if field_id:
                        required.add(field_id)
        return required

    def _required_field_closure(
        self,
        target_field_id: str,
        fields: Dict[str, FieldMeta],
        stages: Dict[str, StageMeta],
        field_by_dataset_name: Dict[Tuple[str, str], str],
    ) -> Set[str]:
        required_fields: Set[str] = {target_field_id}
        changed = True
        while changed:
            changed = False
            stage_to_required_output_fields: Dict[str, Set[str]] = {}
            for field_id in list(required_fields):
                field = fields.get(field_id)
                if not field or not field.stage_id:
                    continue
                stage = stages.get(field.stage_id)
                if stage is None:
                    # 该字段的 stage 属于别的 job(多生产者物理列), 本 job 元数据里没有 → 跳过
                    continue
                stage_to_required_output_fields.setdefault(stage.stage_id, set()).add(field_id)

                for source_field_id in field.source_field_ids:
                    if source_field_id not in required_fields:
                        required_fields.add(source_field_id)
                        changed = True

                for group_field_id in self._groupby_field_ids(stage, fields):
                    if group_field_id not in required_fields:
                        required_fields.add(group_field_id)
                        changed = True

                sibling_fields = [
                    candidate
                    for candidate in fields.values()
                    if candidate.dataset_id == field.dataset_id
                    and candidate.field_id not in required_fields
                    and candidate.source_field_ids
                    and all(source_field_id in required_fields for source_field_id in candidate.source_field_ids)
                ]
                for sibling in sibling_fields:
                    required_fields.add(sibling.field_id)
                    changed = True

            for stage_id, output_field_ids in stage_to_required_output_fields.items():
                stage = stages[stage_id]
                included_input_datasets = {
                    fields[source_field_id].dataset_id
                    for field_id in output_field_ids
                    for source_field_id in fields[field_id].source_field_ids
                    if source_field_id in fields
                }
                # 谓词引用的关系也纳入(反连表 b 等): 否则会剪掉 b-join 却留下悬空 `WHERE b.x IS NULL`。
                included_input_datasets |= self._predicate_referenced_dataset_ids(stage)
                for join in stage.joins:
                    if join["right_dataset_id"] in included_input_datasets:
                        included_input_datasets.add(join["left_dataset_id"])
                        included_input_datasets.add(join["right_dataset_id"])
                for join_field_id in self._join_condition_field_ids(stage, included_input_datasets, field_by_dataset_name):
                    if join_field_id not in required_fields:
                        required_fields.add(join_field_id)
                        changed = True
                for pred_field_id in self._predicate_referenced_field_ids(stage, included_input_datasets, field_by_dataset_name):
                    if pred_field_id not in required_fields:
                        required_fields.add(pred_field_id)
                        changed = True
        return required_fields

    def _stage_required_inputs(
        self,
        stage: StageMeta,
        required_output_fields: List[FieldMeta],
        fields: Dict[str, FieldMeta],
    ) -> Set[str]:
        dataset_ids = {
            fields[source_field_id].dataset_id
            for field in required_output_fields
            for source_field_id in field.source_field_ids
            if source_field_id in fields
        }
        # 谓词引用的关系(反连表 b 等)也必须在 FROM/JOIN 里, 否则 `WHERE b.x IS NULL` 悬空。
        dataset_ids |= self._predicate_referenced_dataset_ids(stage)
        for join in stage.joins:
            if join["right_dataset_id"] in dataset_ids:
                dataset_ids.add(join["left_dataset_id"])
                dataset_ids.add(join["right_dataset_id"])
        if not dataset_ids and stage.inputs:
            dataset_ids.add(stage.inputs[0]["dataset_id"])
        return dataset_ids

    @staticmethod
    def _cte_name_for(output_dataset_name: str, used: Set[str]) -> str:
        """给 CTE 起唯一名(同名 dataset 加 _N 后缀), 避免 WITH 里重名。"""
        base = _dataset_alias(output_dataset_name)
        name, n = base, 1
        while name in used:
            n += 1
            name = f"{base}_{n}"
        used.add(name)
        return name

    def _rel(self, inp: dict, cte_names: Dict[str, str]) -> str:
        """把一个输入关系渲染成 `<CTE名或物理表名> AS <原别名>`。"""
        dataset_id = inp["dataset_id"]
        alias = inp.get("alias")
        if dataset_id in cte_names:
            name = cte_names[dataset_id]
        elif dataset_id.startswith("table."):
            name = inp["dataset_name"]  # 物理源表, 直接引用全名
        else:
            name = _dataset_alias(inp["dataset_name"])
        return f"{name} AS {alias}" if alias and alias != name else name

    @staticmethod
    def _is_row_sentinel(field: FieldMeta) -> bool:
        """行哨兵字段(名为 '*'): 只用于行级血缘, 不作为真实列参与 SQL 投影。"""
        return field.field_name == "*" or field.field_id.endswith(".__rows__")

    @staticmethod
    def _is_union_stage(stage: StageMeta, fields: Dict[str, FieldMeta]) -> bool:
        return any(
            field.dataset_id == stage.output_dataset_id
            and field.expression_sql
            and field.expression_sql.startswith("UNION_BRANCH_COLUMN")
            for field in fields.values()
        )

    def _render_union_stage(
        self,
        stage: StageMeta,
        output_fields: List[FieldMeta],
        fields: Dict[str, FieldMeta],
        cte_names: Dict[str, str],
        cte_name: str,
    ) -> str:
        """UNION stage: 各分支拼 UNION [ALL], 用 union 输出列的 source_field_ids 还原每支对应列。"""
        union_cols = sorted(
            [field for field in output_fields if not self._is_row_sentinel(field)],
            key=lambda item: item.field_name,
        )
        if not union_cols:
            return None
        selects: List[str] = []
        for branch in sorted(stage.inputs, key=lambda item: item["input_order"]):
            branch_ds = branch["dataset_id"]
            projections: List[str] = []
            for col in union_cols:
                source_id = next(
                    (sid for sid in col.source_field_ids if sid in fields and fields[sid].dataset_id == branch_ds),
                    None,
                )
                if source_id:
                    source_name = fields[source_id].field_name
                    projections.append(source_name if source_name == col.field_name else f"{source_name} AS {col.field_name}")
                else:
                    projections.append(f"NULL AS {col.field_name}")
            ref = cte_names.get(branch_ds) or (
                branch["dataset_name"] if branch_ds.startswith("table.") else _dataset_alias(branch["dataset_name"])
            )
            selects.append("SELECT\n        " + ",\n        ".join(projections) + f"\n    FROM {ref}")
        set_op = "\n    UNION\n    " if stage.is_distinct else "\n    UNION ALL\n    "
        return f"{cte_name} AS (\n    " + set_op.join(selects) + "\n)"

    def _render_stage_sql(
        self,
        stage: StageMeta,
        required_fields: Set[str],
        fields: Dict[str, FieldMeta],
        cte_names: Dict[str, str],
    ) -> Optional[str]:
        output_fields = [
            field
            for field in fields.values()
            if field.dataset_id == stage.output_dataset_id and field.field_id in required_fields
        ]
        if not output_fields:
            return None

        cte_name = cte_names[stage.output_dataset_id]
        if self._is_union_stage(stage, fields):
            return self._render_union_stage(stage, output_fields, fields, cte_names, cte_name)

        # 行哨兵只用于血缘, 不作真实列投影; 若某关系只因被计数(行哨兵)而入选、无具体列,
        # 回退投影它的全部真实列, 避免产出空 CTE / 悬空引用。
        real_output_fields = [field for field in output_fields if not self._is_row_sentinel(field)]
        if not real_output_fields:
            real_output_fields = [
                field
                for field in fields.values()
                if field.dataset_id == stage.output_dataset_id and not self._is_row_sentinel(field)
            ]
            if not real_output_fields:
                return None

        input_dataset_ids = self._stage_required_inputs(stage, real_output_fields, fields)
        inputs = [item for item in stage.inputs if item["dataset_id"] in input_dataset_ids]
        if not inputs:
            return None
        inputs.sort(key=lambda item: item["input_order"])

        select_sql = ",\n        ".join(
            field.expression_sql or field.field_name for field in sorted(real_output_fields, key=lambda item: item.field_name)
        )
        distinct = "DISTINCT " if stage.is_distinct else ""
        base_input = inputs[0]
        lines = [
            f"{cte_name} AS (",
            f"    SELECT {distinct}".rstrip(),
            f"        {select_sql}",
            f"    FROM {self._rel(base_input, cte_names)}",
        ]

        for join in stage.joins:
            if join["right_dataset_id"] not in input_dataset_ids:
                continue
            right_input = next((item for item in inputs if item["dataset_id"] == join["right_dataset_id"]), None)
            if right_input is None:
                continue
            lines.append(f"    {join['join_type'].upper()} {self._rel(right_input, cte_names)}")
            lines.append(f"        ON {join['condition_sql']}")

        where_predicates = [
            item["predicate_sql"]
            for item in stage.predicates
            if item["predicate_type"] == "where"
        ]
        if where_predicates:
            lines.append(f"    WHERE {' AND '.join(where_predicates)}")

        if stage.group_bys:
            # GROUP BY 项不能带 select 别名(部分 expression_sql 存的是 "expr AS alias"),
            # 渲染前剥掉尾部 AS,否则产出非法 SQL。
            group_sql = ", ".join(
                AS_ALIAS_RE.sub("", item["expression_sql"].strip())
                for item in stage.group_bys
            )
            lines.append(f"    GROUP BY {group_sql}")

        lines.append(")")
        return "\n".join(lines)

    def extract_dimensions(
        self,
        target_field_id: str,
        fields: Dict[str, FieldMeta],
        stages: Dict[str, StageMeta],
    ) -> List[dict]:
        """指标可分析的维度 = 产出该指标的聚合 stage 的 GROUP BY 输出列。

        从目标字段沿 source_field_ids 下钻, 遇到第一个带 GROUP BY 的 stage 即聚合边界,
        取该 stage 的 GROUP BY 输出列作为维度, 不再继续下钻。返回按发现顺序去重的维度列表:
        {field_name, expression_sql, source_dataset_name}。明细/直投(无聚合边界)返回 []。
        """
        seen: Set[str] = set()
        stack: List[str] = [target_field_id]
        dims: Dict[str, dict] = {}
        while stack:
            field_id = stack.pop()
            if field_id in seen or field_id not in fields:
                continue
            seen.add(field_id)
            field = fields[field_id]
            stage = stages.get(field.stage_id) if field.stage_id else None
            if stage is not None and stage.group_bys:
                # 聚合边界: 收集 GROUP BY 输出列, 不再下钻
                for group_field_id in self._groupby_field_ids(stage, fields):
                    group_field = fields[group_field_id]
                    if self._is_row_sentinel(group_field):
                        continue
                    dims.setdefault(
                        group_field.field_name,
                        {
                            "field_name": group_field.field_name,
                            "expression_sql": group_field.expression_sql,
                            "source_dataset_name": stage.output_dataset_name,
                        },
                    )
                continue
            stack.extend(field.source_field_ids)
        return list(dims.values())

    def build_candidate_sql(self, target_field_id: str, job_id: str) -> tuple[List[dict], str]:
        fields, stages, field_by_dataset_name = self.fetch_job_metadata(job_id)
        required_fields = self._required_field_closure(target_field_id, fields, stages, field_by_dataset_name)
        lineage = self.fetch_recursive_lineage(target_field_id)

        # 只保留"输出数据集里含 required 列"的 stage; 按 ordinal 排序后为每个分配唯一 CTE 名。
        required_output_datasets = {
            fields[field_id].dataset_id for field_id in required_fields if field_id in fields
        }
        included_stages = [
            stage
            for stage in sorted(stages.values(), key=lambda item: item.ordinal_no)
            if stage.output_dataset_id in required_output_datasets
        ]
        used_names: Set[str] = set()
        cte_names: Dict[str, str] = {}
        for stage in included_stages:
            cte_names[stage.output_dataset_id] = self._cte_name_for(stage.output_dataset_name, used_names)

        stage_sqls: List[str] = []
        for stage in included_stages:
            sql = self._render_stage_sql(stage, required_fields, fields, cte_names)
            if sql:
                stage_sqls.append(sql)

        target_field = fields[target_field_id]
        target_cte = cte_names.get(target_field.dataset_id) or _dataset_alias(target_field.dataset_name)

        # 该指标的可分析维度: 聚合 stage 的 GROUP BY 输出列。
        dimensions = self.extract_dimensions(target_field_id, fields, stages)
        # 只有"确实是 target_cte 输出列(在 required_fields 里、且同属目标数据集)"的维度才投影进最外层 SELECT,
        # 否则(如跨 CTE 拼装时挂在内层的 JOIN 键)投影会产生悬空列引用 → 只写进头注释。
        target_cte_columns = {
            fields[field_id].field_name
            for field_id in required_fields
            if field_id in fields and fields[field_id].dataset_id == target_field.dataset_id
        }
        projected_dims = [
            dim["field_name"]
            for dim in dimensions
            if dim["field_name"] in target_cte_columns and dim["field_name"] != target_field.field_name
        ]
        # 维度列在前、指标在后(去重), 让重建 SQL 直接可按维度 GROUP BY 分析。
        select_cols = [f"{target_cte}.{name}" for name in projected_dims]
        select_cols.append(f"{target_cte}.{target_field.field_name}")
        final_select = ",\n    ".join(select_cols)

        header = ""
        if dimensions:
            header = "-- 可分析维度: " + ", ".join(dim["field_name"] for dim in dimensions) + "\n"

        sql = header + "WITH\n" + ",\n".join(stage_sqls) + f"\nSELECT\n    {final_select}\nFROM {target_cte};"
        return lineage, sql


def build_repository_from_env() -> PostgresJobModelRepository:
    """连 metadata_kb 的 lineage schema(连接/库名走 settings/.env)。"""
    return PostgresJobModelRepository()


def main() -> None:
    dataset_name = os.getenv("TARGET_DATASET", "mt_ads.ads_area_operate_analyse_di_temp")
    field_name = os.getenv("TARGET_FIELD", "mau_30d")

    extractor = FieldLogicExtractor(build_repository_from_env())
    target = extractor.resolve_target_field(dataset_name, field_name)
    lineage, sql = extractor.build_candidate_sql(target["field_id"], target["job_id"])

    print("Field:")
    print(f"- {dataset_name}.{field_name}")
    print("\nLineage:")
    for item in lineage:
        print(
            f"- depth={item['depth']} {item['target_dataset_name']}.{item['target_field_name']}"
            f" <= {item['source_dataset_name']}.{item['source_field_name']}"
            f" [{item['lineage_type']}]"
        )
        if item["target_expression_sql"]:
            print(f"  target_expr: {item['target_expression_sql']}")
        if item["source_expression_sql"]:
            print(f"  source_expr: {item['source_expression_sql']}")

    print("\nCandidate SQL:")
    print(sql)


if __name__ == "__main__":
    main()
