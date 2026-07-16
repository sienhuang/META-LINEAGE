from __future__ import annotations

from sqlglot import exp
from sqlglot.optimizer.scope import Scope, find_all_in_scope, traverse_scope

from .metadata import MetadataServiceError, TableMetadataClient


def protect_lateral_explode_columns(query: exp.Expression) -> int:
    """Avoid sqlglot's recursive type lookup for direct-column Hive EXPLODE.

    Parenthesizing the input is SQL-semantic preserving, while preventing
    sqlglot's Lateral resolver from recursively walking every nested CTE source
    solely to infer a struct element type. That walk can become non-terminating
    for large CTE graphs containing multiple lateral views.
    """
    changed = 0
    for lateral in query.find_all(exp.Lateral):
        explode = lateral.this
        if not isinstance(explode, exp.Explode) or not isinstance(
            explode.this,
            exp.Column,
        ):
            continue
        explode.set("this", exp.Paren(this=explode.this.copy()))
        changed += 1
    return changed


def qualify_single_source_shadowed_columns(query: exp.Expression) -> int:
    """Disambiguate Hive input columns shadowed by sibling SELECT aliases.

    Hive does not make one SELECT-list alias available to another expression in
    the same SELECT list. SQLGlot lineage can nevertheless expand an
    unqualified reference through a sibling alias with the same name. When a
    SELECT has exactly one input and that input can provide the name, qualify
    the reference with the input alias so lineage follows Hive semantics.

    Multi-source SELECTs and derived inputs that demonstrably lack the column
    are intentionally left unchanged because choosing a source would be
    ambiguous or would turn invalid SQL into different SQL.
    """
    changed = 0
    for scope in traverse_scope(query):
        if not isinstance(scope.expression, exp.Select):
            continue
        selected_sources = list(scope.selected_sources.items())
        if len(selected_sources) != 1:
            continue
        source_alias, (_, source) = selected_sources[0]
        if not source_alias or not isinstance(source, (exp.Table, Scope)):
            continue

        for projection in scope.expression.selects:
            sibling_output_names = {
                sibling.alias_or_name.lower()
                for sibling in scope.expression.selects
                if sibling is not projection and sibling.alias_or_name
            }
            for column in find_all_in_scope(projection, exp.Column):
                if column.table or column.is_star:
                    continue
                if column.name.lower() not in sibling_output_names:
                    continue
                if isinstance(source, Scope) and not _scope_may_output(
                    source,
                    column.name,
                ):
                    continue
                column.set("table", exp.to_identifier(source_alias))
                changed += 1
    return changed


def qualify_metadata_unique_columns(
    query: exp.Expression,
    metadata_client: TableMetadataClient | None,
) -> int:
    """Qualify an unqualified projection column only with a proven source."""
    if metadata_client is None:
        return 0
    changed = 0
    for scope in traverse_scope(query):
        if not isinstance(scope.expression, exp.Select):
            continue
        sources = list(scope.selected_sources.items())
        if len(sources) < 2:
            continue
        for projection in scope.expression.selects:
            for column in find_all_in_scope(projection, exp.Column):
                if column.table or column.is_star:
                    continue
                statuses = [
                    (
                        alias,
                        _source_may_output(
                            source[1],
                            column.name,
                            metadata_client,
                            frozenset(),
                        ),
                    )
                    for alias, source in sources
                ]
                candidates = [alias for alias, status in statuses if status is True]
                if len(candidates) != 1 or any(
                    status is None for _, status in statuses
                ):
                    continue
                column.set("table", exp.to_identifier(candidates[0]))
                changed += 1
    return changed


def _scope_may_output(scope: Scope, column_name: str) -> bool:
    lowered = column_name.lower()
    return any(
        projection.alias_or_name.lower() == lowered
        or _is_star_projection(projection)
        for projection in scope.expression.selects
    )


def _source_may_output(
    source: exp.Table | Scope,
    column_name: str,
    metadata_client: TableMetadataClient,
    visiting: frozenset[tuple[int, str]],
) -> bool | None:
    if isinstance(source, exp.Table):
        if not source.db or source.catalog:
            return None
        try:
            table = metadata_client.get_table(source.db, source.name)
        except (MetadataServiceError, ValueError):
            return None
        lowered = column_name.lower()
        return any(
            column.name.lower() == lowered
            for column in table.data_columns + table.partition_columns
        )

    key = (id(source), column_name.lower())
    if key in visiting:
        return None
    visiting = visiting | {key}
    outputs = list(source.expression.selects)
    if any(
        item.alias_or_name.lower() == column_name.lower()
        for item in outputs
        if item.alias_or_name and not _is_star_projection(item)
    ):
        return True
    stars = [item for item in outputs if _is_star_projection(item)]
    if not stars:
        return False

    statuses: list[bool | None] = []
    for star in stars:
        value = star.this if isinstance(star, exp.Alias) else star
        if isinstance(value, exp.Column) and value.table:
            nested_sources = [source.sources.get(value.table)]
        else:
            nested_sources = [item for _, item in source.selected_sources.values()]
        for nested in nested_sources:
            if isinstance(nested, (exp.Table, Scope)):
                statuses.append(_source_may_output(
                    nested,
                    column_name,
                    metadata_client,
                    visiting,
                ))
            else:
                statuses.append(None)
    if any(status is True for status in statuses):
        return True
    if any(status is None for status in statuses) or not statuses:
        return None
    return False


def _is_star_projection(expression: exp.Expression) -> bool:
    value = expression.this if isinstance(expression, exp.Alias) else expression
    return isinstance(value, exp.Star) or (
        isinstance(value, exp.Column) and value.is_star
    )
