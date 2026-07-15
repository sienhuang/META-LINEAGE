from __future__ import annotations

from sqlglot import exp

from .metadata import TableMetadataClient
from .sql_parser import SqlStructureError


def expand_simple_union_stars(
    query: exp.Expression,
    metadata_client: TableMetadataClient | None,
) -> None:
    """Expand only schema-qualified, single-table ``SELECT *`` UNION branches.

    sqlglot's column lineage resolves UNION outputs by ordinal. A bare star is
    represented as one projection, so a non-first ``SELECT *`` branch cannot be
    traced at an ordinal greater than zero until its physical schema is known.
    """
    if metadata_client is None:
        return

    union_roots = [
        union
        for union in query.find_all(exp.Union)
        if not isinstance(union.parent, exp.Union)
    ]
    for union in union_roots:
        branches = _flatten_union(union)
        selects = [branch for branch in branches if isinstance(branch, exp.Select)]
        if len(selects) != len(branches):
            continue

        candidates: list[tuple[exp.Select, exp.Table]] = []
        explicit_counts: set[int] = set()
        unsupported_star = False
        for select in selects:
            table = _simple_star_table(select)
            if table is not None:
                candidates.append((select, table))
            elif any(_is_star_projection(item) for item in select.expressions):
                unsupported_star = True
            else:
                explicit_counts.add(len(select.expressions))

        # Without one explicit sibling there is no reliable UNION output
        # contract. Complex star projections intentionally retain old behavior.
        if not candidates or unsupported_star or len(explicit_counts) != 1:
            continue
        expected_count = next(iter(explicit_counts))

        expansions: list[tuple[exp.Select, list[exp.Expression]]] = []
        for select, table in candidates:
            metadata = metadata_client.get_table(table.db, table.name)
            columns = metadata.data_columns + metadata.partition_columns
            if len(columns) != expected_count:
                raise SqlStructureError(
                    "cannot expand UNION SELECT * from "
                    f"{table.db}.{table.name}: metadata has {len(columns)} "
                    f"columns but the explicit UNION branch has {expected_count}"
                )
            qualifier = table.alias_or_name if table.alias else None
            expansions.append((
                select,
                [exp.column(column.name, table=qualifier) for column in columns],
            ))

        # Apply only after every candidate in the UNION has validated, avoiding
        # a partially rewritten AST when one schema is incompatible.
        for select, expressions in expansions:
            select.set("expressions", expressions)


def _simple_star_table(select: exp.Select) -> exp.Table | None:
    if len(select.expressions) != 1:
        return None
    projection = select.expressions[0]
    if not _is_star_projection(projection):
        return None
    from_clause = select.args.get("from_")
    if not isinstance(from_clause, exp.From) or not isinstance(
        from_clause.this,
        exp.Table,
    ):
        return None
    table = from_clause.this
    if not table.db or table.catalog or select.args.get("joins"):
        return None
    if isinstance(projection, exp.Column) and projection.table:
        valid_qualifiers = {table.name.lower(), table.alias_or_name.lower()}
        if projection.table.lower() not in valid_qualifiers:
            return None
    return table


def _is_star_projection(expression: exp.Expression) -> bool:
    return isinstance(expression, exp.Star) or (
        isinstance(expression, exp.Column) and expression.is_star
    )


def _flatten_union(expression: exp.Expression) -> list[exp.Expression]:
    if not isinstance(expression, exp.Union):
        return [expression]
    return _flatten_union(expression.this) + _flatten_union(expression.expression)
