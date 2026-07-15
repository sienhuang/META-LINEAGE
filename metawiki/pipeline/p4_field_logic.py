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
  python -m metawiki.pipeline.p4_field_logic --backfill-v2         # 从现有 raw_sql 回填 V2
  python -m metawiki.pipeline.p4_field_logic --candidate-sql 'mt_ads.ads_x.active_cnt'
  python -m metawiki.pipeline.p4_field_logic --lineage 'mt_ads.ads_x.active_cnt'
  python -m metawiki.pipeline.p4_field_logic --producers 'mt_ads.ads_x.active_cnt'
  python -m metawiki.pipeline.p4_field_logic --production-bundle 'mt_ads.ads_x.active_cnt'
  python -m metawiki.pipeline.p4_field_logic --production-sql 'mt_ads.ads_x.active_cnt'
连接: settings.PG_DSN / settings.LINEAGE_SCHEMA / settings.MYSQL_*(均走 .env)。
"""
from __future__ import annotations

import json
import logging
import sys

from .. import settings
from ..lineage import (
    DependencyGraphBuilder,
    AllProductionSqlGenerator,
    FieldLogicExtractor,
    PostgresProvenanceReader,
    PostgresJobModelRepository,
    ProductionBundleBuilder,
    ProductionPathEnumerator,
    ProductionSqlReconstructor,
    SqlAstJobModelBuilder,
    SingleJobColumnLogicBuilder,
    build_repository_from_env,
    render_production_sql,
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


def _model_from_persisted_job(
    job_id: str,
    job_name: str,
    engine: str,
    raw_sql: str,
    builders: dict[str, SqlAstJobModelBuilder],
):
    builder = builders.get(engine, builders["hive"])
    model = builder.parse_sql(raw_sql, job_name=job_name)
    if model.job.job_id != job_id:
        raise ValueError(
            f"job id mismatch for {job_name}: stored={job_id}, parsed={model.job.job_id}"
        )
    return model


def backfill_provenance_v2(
    repo: PostgresJobModelRepository | None = None,
    chunk: int = 200,
    job_ids: list[str] | None = None,
) -> dict:
    """从现有 ``job.raw_sql`` 回填 producer-scoped V2 表，不改 legacy 表。"""
    if chunk < 1:
        raise ValueError("chunk must be >= 1")
    repo = repo or PostgresJobModelRepository()
    repo.ensure_schema()
    with repo.connect() as catalog_conn:
        with catalog_conn.cursor() as catalog_cur:
            catalog_cur.execute(
                f"select d.dataset_name, f.field_name "
                f"from {repo.schema}.field f "
                f"join {repo.schema}.dataset d on d.dataset_id = f.dataset_id"
            )
            known_fields = set(catalog_cur.fetchall())
    builders = {
        "hive": SqlAstJobModelBuilder(dialect="hive", known_fields=known_fields),
        "spark": SqlAstJobModelBuilder(dialect="spark", known_fields=known_fields),
    }
    scanned = parsed_ok = parse_err = 0
    models: list = []
    with repo.connect() as conn:
        with conn.cursor() as cur:
            sql = (
                f"select job_id, job_name, engine, raw_sql "
                f"from {repo.schema}.job"
            )
            params: tuple = ()
            if job_ids:
                sql += " where job_id = any(%s)"
                params = (job_ids,)
            cur.execute(sql + " order by job_id", params)
            while True:
                rows = cur.fetchmany(chunk)
                if not rows:
                    break
                for job_id, job_name, engine, raw_sql in rows:
                    scanned += 1
                    try:
                        model = _model_from_persisted_job(
                            job_id, job_name, engine, raw_sql, builders
                        )
                    except Exception as exc:
                        parse_err += 1
                        log.debug("V2 回填解析失败 job=%s: %s", job_id, exc)
                        continue
                    parsed_ok += 1
                    models.append(model)
                if models:
                    repo.replace_provenance_models(models)
                    models = []
                    log.info("  …V2 provenance 已回填 %d/%d", parsed_ok, scanned)
    return {
        "jobs_scanned": scanned,
        "parsed_ok": parsed_ok,
        "parse_err": parse_err,
    }


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


def field_producers(ref: str) -> list[dict]:
    """列出字段的所有 producer-scoped V2 定义，不静默消解多生产者。"""
    repo = build_repository_from_env()
    builder = DependencyGraphBuilder(PostgresProvenanceReader(repo))
    return builder.list_field_producers(ref)


def single_job_column_logic(
    job_id: str,
    target_ref: str,
    output_dir: str | None = None,
) -> dict:
    """按明确 job + target 恢复单任务字段逻辑和裁剪 SQL。"""
    repo = build_repository_from_env()
    reader = PostgresProvenanceReader(repo)
    return SingleJobColumnLogicBuilder(reader).build(
        job_ref=job_id,
        target_ref=target_ref,
        output_dir=output_dir,
    ).summary()


def all_production_paths(
    ref: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
    max_paths: int = 100,
    include_definitions: bool = False,
) -> dict:
    """枚举目标及沿途所有 producer 选择形成的完整生产路径。"""
    repo = build_repository_from_env()
    reader = PostgresProvenanceReader(repo)
    return ProductionPathEnumerator(reader).enumerate(
        ref,
        target_definition_id=target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
        max_paths=max_paths,
        include_definitions=include_definitions,
    ).as_dict()


def all_production_sql(
    ref: str,
    output_dir: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
    max_paths: int = 100,
) -> dict:
    """枚举生产路径，为每条完整路径生成独立 SQL 和 manifest。"""
    repo = build_repository_from_env()
    reader = PostgresProvenanceReader(repo)
    return AllProductionSqlGenerator(reader).generate(
        ref,
        output_dir=output_dir,
        target_definition_id=target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
        max_paths=max_paths,
    ).as_dict()


def _select_target_definition(
    ref: str,
    producers: list[dict],
    target_definition_id: str | None,
) -> str:
    if not producers:
        raise ValueError(f"Field definition not found: {ref}")
    producer_ids = {item["definition_id"] for item in producers}
    if target_definition_id is None:
        if len(producers) != 1:
            ids = ", ".join(sorted(producer_ids))
            raise ValueError(
                f"Multiple producers for {ref}; choose target_definition_id from: {ids}"
            )
        return producers[0]["definition_id"]
    if target_definition_id not in producer_ids:
        raise ValueError(
            f"Definition {target_definition_id} does not produce {ref}"
        )
    return target_definition_id


def build_dependency_graph(
    ref: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
) -> dict:
    """构建一个已选目标 definition 的跨任务依赖 DAG。

    当目标字段存在多个生产者时，调用方必须传 ``target_definition_id``；
    图内遇到多生产者会形成 ``ambiguous_producer`` boundary，可通过
    ``producer_overrides={source_field_id: definition_id}`` 明确选择后继续展开。
    """
    repo = build_repository_from_env()
    builder = DependencyGraphBuilder(PostgresProvenanceReader(repo))
    producers = builder.list_field_producers(ref)
    target_definition_id = _select_target_definition(
        ref, producers, target_definition_id
    )
    return builder.build(
        target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
    ).as_dict()


def build_production_bundle(
    ref: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
) -> dict:
    """按上游到下游顺序返回目标列涉及的真实生产任务 SQL。"""
    repo = build_repository_from_env()
    reader = PostgresProvenanceReader(repo)
    graph_builder = DependencyGraphBuilder(reader)
    producers = graph_builder.list_field_producers(ref)
    target_definition_id = _select_target_definition(
        ref, producers, target_definition_id
    )
    return ProductionBundleBuilder(reader).build(
        target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
    ).as_dict()


def production_sql(
    ref: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
) -> str:
    """按列依赖选择 producer，并把跨 job 查询内联成一条可执行 SQL。"""
    repo = build_repository_from_env()
    reader = PostgresProvenanceReader(repo)
    graph_builder = DependencyGraphBuilder(reader)
    producers = graph_builder.list_field_producers(ref)
    target_definition_id = _select_target_definition(
        ref, producers, target_definition_id
    )
    return ProductionSqlReconstructor(reader).reconstruct(
        target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
    ).sql


def raw_production_jobs(
    ref: str,
    target_definition_id: str | None = None,
    producer_overrides: dict[str, str] | None = None,
    max_depth: int = 30,
) -> str:
    """调试用途：按顺序输出完整原始 job SQL，不声称是列逻辑恢复。"""
    bundle = build_production_bundle(
        ref,
        target_definition_id=target_definition_id,
        producer_overrides=producer_overrides,
        max_depth=max_depth,
    )
    return render_production_sql(bundle)


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


def _print_json(value: object) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, default=str))


def _parse_overrides(argv: list[str]) -> dict[str, str]:
    overrides: dict[str, str] = {}
    for index, token in enumerate(argv):
        if token != "--override":
            continue
        if index + 1 >= len(argv) or "=" not in argv[index + 1]:
            raise ValueError("--override 形如 'source_field_id=definition_id'")
        field_id, definition_id = argv[index + 1].split("=", 1)
        if not field_id or not definition_id:
            raise ValueError("--override 形如 'source_field_id=definition_id'")
        overrides[field_id] = definition_id
    return overrides


def _int_option(argv: list[str], name: str, default: int) -> int:
    if name not in argv:
        return default
    index = argv.index(name)
    if index + 1 >= len(argv):
        raise ValueError(f"{name} 后必须提供整数")
    return int(argv[index + 1])


def _required_option(argv: list[str], name: str) -> str:
    if name not in argv:
        raise ValueError(f"{name} 为必填参数")
    index = argv.index(name)
    if index + 1 >= len(argv):
        raise ValueError(f"{name} 后必须提供值")
    return argv[index + 1]


def main() -> None:
    from . import p4_extract_tasks
    tasks = p4_extract_tasks.fetch_tasks()
    stats = persist_models(tasks)
    log.info("SQL 单元: %d  落库 JobModel: %d  解析失败: %d",
             stats["units"], stats["parsed_ok"], stats["parse_err"])
    log.info("完整 ER 模型已写入 metadata_kb.%s.*", settings.LINEAGE_SCHEMA)


def _run_backfill_v2(job_ids: list[str] | None = None) -> None:
    stats = backfill_provenance_v2(job_ids=job_ids)
    log.info(
        "V2 provenance 回填完成: 扫描 job=%d 成功=%d 失败=%d",
        stats["jobs_scanned"], stats["parsed_ok"], stats["parse_err"],
    )


if __name__ == "__main__":
    argv = sys.argv[1:]
    if "--candidate-sql" in argv:
        _print_candidate(argv[argv.index("--candidate-sql") + 1])
    elif "--column-sql" in argv:
        _print_json(single_job_column_logic(
            job_id=_required_option(argv, "--job-id"),
            target_ref=_required_option(argv, "--target"),
            output_dir=(
                argv[argv.index("--output-dir") + 1]
                if "--output-dir" in argv else None
            ),
        ))
    elif "--lineage" in argv:
        _print_lineage(argv[argv.index("--lineage") + 1])
    elif "--producers" in argv:
        ref = argv[argv.index("--producers") + 1]
        _print_json(field_producers(ref))
    elif "--dependency-graph" in argv:
        ref = argv[argv.index("--dependency-graph") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        _print_json(build_dependency_graph(
            ref, definition_id, producer_overrides=_parse_overrides(argv)
        ))
    elif "--production-bundle" in argv:
        ref = argv[argv.index("--production-bundle") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        _print_json(build_production_bundle(
            ref, definition_id, producer_overrides=_parse_overrides(argv)
        ))
    elif "--all-production-paths" in argv:
        ref = argv[argv.index("--all-production-paths") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        _print_json(all_production_paths(
            ref,
            target_definition_id=definition_id,
            producer_overrides=_parse_overrides(argv),
            max_depth=_int_option(argv, "--max-depth", 30),
            max_paths=_int_option(argv, "--max-paths", 100),
            include_definitions="--include-definitions" in argv,
        ))
    elif "--all-production-sql" in argv:
        ref = argv[argv.index("--all-production-sql") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        _print_json(all_production_sql(
            ref,
            output_dir=_required_option(argv, "--output-dir"),
            target_definition_id=definition_id,
            producer_overrides=_parse_overrides(argv),
            max_depth=_int_option(argv, "--max-depth", 30),
            max_paths=_int_option(argv, "--max-paths", 100),
        ))
    elif "--production-sql" in argv:
        ref = argv[argv.index("--production-sql") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        print(production_sql(
            ref,
            definition_id,
            producer_overrides=_parse_overrides(argv),
        ), end="")
    elif "--raw-production-jobs" in argv:
        ref = argv[argv.index("--raw-production-jobs") + 1]
        definition_id = (
            argv[argv.index("--definition") + 1]
            if "--definition" in argv else None
        )
        print(raw_production_jobs(
            ref,
            definition_id,
            producer_overrides=_parse_overrides(argv),
        ), end="")
    elif "--backfill-v2" in argv:
        selected_jobs = [
            argv[index + 1]
            for index, token in enumerate(argv)
            if token == "--job-id" and index + 1 < len(argv)
        ]
        _run_backfill_v2(selected_jobs or None)
    else:
        main()
