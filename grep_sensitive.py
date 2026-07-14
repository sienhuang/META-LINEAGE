#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
绕开 SQL 解析, 直接用《AI敏感字段屏蔽.xlsx》里的表名(table_key)作为关键字,
在原始 SQL 文本里做子串匹配。命中即输出该条记录的 id / app_id 等信息。

适用场景: SQL 解析失败率高(或源 CSV 损坏)时的兜底 —— 只要 SQL 文本里出现了
敏感表名, 就把它揪出来。只能定位到表级(不解析具体列)。

匹配口径:
  - 关键字 = 清单里全部 table_key (如 ml_ods.battleserver_battleai_end), 去重
  - 大小写不敏感; 匹配前去掉反引号, 使 `ml_ods`.`x` 与 ml_ods.x 都能命中
  - 一条记录命中多个敏感表 -> 输出多行
  - session_user 缺失时用 owner_email_prefix 兜底
  - 按 (table, id) 排序去重

输出列: id, app_id, session_user, table, 是否全表敏感, name
"""
import argparse
import csv
import os
import sys
import openpyxl

DEFAULT_XLSX = "/Users/huangsien/Downloads/AI敏感字段屏蔽.xlsx"
DEFAULT_SRC = "/Users/huangsien/Downloads/hive_sqls.csv"


def load_tables(path):
    """返回 {table_key(lower): is_full_table(bool)}。"""
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    ws = wb["需要管控的数据表+字段"]
    rows = ws.iter_rows(values_only=True)
    header = next(rows)
    idx = {h: i for i, h in enumerate(header)}
    ti, fi = idx["table_key"], idx["是否全表敏感"]
    tables = {}
    for r in rows:
        tk = r[ti]
        if tk is None:
            continue
        tk = str(tk).strip().lower()
        full = r[fi] not in (None, 0, "0", "")
        tables[tk] = tables.get(tk, False) or full
    wb.close()
    return tables


def normalize(s):
    """小写 + 去反引号, 便于子串匹配。"""
    return (s or "").lower().replace("`", "")


def default_out(src):
    base = os.path.basename(src)
    root, ext = os.path.splitext(base)
    return os.path.join(os.path.dirname(src) or ".", f"{root}_sensitive_grep{ext or '.csv'}")


def parse_args(argv=None):
    p = argparse.ArgumentParser(
        description="用敏感清单表名在原始 SQL 文本里 grep, 命中则输出 id/app_id(表级兜底)。"
    )
    p.add_argument("src", nargs="?", default=DEFAULT_SRC, help=f"原始 SQL CSV (默认: {DEFAULT_SRC})")
    p.add_argument("-x", "--xlsx", default=DEFAULT_XLSX, help=f"敏感清单 xlsx (默认: {DEFAULT_XLSX})")
    p.add_argument("-o", "--out", default=None, help="输出 CSV (默认: 由源文件名派生 xxx_sensitive_grep.csv)")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    out = args.out or default_out(args.src)

    tables = load_tables(args.xlsx)
    # 关键字按长度降序, 命中更长(更具体)的表名优先(仅影响遍历, 不影响结果集)
    keys = sorted(tables, key=len, reverse=True)
    print(f"[清单] 敏感表 {len(keys)} 个 (其中全表敏感 {sum(tables.values())})", file=sys.stderr)

    seen = set()
    out_rows = []
    n_total = n_hit_rows = 0

    with open(args.src, encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            n_total += 1
            q = normalize(row.get("query"))
            if not q:
                continue
            rid = (row.get("id") or "").strip()
            appid = (row.get("app_id") or row.get("appid") or "").strip()
            user = (row.get("session_user") or row.get("owner_email_prefix") or "").strip()
            name = (row.get("name") or "").strip()
            hit_any = False
            for tk in keys:
                if tk in q:
                    hit_any = True
                    key = (rid, appid, tk)
                    if key in seen:
                        continue
                    seen.add(key)
                    full = "1" if tables[tk] else ""
                    out_rows.append((rid, appid, user, tk, full, name))
            if hit_any:
                n_hit_rows += 1

    def sort_key(r):
        try:
            i = int(r[0])
        except (ValueError, TypeError):
            i = 0
        return (r[3], i)  # (table, id)

    out_rows.sort(key=sort_key)

    with open(out, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f)
        w.writerow(["id", "app_id", "session_user", "table", "是否全表敏感", "name"])
        w.writerows(out_rows)

    print(f"[输入] {args.src}  记录数={n_total}", file=sys.stderr)
    print(f"[命中] 命中敏感表的记录={n_hit_rows}  输出(id,table)去重行={len(out_rows)} -> {out}", file=sys.stderr)


if __name__ == "__main__":
    main()
