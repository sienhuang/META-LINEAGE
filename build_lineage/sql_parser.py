from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

import sqlglot
from sqlglot import exp
from sqlglot.errors import ParseError


class SqlStructureError(ValueError):
    """The SQL is valid enough to parse, but not a supported INSERT shape."""


@dataclass(frozen=True)
class PartitionColumn:
    name: str
    dynamic: bool
    value_sql: str | None = None


@dataclass(frozen=True)
class OutputColumn:
    ordinal: int
    name: str
    expression_sql: str
    is_partition: bool = False

    def to_dict(self, *, include_expression: bool) -> dict[str, Any]:
        value: dict[str, Any] = {
            "ordinal": self.ordinal,
            "name": self.name,
            "is_partition": self.is_partition,
        }
        if include_expression:
            value["expression_sql"] = self.expression_sql
        return value


@dataclass(frozen=True)
class UnionBranch:
    order: int
    source_relations: tuple[str, ...]
    resolved_source_datasets: tuple[str, ...]
    output_count: int
    output_names: tuple[str, ...]


@dataclass(frozen=True)
class UnionGroup:
    branch_count: int
    branches: tuple[UnionBranch, ...]


@dataclass
class ParsedInsert:
    dialect: str
    target_table: str
    overwrite: bool
    partitions: list[PartitionColumn]
    output_columns: list[OutputColumn]
    ctes: list[str]
    source_datasets: list[str]
    union_groups: list[UnionGroup]
    warnings: list[str] = field(default_factory=list)

    def to_dict(self, *, include_expressions: bool = False) -> dict[str, Any]:
        return {
            "dialect": self.dialect,
            "statement_type": "insert",
            "write_mode": "insert_overwrite" if self.overwrite else "insert_into",
            "target_table": self.target_table,
            "partitions": [
                {
                    "name": item.name,
                    "mode": "dynamic" if item.dynamic else "static",
                    "value_sql": item.value_sql,
                }
                for item in self.partitions
            ],
            "ctes": self.ctes,
            "source_datasets": self.source_datasets,
            "output_column_count": len(self.output_columns),
            "output_columns": [
                item.to_dict(include_expression=include_expressions)
                for item in self.output_columns
            ],
            "union_group_count": len(self.union_groups),
            "union_groups": [
                {
                    "branch_count": group.branch_count,
                    "branches": [
                        {
                            "order": branch.order,
                            "source_relations": list(branch.source_relations),
                            "resolved_source_datasets": list(
                                branch.resolved_source_datasets
                            ),
                            "output_count": branch.output_count,
                            "output_names": list(branch.output_names),
                        }
                        for branch in group.branches
                    ],
                }
                for group in self.union_groups
            ],
            "warnings": self.warnings,
        }


class SqlStructureParser:
    def __init__(self, dialect: str = "hive") -> None:
        self.dialect = dialect

    def parse_insert(self, raw_sql: str) -> ParsedInsert:
        if not raw_sql.strip():
            raise SqlStructureError("SQL must not be empty")
        try:
            statements = sqlglot.parse(raw_sql, read=self.dialect)
        except ParseError as error:
            raise SqlStructureError(f"SQL parse failed: {error}") from error
        meaningful = [statement for statement in statements if statement is not None]
        if len(meaningful) != 1:
            raise SqlStructureError(
                f"expected exactly one SQL statement, found {len(meaningful)}"
            )
        statement = meaningful[0]
        if not isinstance(statement, exp.Insert):
            raise SqlStructureError(
                f"expected INSERT statement, found {type(statement).__name__}"
            )
        if not isinstance(statement.this, exp.Table):
            raise SqlStructureError("INSERT target is not a table")
        query = statement.expression
        if not isinstance(query, exp.Query):
            raise SqlStructureError("INSERT has no query expression")

        ctes = [cte.alias_or_name for cte in statement.find_all(exp.CTE)]
        target_table = _table_name(statement.this)
        partitions = _partitions(statement.this, self.dialect)
        warnings: list[str] = []
        output_columns = _output_columns(
            query,
            partitions,
            self.dialect,
            warnings,
        )
        cte_names = {name.lower() for name in ctes}
        source_datasets = _physical_tables(
            statement,
            cte_names=cte_names,
            excluded={target_table.lower()},
        )
        union_groups = _union_groups(statement)

        return ParsedInsert(
            dialect=self.dialect,
            target_table=target_table,
            overwrite=bool(statement.args.get("overwrite")),
            partitions=partitions,
            output_columns=output_columns,
            ctes=ctes,
            source_datasets=source_datasets,
            union_groups=union_groups,
            warnings=warnings,
        )


def _table_name(table: exp.Table) -> str:
    parts = [table.catalog, table.db, table.name]
    return ".".join(part for part in parts if part)


def _partitions(table: exp.Table, dialect: str) -> list[PartitionColumn]:
    partition = table.args.get("partition")
    if not isinstance(partition, exp.Partition):
        return []
    result: list[PartitionColumn] = []
    for item in partition.expressions:
        if isinstance(item, exp.Column):
            result.append(PartitionColumn(name=item.name, dynamic=True))
        elif isinstance(item, exp.EQ):
            result.append(PartitionColumn(
                name=item.left.name,
                dynamic=False,
                value_sql=item.right.sql(dialect=dialect),
            ))
        else:
            result.append(PartitionColumn(
                name=item.alias_or_name or item.sql(dialect=dialect),
                dynamic=False,
                value_sql=item.sql(dialect=dialect),
            ))
    return result


def _output_columns(
    query: exp.Query,
    partitions: list[PartitionColumn],
    dialect: str,
    warnings: list[str],
) -> list[OutputColumn]:
    selects = list(query.selects)
    dynamic = [item for item in partitions if item.dynamic]
    if len(selects) < len(dynamic):
        raise SqlStructureError(
            "SELECT output count is smaller than dynamic partition count"
        )
    partition_start = len(selects) - len(dynamic)
    result: list[OutputColumn] = []
    for index, expression in enumerate(selects):
        name = expression.alias_or_name
        if not name:
            name = f"_column_{index + 1}"
            warnings.append(f"output column {index + 1} has no explicit name")
        is_partition = bool(dynamic) and index >= partition_start
        result.append(OutputColumn(
            ordinal=index + 1,
            name=name,
            expression_sql=expression.sql(dialect=dialect),
            is_partition=is_partition,
        ))
    actual = [item.name.lower() for item in result if item.is_partition]
    expected = [item.name.lower() for item in dynamic]
    if actual != expected:
        warnings.append(
            "dynamic partition outputs do not match declared order: "
            f"expected {expected}, found {actual}"
        )
    return result


def _physical_tables(
    expression: exp.Expression,
    *,
    cte_names: set[str],
    excluded: set[str] | None = None,
) -> list[str]:
    excluded = excluded or set()
    names: set[str] = set()
    for table in expression.find_all(exp.Table):
        name = _table_name(table)
        if not name:
            continue
        lowered = name.lower()
        if lowered in cte_names or lowered in excluded:
            continue
        names.add(name)
    return sorted(names)


def _union_groups(statement: exp.Expression) -> list[UnionGroup]:
    cte_queries = {
        cte.alias_or_name.lower(): cte.this
        for cte in statement.find_all(exp.CTE)
    }
    roots = [
        union for union in statement.find_all(exp.Union)
        if not isinstance(union.parent, exp.Union)
    ]
    groups: list[UnionGroup] = []
    for root in roots:
        queries = _flatten_union(root)
        branches: list[UnionBranch] = []
        for order, query in enumerate(queries, start=1):
            selects = list(query.selects) if isinstance(query, exp.Query) else []
            source_relations = tuple(_relation_names(query))
            branches.append(UnionBranch(
                order=order,
                source_relations=source_relations,
                resolved_source_datasets=tuple(_resolve_relations(
                    source_relations,
                    cte_queries,
                )),
                output_count=len(selects),
                output_names=tuple(
                    item.alias_or_name or f"_column_{index}"
                    for index, item in enumerate(selects, start=1)
                ),
            ))
        groups.append(UnionGroup(branch_count=len(branches), branches=tuple(branches)))
    return groups


def _relation_names(expression: exp.Expression) -> list[str]:
    return sorted({
        name
        for table in expression.find_all(exp.Table)
        if (name := _table_name(table))
    })


def _resolve_relations(
    relations: tuple[str, ...],
    cte_queries: dict[str, exp.Expression],
    visiting: frozenset[str] = frozenset(),
) -> list[str]:
    physical: set[str] = set()
    for relation in relations:
        key = relation.lower()
        cte_query = cte_queries.get(key)
        if cte_query is None:
            physical.add(relation)
            continue
        if key in visiting:
            continue
        nested = tuple(_relation_names(cte_query))
        physical.update(_resolve_relations(
            nested,
            cte_queries,
            visiting | {key},
        ))
    return sorted(physical)


def _flatten_union(expression: exp.Expression) -> list[exp.Expression]:
    if not isinstance(expression, exp.Union):
        return [expression]
    return _flatten_union(expression.this) + _flatten_union(expression.expression)
