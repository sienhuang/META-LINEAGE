from __future__ import annotations

from dataclasses import replace

from .metadata import TableMetadataClient
from .sql_parser import OutputColumn, ParsedInsert, SqlStructureError


def resolve_insert_output_schema(
    parsed: ParsedInsert,
    metadata_client: TableMetadataClient | None,
) -> ParsedInsert:
    """Resolve anonymous INSERT projections to physical target-table fields."""
    if metadata_client is None or not any(
        _is_anonymous_output(column) for column in parsed.output_columns
    ):
        return parsed

    table = metadata_client.get_table_by_name(parsed.target_table)
    schema_columns = list(table.data_columns)
    dynamic_partition_count = sum(
        1 for partition in parsed.partitions if partition.dynamic
    )
    query_data_column_count = len(parsed.output_columns) - dynamic_partition_count
    if query_data_column_count != len(schema_columns):
        raise SqlStructureError(
            "INSERT output count does not match target table schema: "
            f"query has {query_data_column_count} data columns, "
            f"{parsed.target_table} has {len(schema_columns)}"
        )

    resolved: list[OutputColumn] = []
    data_index = 0
    for output in parsed.output_columns:
        if output.is_partition:
            resolved.append(output)
            continue
        schema_column = schema_columns[data_index]
        data_index += 1
        resolved.append(OutputColumn(
            ordinal=output.ordinal,
            name=schema_column.name,
            expression_sql=output.expression_sql,
            is_partition=False,
        ))
    return replace(parsed, output_columns=resolved)


def _is_anonymous_output(column: OutputColumn) -> bool:
    return column.name == f"_column_{column.ordinal}"
