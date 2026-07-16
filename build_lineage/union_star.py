from __future__ import annotations

from sqlglot import exp
from sqlglot.optimizer.scope import Scope, traverse_scope

from .metadata import MetadataServiceError, TableMetadataClient
from .sql_parser import SqlStructureError


def expand_insert_stars(
    raw_sql: str,
    dialect: str,
    metadata_client: TableMetadataClient | None,
) -> str:
    """Return INSERT SQL with only deterministic derived-source stars expanded."""
    import sqlglot

    insert = sqlglot.parse_one(raw_sql, read=dialect)
    if not isinstance(insert, exp.Insert):
        return raw_sql
    query = insert.expression
    if isinstance(query, exp.Subquery):
        query = query.this
        insert.set("expression", query)
    if not isinstance(query, exp.Query):
        return raw_sql
    root_had_star = isinstance(query, exp.Select) and any(
        _is_star_projection(item) for item in query.expressions
    )
    with_clause = insert.args.get("with_")
    if with_clause is not None:
        query.set("with_", with_clause.copy())
    expand_single_source_derived_stars(query, metadata_client)
    if root_had_star and isinstance(query, exp.Select) and not any(
        _is_star_projection(item) for item in query.expressions
    ):
        _alias_root_outputs_from_target_schema(
            insert, query, metadata_client
        )
    if with_clause is not None:
        query.set("with_", None)
    return insert.sql(dialect=dialect)


def _alias_root_outputs_from_target_schema(
    insert: exp.Insert,
    query: exp.Select,
    metadata_client: TableMetadataClient | None,
) -> None:
    if metadata_client is None or not isinstance(insert.this, exp.Table):
        return
    table = insert.this
    if not table.db or table.catalog:
        return
    try:
        schema = metadata_client.get_table(table.db, table.name)
    except (MetadataServiceError, ValueError):
        return
    dynamic_count = 0
    partition = table.args.get("partition")
    if isinstance(partition, exp.Partition):
        dynamic_count = sum(
            isinstance(item, exp.Column) for item in partition.expressions
        )
    expressions = list(query.expressions)
    data_count = len(expressions) - dynamic_count
    if data_count != len(schema.data_columns):
        return
    for index, column in enumerate(schema.data_columns):
        expression = expressions[index]
        if expression.alias_or_name.lower() != column.name.lower():
            expressions[index] = expression.as_(column.name)
    query.set("expressions", expressions)


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


def expand_derived_union_stars(
    query: exp.Expression,
    metadata_client: TableMetadataClient | None = None,
) -> None:
    """Expand single-derived-source UNION stars by the source output contract."""
    for scope in traverse_scope(query):
        if not isinstance(scope.expression, exp.SetOperation):
            continue
        expansions: list[tuple[exp.Select, list[exp.Expression]]] = []
        explicit_counts: set[int] = set()
        unsupported_star = False
        for branch_scope in scope.union_scopes:
            branch = branch_scope.expression
            if isinstance(branch, exp.SetOperation):
                nested_outputs = list(branch.selects)
                if nested_outputs and not any(
                    _is_star_projection(item) for item in nested_outputs
                ):
                    explicit_counts.add(len(nested_outputs))
                    continue
                unsupported_star = True
                break
            if not isinstance(branch, exp.Select):
                unsupported_star = True
                break
            if not any(_is_star_projection(item) for item in branch.expressions):
                explicit_counts.add(len(branch.expressions))
                continue
            expansion = _derived_star_expansion(branch_scope, metadata_client)
            if expansion is None:
                unsupported_star = True
                break
            expansions.append((branch, expansion))

        if unsupported_star or not expansions:
            continue
        counts = explicit_counts | {len(items) for _, items in expansions}
        if len(counts) != 1:
            raise SqlStructureError(
                "cannot expand derived UNION SELECT *: branch output counts "
                f"differ: {sorted(counts)}"
            )
        for branch, expressions in expansions:
            branch.set("expressions", expressions)


def expand_single_source_derived_stars(
    query: exp.Expression,
    metadata_client: TableMetadataClient | None = None,
) -> None:
    """Expand stars only when one derived source has a deterministic contract."""
    for scope in traverse_scope(query):
        select = scope.expression
        if not isinstance(select, exp.Select) or not any(
            _is_star_projection(item) for item in select.expressions
        ):
            continue
        expansion = _derived_star_expansion(scope, metadata_client)
        if expansion is not None:
            select.set("expressions", expansion)


def _derived_star_expansion(
    scope: Scope,
    metadata_client: TableMetadataClient | None,
) -> list[exp.Expression] | None:
    select = scope.expression
    if not isinstance(select, exp.Select):
        return None
    stars = [
        projection for projection in select.expressions
        if _is_star_projection(projection)
    ]
    if len(stars) != 1:
        return None
    projection = stars[0]
    selected = list(scope.selected_sources.items())
    if len(selected) != 1:
        return None
    alias, (_, source) = selected[0]
    if not isinstance(source, Scope):
        return None
    value = projection.this if isinstance(projection, exp.Alias) else projection
    if isinstance(value, exp.Column) and value.table and value.table != alias:
        return None
    names = _scope_output_names(source, metadata_client, frozenset())
    if names is None:
        return None
    explicit_names = {
        item.alias_or_name.lower()
        for item in select.expressions
        if item is not projection and item.alias_or_name
    }
    if explicit_names & {name.lower() for name in names}:
        return None
    result: list[exp.Expression] = []
    for item in select.expressions:
        if item is projection:
            result.extend(exp.column(name, table=alias) for name in names)
        else:
            result.append(item.copy())
    return result


def _scope_output_names(
    scope: Scope,
    metadata_client: TableMetadataClient | None,
    visiting: frozenset[int],
) -> list[str] | None:
    if id(scope) in visiting:
        return None
    visiting = visiting | {id(scope)}
    outputs = list(scope.expression.selects)
    if outputs and not any(_is_star_projection(item) for item in outputs):
        names = [item.alias_or_name for item in outputs]
        lowered = [name.lower() for name in names if name]
        if len(lowered) == len(names) and len(lowered) == len(set(lowered)):
            return names
        return None
    if len(outputs) != 1 or not _is_star_projection(outputs[0]):
        return None

    selected = list(scope.selected_sources.values())
    if len(selected) != 1:
        return None
    source = selected[0][1]
    if isinstance(source, Scope):
        return _scope_output_names(source, metadata_client, visiting)
    if (
        not isinstance(source, exp.Table)
        or metadata_client is None
        or not source.db
        or source.catalog
    ):
        return None
    try:
        table = metadata_client.get_table(source.db, source.name)
    except (MetadataServiceError, ValueError):
        return None
    return [
        column.name
        for column in table.data_columns + table.partition_columns
    ]


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
