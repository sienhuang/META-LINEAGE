from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import sqlglot
from sqlglot import exp
from sqlglot.errors import SqlglotError
from sqlglot.lineage import Node, lineage
from sqlglot.optimizer.scope import Scope, find_all_in_scope, traverse_scope

from .column_tracer import (
    ColumnTrace,
    PhysicalColumn,
    StarColumnResolver,
    _alias_query_output,
)
from .document import DEFAULT_OUTPUT_ROOT
from .postgres import JobRecord
from .sql_parser import PartitionColumn, SqlStructureError, SqlStructureParser


Requirement = str | int


@dataclass(frozen=True)
class ProductionSql:
    sql: str
    target: str
    output_columns: tuple[str, ...]
    value_sources: tuple[str, ...]
    union_branch_count: int
    validated: bool

    def summary(self) -> dict[str, object]:
        return {
            "target": self.target,
            "output_columns": list(self.output_columns),
            "value_sources": list(self.value_sources),
            "union_branch_count": self.union_branch_count,
            "validated": self.validated,
            "validation_level": "ast_scope_and_column_lineage",
        }


class ProductionSqlGenerator:
    def __init__(self, dialect: str = "hive") -> None:
        self.dialect = dialect
        self.structure_parser = SqlStructureParser(dialect)

    def generate(
        self,
        raw_sql: str,
        target_field: str,
        expected_trace: ColumnTrace,
    ) -> ProductionSql:
        parsed = self.structure_parser.parse_insert(raw_sql)
        insert = sqlglot.parse_one(raw_sql, read=self.dialect)
        if not isinstance(insert, exp.Insert):
            raise SqlStructureError("expected INSERT statement")

        query = insert.expression.copy()
        with_clause = insert.args.get("with_")
        if with_clause is not None:
            query.set("with_", with_clause.copy())

        if not any(
            item.alias_or_name.lower() == target_field.lower()
            for item in query.selects
            if item.alias_or_name
        ):
            _alias_query_output(
                query,
                expected_trace.target_ordinal,
                target_field,
            )

        output_names = _production_output_names(
            query,
            target_field,
            [item.name for item in parsed.partitions if item.dynamic],
        )
        _prune_query(query, set(output_names))
        _append_static_partitions(query, parsed.partitions, self.dialect)
        output_names = [item.alias_or_name for item in query.selects]
        production_sql = query.sql(dialect=self.dialect, pretty=True) + ";\n"
        validation = self._validate(
            production_sql,
            target_field,
            expected_trace.value_sources,
        )
        return ProductionSql(
            sql=production_sql,
            target=f"{parsed.target_table}.{target_field}",
            output_columns=tuple(output_names),
            value_sources=tuple(validation["value_sources"]),
            union_branch_count=int(validation["union_branch_count"]),
            validated=True,
        )

    def _validate(
        self,
        production_sql: str,
        target_field: str,
        expected_sources: list[PhysicalColumn],
    ) -> dict[str, object]:
        try:
            query = sqlglot.parse_one(production_sql, read=self.dialect)
            _validate_scope_contracts(query)
            star_resolver = StarColumnResolver(query)
            root = lineage(
                target_field,
                query,
                dialect=self.dialect,
                trim_selects=True,
            )
        except (SqlglotError, ValueError) as error:
            raise SqlStructureError(
                f"generated production SQL validation failed: {error}"
            ) from error
        actual_sources = sorted(_lineage_source_refs(root, star_resolver))
        expected_refs = sorted(item.ref for item in expected_sources)
        if actual_sources != expected_refs:
            raise SqlStructureError(
                "generated SQL changed value sources: "
                f"expected {expected_refs}, found {actual_sources}"
            )
        unions = [
            item for item in query.find_all(exp.Union)
            if not isinstance(item.parent, exp.Union)
            and any(
                select.alias_or_name.lower() == target_field.lower()
                for select in item.selects
            )
        ]
        branch_count = len(_flatten_union(unions[0])) if unions else 1
        return {
            "value_sources": actual_sources,
            "union_branch_count": branch_count,
        }


def default_production_sql_path(job: JobRecord, target_field: str) -> Path:
    return (
        DEFAULT_OUTPUT_ROOT
        / _safe_path_part(job.job_id)
        / _safe_path_part(target_field)
        / "production.sql"
    )


def write_production_sql(sql_text: str, output_path: Path) -> Path:
    output_path = output_path.expanduser().resolve()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = output_path.with_suffix(f"{output_path.suffix}.tmp")
    temporary.write_text(sql_text, encoding="utf-8")
    temporary.replace(output_path)
    return output_path


def _production_output_names(
    query: exp.Expression,
    target_field: str,
    dynamic_partitions: list[str],
) -> list[str]:
    if not isinstance(query, exp.Query):
        raise SqlStructureError("INSERT query is not selectable")
    available = [item.alias_or_name for item in query.selects]
    lowered = {name.lower(): name for name in available if name}
    if target_field.lower() not in lowered:
        raise SqlStructureError(f"target field not found: {target_field}")

    grain_names: set[str] = set()
    union_roots = [
        union for union in query.find_all(exp.Union)
        if not isinstance(union.parent, exp.Union)
        and any(
            select.alias_or_name.lower() == target_field.lower()
            for select in union.selects
        )
    ]
    if union_roots:
        ancestor = union_roots[0].parent
        while ancestor is not None and not isinstance(ancestor, exp.Select):
            ancestor = ancestor.parent
        if isinstance(ancestor, exp.Select):
            group = ancestor.args.get("group")
            if isinstance(group, exp.Group):
                for expression in group.expressions:
                    grain_names.update(
                        column.name.lower()
                        for column in find_all_in_scope(expression, exp.Column)
                    )

    wanted = grain_names | {target_field.lower()} | {
        item.lower() for item in dynamic_partitions
    }
    output = [name for name in available if name and name.lower() in wanted]
    if target_field.lower() not in {name.lower() for name in output}:
        raise SqlStructureError("target field was lost while selecting output grain")
    return output


def _prune_query(query: exp.Expression, root_requirements: set[str]) -> None:
    scopes = list(traverse_scope(query))
    if not scopes:
        raise SqlStructureError("cannot build SQL scope for production query")
    root_scope = scopes[-1]
    original_selects: dict[int, list[exp.Expression]] = {
        id(scope): list(scope.expression.selects)
        for scope in scopes
        if isinstance(scope.expression, exp.Query)
    }
    requirements: dict[int, set[Requirement]] = {id(root_scope): set(root_requirements)}
    by_id = {id(scope): scope for scope in scopes}
    union_child_ids = {
        id(child)
        for scope in scopes
        if isinstance(scope.expression, exp.SetOperation)
        for child in scope.union_scopes
    }
    queue = [root_scope]

    while queue:
        scope = queue.pop(0)
        required = requirements[id(scope)]
        expression = scope.expression
        original = original_selects.get(id(scope), [])
        if isinstance(expression, exp.SetOperation):
            positions = _required_positions(original, required)
            child_needed: set[Requirement] = set(positions) | {
                item for item in required if isinstance(item, str)
            }
            for child in scope.union_scopes:
                if _add_requirements(requirements, child, child_needed):
                    queue.append(child)
            continue
        if not isinstance(expression, exp.Select):
            continue

        positions = _required_positions(original, required)
        if id(scope) not in union_child_ids:
            positions = sorted(set(positions) | set(
                _group_output_positions(expression, original)
            ))
        selected = [original[index] for index in positions]
        if not selected:
            raise SqlStructureError(
                f"projection pruning removed every output from {expression.sql()[:120]}"
            )
        if id(scope) not in union_child_ids:
            selected = _expand_star_projections(selected, required)
        expression.set("expressions", selected)

        reference_expressions = list(selected)
        for key in (
            "joins",
            "where",
            "group",
            "having",
            "qualify",
            "order",
            "distribute",
        ):
            value = expression.args.get(key)
            if isinstance(value, list):
                reference_expressions.extend(value)
            elif isinstance(value, exp.Expression):
                reference_expressions.append(value)
        columns: set[exp.Column] = set()
        for item in reference_expressions:
            columns.update(find_all_in_scope(item, exp.Column))

        child_requirements: dict[int, set[Requirement]] = {}
        for column in columns:
            child = _column_source_scope(scope, column, original_selects)
            if child is None:
                continue
            child_requirements.setdefault(id(child), set()).add(column.name)
        explicit_names = {
            projection.alias_or_name.lower()
            for projection in selected
            if projection.alias_or_name and not _is_star_projection(projection)
        }
        missing_names = {
            item for item in required
            if isinstance(item, str) and item.lower() not in explicit_names
        }
        for projection in selected:
            if not _is_star_projection(projection):
                continue
            for child in _star_source_scopes(scope, projection):
                child_requirements.setdefault(id(child), set()).update(missing_names)
        for child_id, needed in child_requirements.items():
            child = by_id[child_id]
            if _add_requirements(requirements, child, needed):
                queue.append(child)


def _required_positions(
    selects: list[exp.Expression],
    requirements: set[Requirement],
) -> list[int]:
    positions = {item for item in requirements if isinstance(item, int)}
    names = {str(item).lower() for item in requirements if isinstance(item, str)}
    positions.update(
        index
        for index, select in enumerate(selects)
        if select.alias_or_name.lower() in names
    )
    explicit_names = {
        select.alias_or_name.lower()
        for select in selects
        if select.alias_or_name and not _is_star_projection(select)
    }
    if names - explicit_names:
        positions.update(
            index for index, select in enumerate(selects)
            if _is_star_projection(select)
        )
    return sorted(index for index in positions if 0 <= index < len(selects))


def _expand_star_projections(
    projections: list[exp.Expression],
    requirements: set[Requirement],
) -> list[exp.Expression]:
    explicit_names = {
        projection.alias_or_name.lower()
        for projection in projections
        if projection.alias_or_name and not _is_star_projection(projection)
    }
    missing_names = sorted({
        item for item in requirements
        if isinstance(item, str) and item.lower() not in explicit_names
    })
    if not missing_names:
        return projections
    result: list[exp.Expression] = []
    for projection in projections:
        if not _is_star_projection(projection):
            result.append(projection)
            continue
        value = projection.this if isinstance(projection, exp.Alias) else projection
        qualifier = value.table if isinstance(value, exp.Column) else ""
        result.extend(
            exp.column(name, table=qualifier or None)
            for name in missing_names
        )
    return result


def _group_output_positions(
    select: exp.Select,
    projections: list[exp.Expression],
) -> list[int]:
    group = select.args.get("group")
    if not isinstance(group, exp.Group):
        return []
    group_sql = {
        expression.sql(dialect="hive", comments=False).lower()
        for expression in group.expressions
    }
    group_names = {
        column.name.lower()
        for expression in group.expressions
        for column in find_all_in_scope(expression, exp.Column)
    }
    result: list[int] = []
    for index, projection in enumerate(projections):
        value = projection.this if isinstance(projection, exp.Alias) else projection
        if projection.alias_or_name.lower() in group_names:
            result.append(index)
            continue
        if value.sql(dialect="hive", comments=False).lower() in group_sql:
            result.append(index)
    return result


def _append_static_partitions(
    query: exp.Expression,
    partitions: list[PartitionColumn],
    dialect: str,
) -> None:
    if not isinstance(query, exp.Select):
        if any(not partition.dynamic for partition in partitions):
            raise SqlStructureError(
                "static partition output requires a top-level SELECT"
            )
        return
    existing = {item.alias_or_name.lower() for item in query.selects}
    for partition in partitions:
        if partition.dynamic or partition.name.lower() in existing:
            continue
        if not partition.value_sql:
            raise SqlStructureError(
                f"static partition {partition.name!r} has no value"
            )
        value = sqlglot.parse_one(partition.value_sql, read=dialect)
        query.append("expressions", exp.alias_(value, partition.name))
        existing.add(partition.name.lower())


def _column_source_scope(
    scope: Scope,
    column: exp.Column,
    original_selects: dict[int, list[exp.Expression]],
) -> Scope | None:
    if column.table:
        source = scope.sources.get(column.table)
        return source if isinstance(source, Scope) else None

    direct_entries = list(scope.selected_sources.items())
    direct_sources = [source for _, (_, source) in direct_entries]
    candidates: list[Scope] = []
    for source in direct_sources:
        if not isinstance(source, Scope):
            continue
        names = {
            item.alias_or_name.lower()
            for item in original_selects.get(id(source), [])
            if item.alias_or_name
        }
        if column.name.lower() in names:
            candidates.append(source)
    if len(candidates) == 1:
        return candidates[0]
    if not candidates:
        star_candidates = [
            (alias, source)
            for alias, (_, source) in direct_entries
            if isinstance(source, Scope)
            and any(
                _is_star_projection(item)
                for item in original_selects.get(id(source), [])
            )
        ]
        if len(star_candidates) == 1:
            return star_candidates[0][1]
        if len(star_candidates) > 1:
            aliases = sorted(alias for alias, _ in star_candidates)
            raise SqlStructureError(
                f"ambiguous unqualified column {column.name!r}; "
                f"multiple SELECT * sources may provide it: {aliases}"
            )
    scoped_sources = [source for source in direct_sources if isinstance(source, Scope)]
    return (
        scoped_sources[0]
        if len(direct_sources) == 1 and len(scoped_sources) == 1
        else None
    )


def _add_requirements(
    requirements: dict[int, set[Requirement]],
    scope: Scope,
    needed: set[Requirement],
) -> bool:
    current = requirements.setdefault(id(scope), set())
    before = len(current)
    current.update(needed)
    return len(current) > before


def _lineage_source_refs(
    root: Node,
    star_resolver: StarColumnResolver | None = None,
) -> set[str]:
    result: set[str] = set()
    seen: set[int] = set()
    stack = [root]
    while stack:
        node = stack.pop()
        if id(node) in seen:
            continue
        seen.add(id(node))
        if isinstance(node.expression, exp.Table):
            dataset = ".".join(
                part
                for part in (
                    node.expression.catalog,
                    node.expression.db,
                    node.expression.name,
                )
                if part
            )
            field = node.name.rsplit(".", 1)[-1]
            if field != "*":
                result.add(f"{dataset}.{field}")
        elif star_resolver is not None:
            resolved = star_resolver.resolve_node(node)
            if resolved:
                result.update(item.ref for item in resolved)
                continue
        stack.extend(node.downstream)
    return result


def _is_star_projection(projection: exp.Expression) -> bool:
    value = projection.this if isinstance(projection, exp.Alias) else projection
    return isinstance(value, exp.Star) or (
        isinstance(value, exp.Column) and value.is_star
    )


def _star_source_scopes(
    scope: Scope,
    projection: exp.Expression,
) -> list[Scope]:
    value = projection.this if isinstance(projection, exp.Alias) else projection
    if isinstance(value, exp.Column) and value.is_star and value.table:
        source = scope.sources.get(value.table)
        return [source] if isinstance(source, Scope) else []
    direct = [source for _, source in scope.selected_sources.values()]
    return (
        [source for source in direct if isinstance(source, Scope)]
        if len(direct) == 1
        else []
    )


def _validate_scope_contracts(query: exp.Expression) -> None:
    for scope in traverse_scope(query):
        direct = {
            alias: source
            for alias, (_, source) in scope.selected_sources.items()
        }
        for column in scope.columns:
            if column.table:
                source = direct.get(column.table)
                if isinstance(source, Scope) and not _scope_outputs(source, column.name):
                    raise SqlStructureError(
                        f"generated SQL source {column.table!r} does not output "
                        f"column {column.name!r}"
                    )
                continue
            if _is_computed_output_alias(scope, column.name):
                continue
            derived = [source for source in direct.values() if isinstance(source, Scope)]
            physical_count = sum(
                1 for source in direct.values() if isinstance(source, exp.Table)
            )
            if len(derived) == 1 and physical_count == 0:
                if not _scope_outputs(derived[0], column.name):
                    raise SqlStructureError(
                        f"generated derived query does not output column {column.name!r}"
                    )


def _scope_outputs(scope: Scope, column_name: str) -> bool:
    return any(
        select.alias_or_name.lower() == column_name.lower()
        or _is_star_projection(select)
        for select in scope.expression.selects
    )


def _is_computed_output_alias(scope: Scope, column_name: str) -> bool:
    for select in scope.expression.selects:
        if select.alias_or_name.lower() != column_name.lower():
            continue
        value = select.this if isinstance(select, exp.Alias) else select
        if not isinstance(value, exp.Column):
            return True
        if value.table or value.name.lower() != column_name.lower():
            return True
    return False


def _flatten_union(expression: exp.Expression) -> list[exp.Expression]:
    if not isinstance(expression, exp.Union):
        return [expression]
    return _flatten_union(expression.this) + _flatten_union(expression.expression)


def _safe_path_part(value: str) -> str:
    cleaned = "".join(
        character if character.isalnum() or character in "._-" else "_"
        for character in value
    )
    return cleaned or "unnamed"
