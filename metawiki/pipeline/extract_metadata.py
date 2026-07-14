"""extract_metadata · 从数据源拉表/字段结构 → catalog/tables/*.yaml 初稿(stub)。

抽取拿到的是「物理结构」(表名/字段/类型); 业务语义(中文名/口径/踩坑)需人工补充。
策略: 机器抽 90% 骨架 + 人工注入 10% 业务知识 = 高质量 catalog。
多源(Doris/StarRocks/ClickHouse/Hive/MySQL/PG)统一走 information_schema。
依赖: pip install sqlalchemy pyyaml (+ 对应驱动)
"""
from __future__ import annotations

from .. import settings

# 各引擎的 information_schema 基本通用, 连接串不同。
DIALECT_URLS = {
    "doris":      "mysql+pymysql://{user}:{pwd}@{host}:9030/{db}",   # Doris 走 MySQL 协议
    "starrocks":  "mysql+pymysql://{user}:{pwd}@{host}:9030/{db}",
    "mysql":      "mysql+pymysql://{user}:{pwd}@{host}:3306/{db}",
    "postgres":   "postgresql+psycopg2://{user}:{pwd}@{host}:5432/{db}",
    "clickhouse": "clickhouse+native://{user}:{pwd}@{host}:9000/{db}",
    # hive: 建议直接读 Metastore (HMS) 或走 PyHive
}

EXTRACT_SQL = """
SELECT table_name, column_name, data_type, column_comment, ordinal_position
FROM   information_schema.columns
WHERE  table_schema = :db
ORDER BY table_name, ordinal_position
"""


def extract(dialect: str, db: str, **conn) -> dict:
    """连接数据源, 返回 {table: [columns...]}; 写出 catalog/tables/{table}.yaml 初稿。

    TODO: 用 SQLAlchemy 执行 EXTRACT_SQL, 按 table_name 聚合列,
          映射成 catalog 的 columns 结构(name/type/cn 用 column_comment),
          写到 settings.CATALOG_DIR/"tables"/{table}.yaml, 标 # TODO 待人工补口径。
    """
    raise NotImplementedError("按上面 TODO 实现; 先跑通一个引擎再扩展。")


if __name__ == "__main__":
    print(f"配置连接信息后启用。表初稿将写入: {settings.CATALOG_DIR / 'tables'}")
    print("建议增量抽取 + diff 出新增/变更表, 避免覆盖人工口径。")
