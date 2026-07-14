"""lineage · 列级血缘引擎(移植自 RAG_LINEAGE/rag_lineage, 适配 metawiki)。

供 P4(D 层 ETL 口径)用: 把一段 HSQL / Spark SQL 解析成 canonical JobModel
(Job/Stage/Dataset/Field/FieldLineage), 拿到列级血缘(DIRECT/DERIVED/AGGREGATED),
再跨任务多跳追溯某字段的整体计算逻辑。

  canonical_models.py  口径数据模型(零依赖)
  sql_ast_builder.py   sqlglot AST → JobModel(核心解析器, dialect=hive/spark)

用法:
    from metawiki.lineage import SqlAstJobModelBuilder
    builder = SqlAstJobModelBuilder(dialect="hive")
    model = builder.parse_sql(sql, job_name="...")
"""
from __future__ import annotations

from .canonical_models import (  # noqa: F401
    Dataset,
    Field,
    FieldExpression,
    FieldLineage,
    Job,
    JobModel,
    LineageType,
    Stage,
)
from .sql_ast_builder import SqlAstJobModelBuilder, job_model_to_json  # noqa: F401
from .repository import PostgresJobModelRepository  # noqa: F401
from .field_logic import FieldLogicExtractor, build_repository_from_env  # noqa: F401
