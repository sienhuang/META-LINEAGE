#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
根据《AI敏感字段屏蔽.xlsx》对全量血缘产出 CSV 做二次处理，筛出命中敏感清单的
表/列，并把"全表敏感"的记录折叠为表级(column='')。

匹配口径:
  - 全表敏感表(是否全表敏感=1): 只按 table 匹配 -> 命中即输出, column=''  (表级)
  - 列级敏感(是否全表敏感!=1):  按 (table, column) 精确匹配 -> 命中输出该列
  - 大小写不敏感匹配(清单与数据均为小写, 兜底做 lower)

原始列拆分:
  - db.table.column        -> table=db.table, column=column
  - db.table [行级 COUNT(*)]-> table=db.table, 无具体列(仅全表敏感表可命中, 输出表级)
  - (字面量/常量) / 空       -> 无表, 跳过

输出列: 行号, 是否解析成功, session_user, table, column
最后按 (行号, session_user, table, column) 排序去重。
"""
import argparse
import csv
import os
import sys
import openpyxl

DEFAULT_XLSX = "/Users/huangsien/Downloads/AI敏感字段屏蔽.xlsx"
DEFAULT_SRC = "/Users/huangsien/PycharmProjects/MetaWIKI/huiyaoye_moonton_com_20230105190150_full.csv"


def default_out(src):
    """未指定输出时, 由源文件名派生: xxx_full.csv -> xxx_sensitive.csv"""
    base = os.path.basename(src)
    root, ext = os.path.splitext(base)
    if root.endswith("_full"):
        root = root[: -len("_full")]
    return os.path.join(os.path.dirname(src) or ".", f"{root}_sensitive{ext or '.csv'}")


def load_sensitive(path):
    """返回 (full_tables:set, col_pairs:set)。均使用小写。"""
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    ws = wb["需要管控的数据表+字段"]
    rows = ws.iter_rows(values_only=True)
    header = next(rows)
    idx = {h: i for i, h in enumerate(header)}
    ti, ci, fi = idx["table_key"], idx["column"], idx["是否全表敏感"]
    full_tables, col_pairs = set(), set()
    for r in rows:
        tk = r[ti]
        if tk is None:
            continue
        tk = str(tk).strip().lower()
        full = r[fi] not in (None, 0, "0", "")
        if full:
            full_tables.add(tk)
        else:
            col = r[ci]
            col = "" if col is None else str(col).strip().lower()
            col_pairs.add((tk, col))
    wb.close()
    return full_tables, col_pairs


def split_orig(orig):
    """拆出 (table, column)。column 为 None 表示行级/无具体列。无法拆则返回 (None, None)。"""
    if not orig:
        return None, None
    s = orig.strip()
    # 行级哨兵: "db.table [行级 COUNT(*)]"
    if "[" in s:
        s = s.split("[", 1)[0].strip()
        # 剩下应为 db.table (一个点)
        if s.count(".") >= 1:
            return s, None
        return None, None
    n = s.count(".")
    if n == 0:
        return None, None  # 字面量/常量
    # db.table.column (含更深层则最后一段为列, 其余为表)
    table, _, column = s.rpartition(".")
    return table, column


def parse_args(argv=None):
    p = argparse.ArgumentParser(
        description="按《AI敏感字段屏蔽》清单对血缘产出CSV做二次处理, 筛出命中敏感表/列的记录。"
    )
    p.add_argument("src", nargs="?", default=DEFAULT_SRC,
                   help=f"待处理的血缘全量CSV (默认: {DEFAULT_SRC})")
    p.add_argument("-x", "--xlsx", default=DEFAULT_XLSX,
                   help=f"敏感字段屏蔽清单xlsx (默认: {DEFAULT_XLSX})")
    p.add_argument("-o", "--out", default=None,
                   help="输出CSV路径 (默认: 由源文件名派生, xxx_full.csv -> xxx_sensitive.csv)")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    xlsx, src = args.xlsx, args.src
    out = args.out or default_out(src)

    full_tables, col_pairs = load_sensitive(xlsx)
    print(f"[清单] {xlsx}", file=sys.stderr)
    print(f"[清单] 全表敏感表={len(full_tables)}  列级(table,column)对={len(col_pairs)}", file=sys.stderr)

    seen = set()
    out_rows = []
    extra_cols = []      # 输入实际列名 (id / app_id), 存在才透传
    extra_header = []    # 对应输出列名 (统一 id / app_id)
    n_total = n_matched_full = n_matched_col = 0

    with open(src, encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames or []
        id_col = "id" if "id" in fieldnames else None
        appid_col = next((c for c in ("app_id", "appid") if c in fieldnames), None)
        extra_cols = [c for c in (id_col, appid_col) if c]
        extra_header = [("app_id" if c == appid_col else c) for c in extra_cols]

        for row in reader:
            n_total += 1
            table, column = split_orig(row.get("原始列", ""))
            if table is None:
                continue
            tkey = table.lower()
            ckey = None if column is None else column.lower()

            if tkey in full_tables:
                # 全表敏感 -> 表级
                out_col = ""
                n_matched_full += 1
            elif ckey is not None and (tkey, ckey) in col_pairs:
                out_col = column
                n_matched_col += 1
            else:
                continue

            # 去重键不含 id/app_id: 二者由行号决定, 同一行号取值一致
            rec = (row["行号"], row["session_user"], table, out_col)
            if rec in seen:
                continue
            seen.add(rec)
            extra_vals = tuple(row.get(c, "") for c in extra_cols)
            out_rows.append((row["行号"], row["解析成功"], row["session_user"], table, out_col) + extra_vals)

    # 排序: 行号数值序, 其余字符串序 (extra 在元组末尾, 不影响索引)
    def sort_key(r):
        try:
            rn = int(r[0])
        except (ValueError, TypeError):
            rn = 0
        return (rn, r[2], r[3], r[4])

    out_rows.sort(key=sort_key)

    with open(out, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f)
        w.writerow(["行号", *extra_header, "是否解析成功", "session_user", "table", "column"])
        for r in out_rows:
            lineno, succ, user, tbl, col = r[:5]
            w.writerow([lineno, *r[5:], succ, user, tbl, col])

    print(f"[输入] {src}  行数={n_total}", file=sys.stderr)
    print(f"[命中] 全表敏感={n_matched_full}  列级={n_matched_col}", file=sys.stderr)
    print(f"[输出] 去重后={len(out_rows)} -> {out}", file=sys.stderr)


if __name__ == "__main__":
    main()
