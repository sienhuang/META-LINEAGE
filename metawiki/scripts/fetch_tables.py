#!/usr/bin/env python3
"""抓取元数据表格信息，按每 200 个表格一个文件保存到 data/tables 下。"""
import json
import os
import urllib.request

BASE_URL = "http://fons-dev.test.bi.moontontech.net/metadata/metadata/tables"
SOURCE_ID = 3
PAGE_SIZE = 200
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "data", "tables")


def fetch_page(page):
    url = f"{BASE_URL}?page={page}&pageSize={PAGE_SIZE}&sourceId={SOURCE_ID}"
    with urllib.request.urlopen(url, timeout=60) as resp:
        return json.load(resp)["data"]


def main():
    out_dir = os.path.abspath(OUT_DIR)
    os.makedirs(out_dir, exist_ok=True)

    first = fetch_page(1)
    total_pages = first["pages"]
    total = first["total"]
    print(f"total tables: {total}, pages: {total_pages}")

    for page in range(1, total_pages + 1):
        data = first if page == 1 else fetch_page(page)
        records = data["records"]
        out_path = os.path.join(out_dir, f"tables_page_{page:04d}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(records, f, ensure_ascii=False, indent=2)
        print(f"page {page}: {len(records)} tables -> {out_path}")


if __name__ == "__main__":
    main()
