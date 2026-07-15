from __future__ import annotations

from dataclasses import dataclass

from .column_tracer import ColumnTrace, SingleJobColumnTracer
from .metadata import TableMetadataClient
from .output_schema import resolve_insert_output_schema
from .production_sql import ProductionSql, ProductionSqlGenerator
from .sql_parser import ParsedInsert, SqlStructureParser


@dataclass(frozen=True)
class ProductionBuildResult:
    trace: ColumnTrace
    production: ProductionSql


class SingleJobProductionBuilder:
    """Canonical parse, schema resolution, trace, generate and validate pipeline."""

    def __init__(
        self,
        dialect: str = "hive",
        metadata_client: TableMetadataClient | None = None,
    ) -> None:
        self.dialect = dialect
        self.metadata_client = metadata_client
        self.parser = SqlStructureParser(dialect)
        self.tracer = SingleJobColumnTracer(dialect, metadata_client)
        self.generator = ProductionSqlGenerator(dialect, metadata_client)

    def inspect(self, raw_sql: str) -> ParsedInsert:
        parsed = self.parser.parse_insert(raw_sql)
        return resolve_insert_output_schema(parsed, self.metadata_client)

    def build(self, raw_sql: str, target_field: str) -> ProductionBuildResult:
        trace = self.tracer.trace(raw_sql, target_field)
        production = self.generator.generate(raw_sql, target_field, trace)
        return ProductionBuildResult(trace=trace, production=production)
