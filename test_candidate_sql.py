#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""批量按字段重建"整条链路 SQL"——传入若干 ref,逐个跑 candidate_sql 并打印。

用法:
  python test_candidate_sql.py 'mt_ads.ads_x.active_cnt' 'mt_dwd.dwd_y.uid' ...

每个 ref 形如 'schema.table.column'。对每个字段打印:
  · target 元信息(field_id / job_id)
  · 递归血缘(每跳 target <= source [type])
  · 重建出的整条链路 SQL

单个字段解析失败不影响其余字段,结尾给出成功/失败统计。
底层复用 metawiki.pipeline.p4_field_logic.candidate_sql(不改任何生产逻辑)。
"""
from __future__ import annotations

import sys

from metawiki.pipeline.p4_field_logic import candidate_sql, field_dimensions

SEP = "=" * 78


def run_one(ref: str) -> bool:
    print(f"\n{SEP}\n字段: {ref}\n{SEP}")
    try:
        target, lineage, sql = candidate_sql(ref)
    except Exception as exc:  # noqa: BLE001 — 逐字段隔离,任何异常都只跳过该字段
        print(f"[FAIL] {ref}: {type(exc).__name__}: {exc}")
        return False

    print(f"target: field_id={target.get('field_id')}  job_id={target.get('job_id')}")

    dims = field_dimensions(ref)
    if dims:
        print(f"\n可分析维度 {len(dims)} 个: " + ", ".join(d["field_name"] for d in dims))
    else:
        print("\n可分析维度: (无聚合边界, 可能是明细表/直投)")

    print(f"\n递归血缘 {len(lineage)} 跳:")
    for it in lineage:
        print(
            f"  [d{it['depth']}] {it['target_dataset_name']}.{it['target_field_name']}"
            f" <= {it['source_dataset_name']}.{it['source_field_name']}"
            f" [{it['lineage_type']}]"
        )

    print("\n整条链路 SQL:\n")
    print(sql)
    return True


def main(refs: list[str]) -> int:
    if not refs:
        print(__doc__)
        return 2

    ok = 0
    for ref in refs:
        if run_one(ref):
            ok += 1

    fail = len(refs) - ok
    print(f"\n{SEP}\n共 {len(refs)} 个字段 | 成功 {ok} | 失败 {fail}\n{SEP}")
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
