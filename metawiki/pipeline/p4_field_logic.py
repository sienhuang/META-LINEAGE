"""P4(三) · 完整 JobModel 落库 + 字段级"整条链路 SQL"重建。

与 p4_build_lineage(扁平列级边 + 表/列 trace)互补、互不干扰:
本步把每个 ETL SQL 解析成的【完整 JobModel】(job/stage/dataset/field/
field_expression/field_lineage/stage_input/join/group_by/predicate 全套)
落进 metadata_kb 的 lineage schema, 然后用 FieldLogicExtractor(移植自
rag_lineage/extract_field_logic.py → metawiki/lineage/field_logic.py)对某个字段:
  · 做依赖闭包(源字段 + GROUP BY 字段 + JOIN key + 兄弟字段)
  · 逐 stage 重建出最小化的 `WITH ... SELECT` —— 即"整条链路的 SQL", 给指标当参考口径
  · 顺带给出该字段的跨任务递归血缘(fetch_recursive_lineage)

产出: metadata_kb.<LINEAGE_SCHEMA>.*(完整 ER 模型)
用法:
  python -m metawiki.pipeline.p4_field_logic                       # 解析全部并落库
  python -m metawiki.pipeline.p4_field_logic --candidate-sql 'mt_ads.ads_x.active_cnt'
  python -m metawiki.pipeline.p4_field_logic --lineage 'mt_ads.ads_x.active_cnt'
连接: settings.PG_DSN / settings.LINEAGE_SCHEMA / settings.MYSQL_*(均走 .env)。
"""
from __future__ import annotations

import logging
import sys

from .. import settings
from ..lineage import (
    FieldLogicExtractor,
    PostgresJobModelRepository,
    SqlAstJobModelBuilder,
    build_repository_from_env,
)

logging.getLogger("sqlglot").setLevel(logging.ERROR)
log = settings.PARSE_ETL_LOGGER


def persist_models(tasks: list[dict], repo: PostgresJobModelRepository | None = None,
                   chunk: int = 200) -> dict:
    """逐 SQL 单元解析成 JobModel, 分批落库。返回统计。"""
    repo = repo or PostgresJobModelRepository()
    repo.ensure_schema()
    builders = {"hive": SqlAstJobModelBuilder(dialect="hive"),
                "spark": SqlAstJobModelBuilder(dialect="spark")}
    buf: list = []
    ok = err = units = 0
    for t in tasks:
        if not t.get("sql_units"):
            continue
        builder = builders.get(t.get("dialect") or "hive", builders["hive"])
        for i, sql in enumerate(t["sql_units"]):
            units += 1
            try:
                model = builder.parse_sql(sql, job_name=f"{t['task_id']}__{i}")
            except Exception as exc:
                err += 1
                log.debug("解析失败 task_id=%s unit=%d: %s", t["task_id"], i, exc)
                continue
            ok += 1
            buf.append(model)
            if len(buf) >= chunk:
                repo.upsert_models(buf)
                log.info("  …已落 JobModel %d 个", ok)
                buf = []
    if buf:
        repo.upsert_models(buf)
    return {"units": units, "parsed_ok": ok, "parse_err": err}


def _split_ref(ref: str) -> tuple[str, str]:
    parts = ref.rsplit(".", 1)
    if len(parts) != 2:
        raise ValueError("ref 形如 'mt_ads.ads_x.active_cnt'(表名.列名)")
    return parts[0], parts[1]


def candidate_sql(ref: str) -> tuple[dict, list[dict], str]:
    """某字段的"整条链路 SQL" + 递归血缘。ref = 'schema.table.column'。

    返回 (target_meta, recursive_lineage, reconstructed_sql)。
    """
    dataset_name, field_name = _split_ref(ref)
    extractor = FieldLogicExtractor(build_repository_from_env())
    target = extractor.resolve_target_field(dataset_name, field_name)
    lineage, sql = extractor.build_candidate_sql(target["field_id"], target["job_id"])
    return target, lineage, sql


def field_dimensions(ref: str) -> list[dict]:
    """某指标的"可分析维度"清单(聚合 stage 的 GROUP BY 输出列)。ref = 'schema.table.column'。"""
    dataset_name, field_name = _split_ref(ref)
    extractor = FieldLogicExtractor(build_repository_from_env())
    target = extractor.resolve_target_field(dataset_name, field_name)
    fields, stages, _ = extractor.fetch_job_metadata(target["job_id"])
    return extractor.extract_dimensions(target["field_id"], fields, stages)


def recursive_lineage(ref: str) -> list[dict]:
    """某字段的跨任务递归血缘(不重建 SQL)。"""
    dataset_name, field_name = _split_ref(ref)
    extractor = FieldLogicExtractor(build_repository_from_env())
    target = extractor.resolve_target_field(dataset_name, field_name)
    return extractor.fetch_recursive_lineage(target["field_id"])


def _print_candidate(ref: str) -> None:
    target, lineage, sql = candidate_sql(ref)
    log.info("字段 %s  (job=%s)", ref, target["job_id"])
    dims = field_dimensions(ref)
    if dims:
        log.info("可分析维度 %d 个: %s", len(dims), ", ".join(d["field_name"] for d in dims))
    else:
        log.info("可分析维度: (无聚合边界, 可能是明细表/直投)")
    log.info("递归血缘 %d 跳:", len(lineage))
    for it in lineage:
        log.info("  [d%d] %s.%s <= %s.%s [%s]", it["depth"],
                 it["target_dataset_name"], it["target_field_name"],
                 it["source_dataset_name"], it["source_field_name"], it["lineage_type"])
    log.info("整条链路 SQL:\n%s", sql)


def _print_lineage(ref: str) -> None:
    rows = recursive_lineage(ref)
    if not rows:
        log.info("字段 %s: 无递归血缘(未落库 / 名称不符)", ref)
        return
    log.info("字段 %s 的递归血缘 %d 跳:", ref, len(rows))
    for it in rows:
        log.info("  [d%d] %s.%s <= %s.%s [%s]", it["depth"],
                 it["target_dataset_name"], it["target_field_name"],
                 it["source_dataset_name"], it["source_field_name"], it["lineage_type"])


def main() -> None:
    from . import p4_extract_tasks
    tasks = p4_extract_tasks.fetch_tasks()
    stats = persist_models(tasks)
    log.info("SQL 单元: %d  落库 JobModel: %d  解析失败: %d",
             stats["units"], stats["parsed_ok"], stats["parse_err"])
    log.info("完整 ER 模型已写入 metadata_kb.%s.*", settings.LINEAGE_SCHEMA)


if __name__ == "__main__":
    argv = sys.argv[1:]
    if "--candidate-sql" in argv:
        _print_candidate(argv[argv.index("--candidate-sql") + 1])
    elif "--lineage" in argv:
        _print_lineage(argv[argv.index("--lineage") + 1])
    else:
        main()
