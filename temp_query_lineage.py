"""临时版本 · CSV query 列列级血缘追溯(source -> target, N:1)

任务口径:
  - 读 CSV 的 query 列(纯 SELECT, 无 INSERT), 复用现有 lineage 引擎解析成 JobModel。
  - "最外层 SELECT" = 目标列(target), 相当于 INSERT 的目标, 只是不落库。
  - 沿 field_lineage 多跳递归, 把每个 target 列追到最底层物理表的来源列(source)。
  - 输出 source -> target 的 N:1 映射(多个物理来源列汇聚到 1 个目标列)。

用法:
    .venv/bin/python temp_query_lineage.py [csv_path] [--limit N]
"""
from __future__ import annotations

import argparse
import csv
import logging
import os
import re
import sys
from collections import defaultdict
from typing import Dict, List, Set

from metawiki.lineage import JobModel, SqlAstJobModelBuilder
from metawiki.lineage.canonical_models import DatasetType, StageType

DEFAULT_CSV = "/Users/huangsien/Downloads/huiyaoye_moonton_com_20230105190150-15044425.csv"
# 引擎更接近 Presto/Trino, 但 sqlglot 的 hive/spark 对这批 SQL 兼容更好, 逐个 dialect 兜底尝试。
DIALECTS = ["hive", "spark", "presto", "trino"]


def parse_query(sql: str, job_name: str) -> tuple[JobModel | None, str]:
    """逐个 dialect 尝试解析, 返回 (JobModel|None, 使用的 dialect 或错误信息)。"""
    last_err = ""
    for dialect in DIALECTS:
        try:
            model = SqlAstJobModelBuilder(dialect=dialect).parse_sql(sql=sql, job_name=job_name)
            return model, dialect
        except Exception as exc:  # noqa: BLE001 —— 临时脚本, 记录后换下一个 dialect
            last_err = f"{type(exc).__name__}: {exc}"
    return None, last_err


def final_dataset_ids(model: JobModel) -> List[str]:
    """最外层 SELECT 产出的数据集(由 FINAL stage 生产)= 目标列所在。"""
    final_stage_ids = {s.stage_id for s in model.stages if s.stage_type == StageType.FINAL}
    return [d.dataset_id for d in model.datasets if d.producer_stage_id in final_stage_ids]


def trace_to_sources(
    target_field_id: str,
    edges: Dict[str, List[str]],
    field_dataset: Dict[str, str],
    dataset_is_physical: Dict[str, bool],
    field_expr: Dict[str, str],
) -> List[tuple[str, str]]:
    """沿 field_lineage 多跳递归, 把 target 列追到底层物理表的来源列(叶子)。

    叶子 = 该字段所在数据集是物理表(dataset_id 以 'table.' 开头)。带 visited 防环。
    返回 [(leaf_field_id, consumer_expr_sql)]:
      consumer_expr_sql = "直接消费该叶子的那个字段"的投影表达式 —— 对行哨兵而言,
      这才是真正的 count(*)/count(1) 聚合式(而非最外层 UNION 的合成占位 UNION_BRANCH_COLUMN)。
    """
    sources: List[tuple[str, str]] = []
    seen_leaf: Set[str] = set()
    visited: Set[str] = set()

    def walk(field_id: str, consumer_expr: str) -> None:
        if field_id in visited:
            return
        visited.add(field_id)
        ds_id = field_dataset.get(field_id)
        upstream = edges.get(field_id, [])
        # 到达物理表列, 且它自身没有更上游(真叶子) → 收作 source
        if ds_id and dataset_is_physical.get(ds_id) and not upstream:
            if field_id not in seen_leaf:
                seen_leaf.add(field_id)
                sources.append((field_id, consumer_expr))
            return
        if not upstream:
            # 非物理表却无上游(如字面量列): 无来源
            return
        # 当前字段的投影式(非 UNION 合成占位时)作为其上游叶子的 consumer;
        # UNION 合成列(UNION_BRANCH_COLUMN[...])不覆盖, 继续沿用更上游传下来的真实聚合式。
        my_expr = field_expr.get(field_id, "")
        next_expr = consumer_expr
        if my_expr and not my_expr.startswith("UNION_BRANCH_COLUMN"):
            next_expr = my_expr
        for src in upstream:
            walk(src, next_expr)

    walk(target_field_id, field_expr.get(target_field_id, ""))
    return sources


def label_field(field_id: str, field_name: Dict[str, str], field_dataset: Dict[str, str],
                dataset_name: Dict[str, str]) -> str:
    ds_id = field_dataset.get(field_id, "?")
    ds_label = dataset_name.get(ds_id, ds_id)
    return f"{ds_label}.{field_name.get(field_id, '?')}"


def is_row_sentinel(field_id: str, field_name: Dict[str, str]) -> bool:
    """行哨兵 = 代表"整行/行集"的合成字段(field_name 为 '*', id 以 __rows__ 结尾)。"""
    return field_id.endswith(".__rows__") or field_name.get(field_id) == "*"


def analyze(model: JobModel) -> Dict[str, dict]:
    """返回 {target 列: {"expr": 投影SQL, "col_sources": [列], "row_sources": [表]}}。

    col_sources: 真正的物理来源列(N:1 里的 N)。
    row_sources: 行级来源 —— 目标是 count(*)/count(1) 这类"依赖来源行数而非某列"的聚合,
                 不下推成 xxx.* 这种假列, 而是记成"对该物理表整行的行级聚合"(见下方渲染)。
    """
    edges: Dict[str, List[str]] = defaultdict(list)
    for lin in model.field_lineage:
        if lin.source_field_id not in edges[lin.target_field_id]:
            edges[lin.target_field_id].append(lin.source_field_id)

    field_name = {f.field_id: f.field_name for f in model.fields}
    field_dataset = {f.field_id: f.dataset_id for f in model.fields}
    dataset_name = {d.dataset_id: d.dataset_name for d in model.datasets}
    dataset_is_physical = {
        d.dataset_id: (d.dataset_type == DatasetType.TABLE and d.dataset_id.startswith("table."))
        for d in model.datasets
    }
    expr_map = {e.expression_id: e.expression_sql for e in model.field_expressions}
    # field_id -> 该字段的投影表达式SQL(用于行哨兵追溯时还原真实 count(*) 聚合式)
    field_expr = {f.field_id: expr_map.get(f.expression_id, "") for f in model.fields}

    result: Dict[str, dict] = {}
    for ds_id in final_dataset_ids(model):
        for fld in model.fields:
            if fld.dataset_id != ds_id:
                continue
            if fld.field_name == "*":  # 行哨兵本身不是真实目标列
                continue
            source_ids = trace_to_sources(
                fld.field_id, edges, field_dataset, dataset_is_physical, field_expr
            )
            col_sources: List[str] = []
            row_sources: List[tuple[str, str]] = []  # (物理表名, 真实聚合式如 count(*))
            for sid, consumer_expr in source_ids:
                if is_row_sentinel(sid, field_name):
                    # 行级来源: 只记物理表名 + 真实聚合式, 不伪造成 表.* 列
                    tbl = dataset_name.get(field_dataset.get(sid, ""), "?")
                    row_sources.append((tbl, consumer_expr))
                else:
                    col_sources.append(label_field(sid, field_name, field_dataset, dataset_name))
            result[fld.field_name] = {
                "col_sources": col_sources,
                "row_sources": row_sources,
            }
    return result


def _strip_alias(expr: str) -> str:
    return re.split(r"\s+AS\s+", expr, maxsplit=1, flags=re.I)[0].strip()


def source_target_pairs(mapping: Dict[str, dict]) -> List[tuple[str, str]]:
    """把 analyze 的结果摊平成 [(原始列, 目标列)] —— 每个 source->target 一行。

    - 普通列来源: (db.table.col, target)
    - 行级聚合(count(*)/count(1)): (db.table [行级 count(*)], target)
    - 无物理来源(字面量/常量): ('(字面量/常量)', target) —— 目标列仍保留一行, 不丢失。
    """
    pairs: List[tuple[str, str]] = []
    for target, info_d in mapping.items():
        col_sources = info_d["col_sources"]
        row_sources = info_d["row_sources"]
        if not col_sources and not row_sources:
            pairs.append(("(字面量/常量)", target))
            continue
        for src in col_sources:
            pairs.append((src, target))
        for tbl, consumer_expr in row_sources:
            pairs.append((f"{tbl} [行级 {_strip_alias(consumer_expr or 'count(*)')}]", target))
    return pairs


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("csv_path", nargs="?", default=DEFAULT_CSV)
    ap.add_argument("--limit", type=int, default=10, help="处理前 N 行; <=0 表示整份文件")
    ap.add_argument("--out", default="query_lineage_output.csv", help="输出 CSV 路径")
    ap.add_argument("--quiet", action="store_true", help="不打印逐行明细, 只写 CSV")
    ap.add_argument("--show-sqlglot-warnings", action="store_true",
                    help="显示 sqlglot 的解析告警(named structs / JSON path 等噪音, 默认屏蔽)")
    ap.add_argument("--error-out", default=None,
                    help="解析失败行单独输出路径(默认: 由主输出名派生 xxx_errors.csv)")
    args = ap.parse_args()

    root, ext = os.path.splitext(args.out)
    error_out = args.error_out or f"{root}_errors{ext or '.csv'}"

    # sqlglot 对 Hive named struct、数字 JSON path 等会刷大量 WARNING, 对血缘结果无影响, 默认压到 ERROR
    if not args.show_sqlglot_warnings:
        logging.getLogger("sqlglot").setLevel(logging.ERROR)

    with open(args.csv_path, encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        all_rows = list(reader)
        fieldnames = reader.fieldnames or []
    rows = all_rows if args.limit <= 0 else all_rows[: args.limit]

    # 若输入含 id / app_id(兼容 appid), 则透传到输出; 记录输入实际列名与输出列名
    id_col = "id" if "id" in fieldnames else None
    appid_col = next((c for c in ("app_id", "appid") if c in fieldnames), None)
    extra_cols = [c for c in (id_col, appid_col) if c]          # 读取用: 输入实际列名
    extra_header = [("app_id" if c == appid_col else c) for c in extra_cols]  # 写出用: 统一列名

    header = ["行号", *extra_header, "session_user", "解析成功", "解析引擎", "目标列数量", "原始列", "目标列", "query"]
    ok = 0
    out_row_cnt = 0
    err_cnt = 0
    with open(args.out, "w", encoding="utf-8-sig", newline="") as fout, \
            open(error_out, "w", encoding="utf-8-sig", newline="") as ferr:
        writer = csv.writer(fout)
        writer.writerow(header)
        ewriter = csv.writer(ferr)
        ewriter.writerow(["行号", *extra_header, "session_user", "解析原因", "query"])

        for idx, row in enumerate(rows, start=1):
            sql = (row.get("query") or "").strip()
            # session_user 缺失时, 用 owner_email_prefix 兜底
            user = (row.get("session_user") or row.get("owner_email_prefix") or "").strip()
            extra_vals = [row.get(c, "") for c in extra_cols]
            model, info = parse_query(sql, f"query_row_{idx}")

            if not args.quiet:
                print("=" * 88)
                print(f"[Row {idx}] user={user}")
                print("-" * 88)
                one_line = " ".join(sql.split())
                print(f"SQL: {one_line[:200]}{'...' if len(one_line) > 200 else ''}")

            if model is None:
                # 解析失败: 主输出仍写一行标注 否, 并单独写入错误文件便于排查
                writer.writerow([idx, *extra_vals, user, "否", "", 0, "", "", sql])
                ewriter.writerow([idx, *extra_vals, user, info, sql])
                out_row_cnt += 1
                err_cnt += 1
                if not args.quiet:
                    print(f"  ✗ 解析失败(所有 dialect): {info}")
                continue

            ok += 1
            mapping = analyze(model)
            pairs = source_target_pairs(mapping)
            target_cnt = len(mapping)
            if not args.quiet:
                print(f"  ✓ dialect={info}  目标列数={target_cnt}")
                print(f"  最外层 SELECT 目标列 -> 物理来源列(source -> target, N:1):")
            for src_label, target in pairs:
                writer.writerow([idx, *extra_vals, user, "是", info, target_cnt, src_label, target, sql])
                out_row_cnt += 1
                if not args.quiet:
                    print(f"      {src_label:<55} -> {target}")

    print("=" * 88)
    print(f"完成: {ok}/{len(rows)} 行解析成功; 共写出 {out_row_cnt} 行明细 -> {args.out}")
    print(f"解析失败 {err_cnt} 行 -> {error_out}")


if __name__ == "__main__":
    main()
