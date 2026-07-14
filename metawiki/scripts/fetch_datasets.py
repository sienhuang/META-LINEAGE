#!/usr/bin/env python3
"""从 Postgres(pq) metadata_kb.datasets 拉数据集信息，按每 200 个一个文件保存到 data/dataset 下。

数据集由 P2(p2_parse_datasets)从 MySQL ba.data_set 解析后整表灌进 Postgres
metadata_kb.datasets。本脚本与 fetch_tables.py 对称: tables 来自 Fons HTTP API,
datasets 来自 Postgres, 各自落到 data/tables 与 data/dataset。

用法: python -m metawiki.scripts.fetch_datasets
连接: settings.PG_DSN(.env 的 BIRAG_PG_* 覆盖)。
"""
import json
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from metawiki import settings  # noqa: E402

PAGE_SIZE = 200
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "data", "dataset")

# 与 _PG_COLUMNS 一致(见 p2_parse_datasets); jsonb 列由 psycopg2 直接还原成 Python 对象。
COLUMNS = [
    "dataset_id", "ds_schema", "set_name", "set_type", "set_sql", "wide_table",
    "fact_tables", "dim_tables", "tables", "placeholders", "variables",
    "unmatched_placeholders", "unused_variables", "used_by_metrics",
]


def fetch_all():
    import psycopg2
    cols = ", ".join(COLUMNS)
    with psycopg2.connect(settings.PG_DSN) as conn, conn.cursor() as cur:
        cur.execute(f"SELECT {cols} FROM {settings.PG_DATASETS_TABLE} ORDER BY dataset_id")
        for row in cur.fetchall():
            yield dict(zip(COLUMNS, row))


def main():
    out_dir = os.path.abspath(OUT_DIR)
    os.makedirs(out_dir, exist_ok=True)

    records = list(fetch_all())
    total = len(records)
    total_pages = (total + PAGE_SIZE - 1) // PAGE_SIZE
    print(f"total datasets: {total}, pages: {total_pages}")

    for page in range(1, total_pages + 1):
        chunk = records[(page - 1) * PAGE_SIZE: page * PAGE_SIZE]
        out_path = os.path.join(out_dir, f"datasets_page_{page:04d}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(chunk, f, ensure_ascii=False, indent=2)
        print(f"page {page}: {len(chunk)} datasets -> {out_path}")


if __name__ == "__main__":
    main()
