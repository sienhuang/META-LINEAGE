from __future__ import annotations

import json
import hashlib
import re
from pathlib import Path
from typing import Iterable, Sequence

import psycopg2

from .. import settings
from .canonical_models import JobModel

SCHEMA_SQL_PATH = Path(__file__).resolve().parent / "er_schema.sql"
SAFE_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def _stable_id(prefix: str, *parts: str) -> str:
    """Build a compact, deterministic identifier without leaking SQL text into PKs."""
    payload = "\x1f".join(parts).encode("utf-8")
    return f"{prefix}.{hashlib.sha256(payload).hexdigest()[:24]}"


def build_provenance_records(model: JobModel) -> dict[str, list[dict]]:
    """Derive the V2 multi-producer records from a canonical ``JobModel``.

    A definition belongs to a concrete (job, stage, dataset) production, so two
    jobs writing the same canonical physical field no longer overwrite each
    other's expression or dependencies.
    """
    stages = {item.stage_id: item for item in model.stages}
    expressions = {item.expression_id: item for item in model.field_expressions}
    fields = {item.field_id: item for item in model.fields}
    produced_datasets = [
        item for item in model.datasets if item.producer_stage_id in stages
    ]

    productions: list[dict] = []
    definitions: list[dict] = []
    dependencies: list[dict] = []
    definition_by_target: dict[str, str] = {}

    for dataset in produced_datasets:
        stage_id = dataset.producer_stage_id or ""
        production_id = _stable_id(
            "production", model.job.job_id, stage_id, dataset.dataset_id
        )
        productions.append({
            "production_id": production_id,
            "dataset_id": dataset.dataset_id,
            "job_id": model.job.job_id,
            "stage_id": stage_id,
            "write_mode": model.job.write_mode.value,
            "is_materialized": dataset.is_materialized,
            "is_current": True,
            "source_instance_id": None,
        })

        ordinal_no = 0
        for field_item in model.fields:
            if field_item.dataset_id != dataset.dataset_id:
                continue
            ordinal_no += 1
            expression = expressions.get(field_item.expression_id or "")
            definition_id = _stable_id(
                "definition", production_id, field_item.field_id
            )
            definition_by_target[field_item.field_id] = definition_id
            definitions.append({
                "definition_id": definition_id,
                "production_id": production_id,
                "field_id": field_item.field_id,
                "expression_id": field_item.expression_id,
                "expression_sql": expression.expression_sql if expression else None,
                "expression_type": expression.expression_type.value if expression else None,
                "ordinal_no": ordinal_no,
            })

    source_ordinals: dict[str, int] = {}
    for lineage in model.field_lineage:
        definition_id = definition_by_target.get(lineage.target_field_id)
        if definition_id is None:
            continue
        source_ordinals[definition_id] = source_ordinals.get(definition_id, 0) + 1
        target = fields.get(lineage.target_field_id)
        source = fields.get(lineage.source_field_id)
        expression = expressions.get(target.expression_id or "") if target else None
        if (target and target.field_name == "*") or (source and source.field_name == "*"):
            dependency_type = "rowset"
        elif expression and expression.expression_sql.startswith("UNION_BRANCH_COLUMN"):
            dependency_type = "union"
        else:
            dependency_type = "value"
        lineage_type = lineage.lineage_type.value
        dependencies.append({
            "edge_id": _stable_id(
                "dependency", definition_id, lineage.source_field_id,
                dependency_type, lineage_type,
            ),
            "target_definition_id": definition_id,
            "source_field_id": lineage.source_field_id,
            "dependency_type": dependency_type,
            "lineage_type": lineage_type,
            "source_ordinal": source_ordinals[definition_id],
        })

    unique_dependencies: dict[str, dict] = {}
    for item in dependencies:
        unique_dependencies.setdefault(item["edge_id"], item)
    dependency_ordinals: dict[str, int] = {}
    deduplicated_dependencies: list[dict] = []
    for item in unique_dependencies.values():
        target_id = item["target_definition_id"]
        dependency_ordinals[target_id] = dependency_ordinals.get(target_id, 0) + 1
        item["source_ordinal"] = dependency_ordinals[target_id]
        deduplicated_dependencies.append(item)

    return {
        "productions": productions,
        "definitions": definitions,
        "dependencies": deduplicated_dependencies,
    }


class PostgresJobModelRepository:
    """完整 JobModel 落库到 metadata_kb 的某个 schema(默认 settings.LINEAGE_SCHEMA)。

    连接走 settings.PG_DSN(.env 配置)。SQL 与 rag_lineage 同构(psycopg2 兼容)。
    """

    def __init__(self, dsn: str | None = None, schema: str | None = None) -> None:
        schema = schema or settings.LINEAGE_SCHEMA
        if not SAFE_IDENTIFIER.fullmatch(schema):
            raise ValueError(f"Unsafe schema name: {schema}")
        self.dsn = dsn or settings.PG_DSN
        self.schema = schema

    def connect(self):
        return psycopg2.connect(self.dsn)

    def ensure_schema(self) -> None:
        ddl = SCHEMA_SQL_PATH.read_text(encoding="utf-8")
        ddl = ddl.replace("metadata.", f"{self.schema}.")
        ddl = ddl.replace("create schema if not exists metadata;", f"create schema if not exists {self.schema};")
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(ddl)
            conn.commit()

    def upsert_models(self, models: Sequence[JobModel]) -> None:
        if not models:
            return
        self.ensure_schema()
        with self.connect() as conn:
            with conn.cursor() as cur:
                for model in models:
                    self._delete_existing_model(cur, model)
                    self._insert_job_model(cur, model)
            conn.commit()

    def replace_provenance_models(self, models: Sequence[JobModel]) -> None:
        """Replace only V2 provenance rows for already-persisted JobModels.

        This is used to backfill the producer-scoped model from ``job.raw_sql``
        without rewriting legacy lineage.  Parser upgrades may discover fields
        or expressions that the old parser missed (notably lazy ``SELECT *``
        columns), so missing canonical parent rows are inserted with
        ``on conflict do nothing`` before V2 rows are replaced.
        """
        if not models:
            return
        with self.connect() as conn:
            with conn.cursor() as cur:
                for model in models:
                    self._insert_missing_provenance_parents(cur, model)
                    cur.execute(
                        f"delete from {self.schema}.dataset_production where job_id = %s",
                        (model.job.job_id,),
                    )
                    self._insert_provenance_v2(cur, model)
            conn.commit()

    def _insert_missing_provenance_parents(self, cur, model: JobModel) -> None:
        from psycopg2.extras import execute_values

        if model.fields:
            execute_values(
                cur,
                f"""
                insert into {self.schema}.field
                (field_id, dataset_id, field_name, field_role, expression_id,
                 data_type, description)
                values %s
                on conflict (field_id) do nothing
                """,
                [
                    (
                        item.field_id, item.dataset_id, item.field_name,
                        item.field_role.value, item.expression_id, item.data_type,
                        item.description,
                    )
                    for item in model.fields
                ], page_size=1000,
            )
        if model.field_expressions:
            execute_values(
                cur,
                f"""
                insert into {self.schema}.field_expression
                (expression_id, stage_id, expression_type, expression_sql,
                 source_field_ids, depends_on_expression_ids, description)
                values %s
                on conflict (expression_id) do nothing
                """,
                [
                    (
                        item.expression_id, item.stage_id,
                        item.expression_type.value, item.expression_sql,
                        json.dumps(item.source_field_ids, ensure_ascii=False),
                        json.dumps(item.depends_on_expression_ids, ensure_ascii=False),
                        item.description,
                    )
                    for item in model.field_expressions
                ], page_size=1000,
            )

    def _delete_existing_model(self, cur, model: JobModel) -> None:
        job_id = model.job.job_id
        # 幂等重灌: 只删本 job "拥有"的 field_lineage 边 —— 即 target 落在本 job 产出字段上的边。
        # 不能按 model.fields 全集删(含本 job 当源引用的物理列): 那会把生产者建立的入边
        # (如 t3.active_cnt -> mt_ads.x.active_cnt) 在下游消费者重灌时一并删掉, 且 source 侧亦然。
        job_stage_ids = {stage.stage_id for stage in model.stages}
        produced_dataset_ids = {
            dataset.dataset_id
            for dataset in model.datasets
            if dataset.producer_stage_id in job_stage_ids
        }
        produced_field_ids = [
            field.field_id
            for field in model.fields
            if field.dataset_id in produced_dataset_ids
        ]
        if produced_field_ids:
            cur.execute(
                f"""
                delete from {self.schema}.field_lineage
                where target_field_id = any(%s)
                """,
                (produced_field_ids,),
            )
        cur.execute(
            f"delete from {self.schema}.stage where job_id = %s",
            (job_id,),
        )
        cur.execute(
            f"delete from {self.schema}.dataset where job_id = %s and is_materialized = false",
            (job_id,),
        )
        cur.execute(
            f"delete from {self.schema}.semantic_document where ref_type = 'job' and ref_id = %s",
            (job_id,),
        )

    def _insert_job_model(self, cur, model: JobModel) -> None:
        cur.execute(
            f"""
            insert into {self.schema}.job
            (job_id, job_name, engine, write_mode, schedule, owner, raw_sql, description)
            values (%s, %s, %s, %s, %s, %s, %s, %s)
            on conflict (job_id) do update set
              job_name = excluded.job_name,
              engine = excluded.engine,
              write_mode = excluded.write_mode,
              schedule = excluded.schedule,
              owner = excluded.owner,
              raw_sql = excluded.raw_sql,
              description = excluded.description
            """,
            (
                model.job.job_id,
                model.job.job_name,
                model.job.engine,
                model.job.write_mode.value,
                model.job.schedule,
                model.job.owner,
                model.job.raw_sql,
                model.job.description,
            ),
        )

        cur.executemany(
            f"""
            insert into {self.schema}.stage
            (stage_id, job_id, stage_name, stage_type, ordinal_no, description, is_distinct)
            values (%s, %s, %s, %s, %s, %s, %s)
            on conflict (stage_id) do update set
              job_id = excluded.job_id,
              stage_name = excluded.stage_name,
              stage_type = excluded.stage_type,
              ordinal_no = excluded.ordinal_no,
              description = excluded.description,
              is_distinct = excluded.is_distinct
            """,
            [
                (
                    item.stage_id,
                    item.job_id,
                    item.stage_name,
                    item.stage_type.value,
                    item.ordinal_no,
                    item.description,
                    item.is_distinct,
                )
                for item in model.stages
            ],
        )

        cur.executemany(
            f"""
            insert into {self.schema}.dataset
            (dataset_id, job_id, dataset_name, dataset_type, database_name, object_name, producer_stage_id, is_materialized, description)
            values (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            on conflict (dataset_id) do update set
              job_id = coalesce(excluded.job_id, {self.schema}.dataset.job_id),
              dataset_name = excluded.dataset_name,
              dataset_type = excluded.dataset_type,
              database_name = coalesce(excluded.database_name, {self.schema}.dataset.database_name),
              object_name = coalesce(excluded.object_name, {self.schema}.dataset.object_name),
              producer_stage_id = coalesce(excluded.producer_stage_id, {self.schema}.dataset.producer_stage_id),
              is_materialized = excluded.is_materialized,
              description = coalesce(nullif(excluded.description, ''), {self.schema}.dataset.description)
            """,
            [
                (
                    item.dataset_id,
                    item.job_id or None,
                    item.dataset_name,
                    item.dataset_type.value,
                    item.database_name,
                    item.object_name,
                    item.producer_stage_id,
                    item.is_materialized,
                    item.description,
                )
                for item in model.datasets
            ],
        )

        cur.executemany(
            f"""
            insert into {self.schema}.field
            (field_id, dataset_id, field_name, field_role, expression_id, data_type, description)
            values (%s, %s, %s, %s, %s, %s, %s)
            on conflict (field_id) do update set
              dataset_id = excluded.dataset_id,
              field_name = excluded.field_name,
              -- 生产者优先: 同一物理列既被生产者 job(带表达式)建模, 又被下游 job 当源列引用
              -- (空壳: expression_id 为 NULL)。若用 excluded 无条件覆盖, 后落库的下游引用会把
              -- 生产者的真定义清成 NULL。故仅当 excluded 带表达式时才接受其 field_role/expression_id,
              -- 否则保留现有值, 避免真定义被空引用覆盖。
              field_role = case
                when excluded.expression_id is not null then excluded.field_role
                else {self.schema}.field.field_role
              end,
              expression_id = coalesce(excluded.expression_id, {self.schema}.field.expression_id),
              data_type = coalesce(excluded.data_type, {self.schema}.field.data_type),
              description = coalesce(nullif(excluded.description, ''), {self.schema}.field.description)
            """,
            [
                (
                    item.field_id,
                    item.dataset_id,
                    item.field_name,
                    item.field_role.value,
                    item.expression_id,
                    item.data_type,
                    item.description,
                )
                for item in model.fields
            ],
        )

        if model.stage_inputs:
            cur.executemany(
                f"""
                insert into {self.schema}.stage_input
                (stage_id, dataset_id, input_order, alias)
                values (%s, %s, %s, %s)
                on conflict (stage_id, dataset_id) do update set
                  input_order = excluded.input_order,
                  alias = coalesce(excluded.alias, {self.schema}.stage_input.alias)
                """,
                [(item.stage_id, item.dataset_id, item.input_order, item.alias) for item in model.stage_inputs],
            )

        if model.stage_predicates:
            cur.executemany(
                f"""
                insert into {self.schema}.stage_predicate
                (predicate_id, stage_id, predicate_type, predicate_sql, ordinal_no, description)
                values (%s, %s, %s, %s, %s, %s)
                """,
                [
                    (
                        item.predicate_id,
                        item.stage_id,
                        item.predicate_type.value,
                        item.predicate_sql,
                        item.ordinal_no,
                        item.description,
                    )
                    for item in model.stage_predicates
                ],
            )

        if model.stage_joins:
            cur.executemany(
                f"""
                insert into {self.schema}.stage_join
                (join_id, stage_id, join_type, left_dataset_id, right_dataset_id, condition_sql, description)
                values (%s, %s, %s, %s, %s, %s, %s)
                """,
                [
                    (
                        item.join_id,
                        item.stage_id,
                        item.join_type,
                        item.left_dataset_id,
                        item.right_dataset_id,
                        item.condition_sql,
                        item.description,
                    )
                    for item in model.stage_joins
                ],
            )

        if model.stage_group_bys:
            cur.executemany(
                f"""
                insert into {self.schema}.stage_group_by
                (stage_id, expression_id, ordinal_no)
                values (%s, %s, %s)
                """,
                [
                    (item.stage_id, item.expression_id, item.ordinal_no)
                    for item in model.stage_group_bys
                ],
            )

        if model.field_expressions:
            cur.executemany(
                f"""
                insert into {self.schema}.field_expression
                (expression_id, stage_id, expression_type, expression_sql, source_field_ids, depends_on_expression_ids, description)
                values (%s, %s, %s, %s, %s, %s, %s)
                """,
                [
                    (
                        item.expression_id,
                        item.stage_id,
                        item.expression_type.value,
                        item.expression_sql,
                        json.dumps(item.source_field_ids, ensure_ascii=False),
                        json.dumps(item.depends_on_expression_ids, ensure_ascii=False),
                        item.description,
                    )
                    for item in model.field_expressions
                ],
            )

        if model.field_lineage:
            cur.executemany(
                f"""
                insert into {self.schema}.field_lineage
                (target_field_id, source_field_id, lineage_type)
                values (%s, %s, %s)
                on conflict (target_field_id, source_field_id, lineage_type) do nothing
                """,
                [
                    (
                        item.target_field_id,
                        item.source_field_id,
                        item.lineage_type.value,
                    )
                    for item in model.field_lineage
                ],
            )

        self._insert_provenance_v2(cur, model)

        if model.semantic_documents:
            cur.executemany(
                f"""
                insert into {self.schema}.semantic_document
                (doc_id, doc_type, title, content, ref_type, ref_id, keywords)
                values (%s, %s, %s, %s, %s, %s, %s)
                on conflict (doc_id) do update set
                  doc_type = excluded.doc_type,
                  title = excluded.title,
                  content = excluded.content,
                  ref_type = excluded.ref_type,
                  ref_id = excluded.ref_id,
                  keywords = excluded.keywords
                """,
                [
                    (
                        item.doc_id,
                        item.doc_type.value,
                        item.title,
                        item.content,
                        item.ref_type,
                        item.ref_id,
                        json.dumps(item.keywords, ensure_ascii=False),
                    )
                    for item in model.semantic_documents
                ],
            )

    def _insert_provenance_v2(self, cur, model: JobModel) -> None:
        """Persist producer-scoped definitions alongside the legacy model."""
        from psycopg2.extras import execute_values

        records = build_provenance_records(model)
        productions = records["productions"]
        definitions = records["definitions"]
        dependencies = records["dependencies"]

        if productions:
            execute_values(
                cur,
                f"""
                insert into {self.schema}.dataset_production
                (production_id, dataset_id, job_id, stage_id, write_mode,
                 is_materialized, is_current, source_instance_id)
                values %s
                on conflict (production_id) do update set
                  dataset_id = excluded.dataset_id,
                  job_id = excluded.job_id,
                  stage_id = excluded.stage_id,
                  write_mode = excluded.write_mode,
                  is_materialized = excluded.is_materialized,
                  is_current = excluded.is_current,
                  source_instance_id = excluded.source_instance_id
                """,
                [
                    (
                        item["production_id"], item["dataset_id"], item["job_id"],
                        item["stage_id"], item["write_mode"], item["is_materialized"],
                        item["is_current"], item["source_instance_id"],
                    )
                    for item in productions
                ], page_size=1000,
            )

        if definitions:
            execute_values(
                cur,
                f"""
                insert into {self.schema}.field_definition
                (definition_id, production_id, field_id, expression_id,
                 expression_sql, expression_type, ordinal_no)
                values %s
                on conflict (definition_id) do update set
                  production_id = excluded.production_id,
                  field_id = excluded.field_id,
                  expression_id = excluded.expression_id,
                  expression_sql = excluded.expression_sql,
                  expression_type = excluded.expression_type,
                  ordinal_no = excluded.ordinal_no
                """,
                [
                    (
                        item["definition_id"], item["production_id"], item["field_id"],
                        item["expression_id"], item["expression_sql"],
                        item["expression_type"], item["ordinal_no"],
                    )
                    for item in definitions
                ], page_size=1000,
            )

        if dependencies:
            execute_values(
                cur,
                f"""
                insert into {self.schema}.field_dependency
                (edge_id, target_definition_id, source_field_id, dependency_type,
                 lineage_type, source_ordinal)
                values %s
                on conflict (edge_id) do update set
                  target_definition_id = excluded.target_definition_id,
                  source_field_id = excluded.source_field_id,
                  dependency_type = excluded.dependency_type,
                  lineage_type = excluded.lineage_type,
                  source_ordinal = excluded.source_ordinal
                """,
                [
                    (
                        item["edge_id"], item["target_definition_id"],
                        item["source_field_id"], item["dependency_type"],
                        item["lineage_type"], item["source_ordinal"],
                    )
                    for item in dependencies
                ], page_size=1000,
            )
