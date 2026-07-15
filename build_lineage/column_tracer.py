from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any, Iterable

import sqlglot
from sqlglot import exp
from sqlglot.errors import SqlglotError
from sqlglot.lineage import Node, lineage
from sqlglot.optimizer.scope import Scope, find_all_in_scope, traverse_scope

from .metadata import TableMetadataClient
from .output_schema import resolve_insert_output_schema
from .sql_parser import (
    SqlStructureError,
    SqlStructureParser,
    UnionGroup,
)
from .union_star import expand_simple_union_stars


GENERATED_QUALIFIER = re.compile(r"\b_\d+\.")


@dataclass(frozen=True, order=True)
class PhysicalColumn:
    dataset: str
    field: str

    @property
    def ref(self) -> str:
        return f"{self.dataset}.{self.field}"


@dataclass
class TraceNode:
    name: str
    kind: str
    role: str
    expression_sql: str
    physical_sources: list[PhysicalColumn] = field(default_factory=list)
    children: list["TraceNode"] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "kind": self.kind,
            "role": self.role,
            "expression_sql": self.expression_sql,
            "physical_sources": [item.ref for item in self.physical_sources],
            "children": [child.to_dict() for child in self.children],
        }


@dataclass
class BranchTrace:
    order: int
    contribution: str
    expression_sql: str
    direct_relations: list[str]
    physical_datasets: list[str]
    value_sources: list[PhysicalColumn]
    trace: TraceNode

    def to_dict(self, *, include_trace: bool = False) -> dict[str, Any]:
        value = {
            "order": self.order,
            "contribution": self.contribution,
            "expression_sql": self.expression_sql,
            "direct_relations": self.direct_relations,
            "physical_datasets": self.physical_datasets,
            "value_sources": [item.ref for item in self.value_sources],
            "value_transformations": _trace_expressions(self.trace, role="value"),
            "context_transformations": _trace_expressions(
                self.trace,
                role="context",
            ),
        }
        if include_trace:
            value["trace"] = self.trace.to_dict()
        return value


@dataclass
class ColumnTrace:
    target_table: str
    target_field: str
    target_ordinal: int
    value_sources: list[PhysicalColumn]
    final_transformations: list[str]
    branches: list[BranchTrace]
    joins: list[str]
    filters: list[str]
    group_by: list[str]
    warnings: list[str]
    trace: TraceNode

    def to_dict(self, *, include_trace: bool = False) -> dict[str, Any]:
        value = {
            "target": f"{self.target_table}.{self.target_field}",
            "target_position": self.target_ordinal,
            "value_sources": [item.ref for item in self.value_sources],
            "final_transformations": self.final_transformations,
            "branches": [
                branch.to_dict(include_trace=include_trace)
                for branch in self.branches
            ],
            "relational_context": {
                "joins": self.joins,
                "filters": self.filters,
                "group_by": self.group_by,
            },
            "warnings": self.warnings,
        }
        if include_trace:
            value["trace"] = self.trace.to_dict()
        return value


class SingleJobColumnTracer:
    def __init__(
        self,
        dialect: str = "hive",
        metadata_client: TableMetadataClient | None = None,
    ) -> None:
        self.dialect = dialect
        self.structure_parser = SqlStructureParser(dialect)
        self.metadata_client = metadata_client

    def trace(self, raw_sql: str, target_field: str) -> ColumnTrace:
        raw_parsed = self.structure_parser.parse_insert(raw_sql)
        parsed = resolve_insert_output_schema(raw_parsed, self.metadata_client)
        matches = [
            item for item in parsed.output_columns
            if item.name.lower() == target_field.lower() and not item.is_partition
        ]
        if not matches:
            raise SqlStructureError(
                f"target field {target_field!r} is not an INSERT output column"
            )
        if len(matches) > 1:
            raise SqlStructureError(
                f"target field {target_field!r} occurs more than once"
            )
        original_output = raw_parsed.output_columns[matches[0].ordinal - 1]
        resolved_by_schema = (
            original_output.name.lower() != matches[0].name.lower()
        )

        insert = sqlglot.parse_one(raw_sql, read=self.dialect)
        if not isinstance(insert, exp.Insert):
            raise SqlStructureError("expected INSERT statement")
        query = insert.expression.copy()
        with_clause = insert.args.get("with_")
        if with_clause is not None:
            query.set("with_", with_clause.copy())
        expand_simple_union_stars(query, self.metadata_client)
        if resolved_by_schema:
            _alias_query_output(query, matches[0].ordinal, matches[0].name)
        star_resolver = StarColumnResolver(query)
        try:
            root = lineage(
                matches[0].name,
                query,
                dialect=self.dialect,
                trim_selects=True,
            )
        except (SqlglotError, ValueError) as error:
            raise SqlStructureError(f"column trace failed: {error}") from error

        union_group, fanout = _select_union_fanout(
            root,
            parsed.union_groups,
            target_field,
        )
        warnings = list(parsed.warnings)
        if resolved_by_schema:
            warnings.append(
                f"target field {target_field!r} resolved from target table schema "
                f"at output position {matches[0].ordinal}"
            )
        branches: list[BranchTrace] = []
        if fanout is not None and union_group is not None:
            for index, child in enumerate(fanout.downstream):
                structure = union_group.branches[index]
                sources = _physical_sources(child, star_resolver)
                branches.append(BranchTrace(
                    order=index + 1,
                    contribution=(
                        "constant_branch"
                        if _is_constant_expression(child.expression)
                        else "value"
                    ),
                    expression_sql=_display_expression(child),
                    direct_relations=list(structure.source_relations),
                    physical_datasets=list(structure.resolved_source_datasets),
                    value_sources=sources,
                    trace=_trace_node(child, star_resolver),
                ))
        elif parsed.union_groups:
            warnings.append(
                "target-related UNION exists but lineage fan-out was not found"
            )

        joins, filters, groups = _relational_context(insert)
        return ColumnTrace(
            target_table=parsed.target_table,
            target_field=matches[0].name,
            target_ordinal=matches[0].ordinal,
            value_sources=_physical_sources(root, star_resolver),
            final_transformations=_final_transformations(root, fanout),
            branches=branches,
            joins=joins,
            filters=filters,
            group_by=groups,
            warnings=warnings,
            trace=_trace_node(root, star_resolver),
        )


def _alias_query_output(
    query: exp.Expression,
    ordinal: int,
    target_field: str,
) -> None:
    owner: exp.Expression = query
    while isinstance(owner, exp.SetOperation):
        owner = owner.this
    if not isinstance(owner, exp.Select):
        raise SqlStructureError("INSERT query output cannot be aliased")
    expressions = list(owner.expressions)
    if ordinal < 1 or ordinal > len(expressions):
        raise SqlStructureError(
            f"target schema position {ordinal} exceeds INSERT output count"
        )
    expressions[ordinal - 1] = expressions[ordinal - 1].as_(target_field)
    owner.set("expressions", expressions)


class StarColumnResolver:
    """Resolve a named column through qualified and unqualified star projections."""

    def __init__(self, query: exp.Expression) -> None:
        self.scopes = list(traverse_scope(query))

    def resolve_node(self, node: Node) -> list[PhysicalColumn]:
        if not isinstance(node.expression, exp.Star) or "." not in node.name:
            return []
        alias, field_name = node.name.rsplit(".", 1)
        local = self._resolve_node_source(node.source, field_name)
        if local:
            return local
        result: set[PhysicalColumn] = set()
        for scope in self.scopes:
            selected = scope.selected_sources.get(alias)
            if selected is None:
                continue
            result.update(self._resolve_source(
                selected[1],
                field_name,
                frozenset(),
            ))
        return sorted(result)

    def _resolve_node_source(
        self,
        source_expression: exp.Expression,
        field_name: str,
    ) -> list[PhysicalColumn]:
        scopes = list(traverse_scope(source_expression))
        if not scopes:
            return []
        root = scopes[-1]
        selected_sources = [
            source for _, source in root.selected_sources.values()
        ]
        if any(
            isinstance(source, exp.Table)
            and not source.db
            and not source.catalog
            for source in selected_sources
        ):
            # A node-local source may omit the outer WITH clause and expose a
            # CTE as an unqualified table. The full-query scopes can resolve it.
            return []
        result: set[PhysicalColumn] = set()
        for source in selected_sources:
            result.update(self._resolve_source(
                source,
                field_name,
                frozenset(),
            ))
        return sorted(result)

    def _resolve_source(
        self,
        source: exp.Table | Scope,
        field_name: str,
        visiting: frozenset[tuple[int, str]],
    ) -> set[PhysicalColumn]:
        if isinstance(source, exp.Table):
            dataset = _table_name(source)
            return {
                PhysicalColumn(dataset, field_name)
            } if dataset else set()
        key = (id(source), field_name.lower())
        if key in visiting:
            return set()
        visiting = visiting | {key}
        if isinstance(source.expression, exp.SetOperation):
            result: set[PhysicalColumn] = set()
            positions = [
                index for index, projection in enumerate(source.expression.selects)
                if projection.alias_or_name.lower() == field_name.lower()
                or _is_star_projection(projection)
            ]
            for union_scope in source.union_scopes:
                for position in positions:
                    selects = list(union_scope.expression.selects)
                    if position < len(selects):
                        result.update(self._resolve_projection(
                            union_scope,
                            selects[position],
                            field_name,
                            visiting,
                        ))
            return result
        projections = [
            projection for projection in source.expression.selects
            if projection.alias_or_name.lower() == field_name.lower()
        ]
        if projections:
            result: set[PhysicalColumn] = set()
            for projection in projections:
                result.update(self._resolve_projection(
                    source,
                    projection,
                    field_name,
                    visiting,
                ))
            return result
        result: set[PhysicalColumn] = set()
        for projection in source.expression.selects:
            if _is_star_projection(projection):
                result.update(self._resolve_projection(
                    source,
                    projection,
                    field_name,
                    visiting,
                ))
        return result

    def _resolve_projection(
        self,
        scope: Scope,
        projection: exp.Expression,
        field_name: str,
        visiting: frozenset[tuple[int, str]],
    ) -> set[PhysicalColumn]:
        if _is_star_projection(projection):
            qualifier = projection.table if isinstance(projection, exp.Column) else ""
            if qualifier:
                source = scope.sources.get(qualifier)
                return (
                    self._resolve_source(source, field_name, visiting)
                    if isinstance(source, (exp.Table, Scope))
                    else set()
                )
            direct = [source for _, source in scope.selected_sources.values()]
            if len(direct) == 1 and isinstance(direct[0], (exp.Table, Scope)):
                return self._resolve_source(direct[0], field_name, visiting)
            return set()

        result: set[PhysicalColumn] = set()
        for column in find_all_in_scope(projection, exp.Column):
            if column.is_star:
                continue
            source = scope.sources.get(column.table) if column.table else None
            if source is None and not column.table:
                direct = [item for _, item in scope.selected_sources.values()]
                if len(direct) == 1:
                    source = direct[0]
            if isinstance(source, (exp.Table, Scope)):
                result.update(self._resolve_source(source, column.name, visiting))
        return result


def _trace_node(node: Node, star_resolver: StarColumnResolver) -> TraceNode:
    sources = _physical_sources(node, star_resolver)
    if isinstance(node.expression, exp.Table):
        kind = "physical_source"
    elif not node.downstream and _is_constant_expression(node.expression):
        kind = "constant"
    else:
        kind = "transformation"
    role = "value" if sources else "context"
    return TraceNode(
        name=_display_name(node.name),
        kind=kind,
        role=role,
        expression_sql=_display_expression(node),
        physical_sources=sources,
        children=[_trace_node(child, star_resolver) for child in node.downstream],
    )


def _physical_sources(
    node: Node,
    star_resolver: StarColumnResolver | None = None,
) -> list[PhysicalColumn]:
    sources: set[PhysicalColumn] = set()
    seen: set[int] = set()
    stack = [node]
    while stack:
        item = stack.pop()
        if id(item) in seen:
            continue
        seen.add(id(item))
        if isinstance(item.expression, exp.Table):
            dataset = _table_name(item.expression)
            field_name = item.name.rsplit(".", 1)[-1]
            if dataset and field_name and field_name != "*":
                sources.add(PhysicalColumn(dataset=dataset, field=field_name))
        elif star_resolver is not None:
            resolved = star_resolver.resolve_node(item)
            if resolved:
                sources.update(resolved)
                # SQLGlot attaches every relation below an unresolved star.
                # The qualifier-aware resolver has already selected the true side.
                continue
        stack.extend(reversed(item.downstream))
    return sorted(sources)


def _walk_nodes(root: Node) -> Iterable[Node]:
    seen: set[int] = set()
    stack = [root]
    while stack:
        node = stack.pop()
        identity = id(node)
        if identity in seen:
            continue
        seen.add(identity)
        yield node
        stack.extend(reversed(node.downstream))


def _select_union_fanout(
    root: Node,
    union_groups: list[UnionGroup],
    target_field: str,
) -> tuple[UnionGroup | None, Node | None]:
    candidates: list[tuple[UnionGroup, int]] = []
    for group in union_groups:
        if not group.branches:
            continue
        for index, name in enumerate(group.branches[0].output_names):
            if name.lower() == target_field.lower():
                candidates.append((group, index))
    for group, target_index in candidates:
        for node in _walk_nodes(root):
            if len(node.downstream) != group.branch_count:
                continue
            child_names = {child.name for child in node.downstream}
            if child_names == {str(target_index)}:
                return group, node
    return (candidates[0][0], None) if candidates else (None, None)


def _final_transformations(root: Node, fanout: Node | None) -> list[str]:
    result: list[str] = []
    node = root
    while True:
        expression = _display_expression(node)
        if not result or result[-1] != expression:
            result.append(expression)
        if node is fanout or len(node.downstream) != 1:
            break
        node = node.downstream[0]
    return result


def _relational_context(
    expression: exp.Expression,
) -> tuple[list[str], list[str], list[str]]:
    joins: set[str] = set()
    filters: set[str] = set()
    groups: set[str] = set()
    for select in expression.find_all(exp.Select):
        for join in select.args.get("joins") or []:
            joins.add(_compact_join_sql(join, dialect="hive"))
        where = select.args.get("where")
        if isinstance(where, exp.Where):
            filters.add(where.this.sql(dialect="hive"))
        group = select.args.get("group")
        if isinstance(group, exp.Group):
            groups.update(
                item.sql(dialect="hive")
                for item in group.expressions
            )
    return sorted(joins), sorted(filters), sorted(groups)


def _compact_join_sql(join: exp.Join, *, dialect: str) -> str:
    relation = join.this
    if isinstance(relation, exp.Subquery) and relation.alias_or_name:
        relation_sql = relation.alias_or_name
    else:
        relation_sql = relation.sql(dialect=dialect)
    parts = [
        str(join.args.get(key) or "").upper()
        for key in ("method", "side", "kind")
    ]
    prefix = " ".join(part for part in parts if part)
    result = f"{prefix + ' ' if prefix else ''}JOIN {relation_sql}"
    on = join.args.get("on")
    if isinstance(on, exp.Expression):
        result += f" ON {on.sql(dialect=dialect)}"
    using = join.args.get("using")
    if using:
        result += " USING (" + ", ".join(
            item.sql(dialect=dialect) for item in using
        ) + ")"
    return result


def _is_constant_expression(expression: exp.Expression) -> bool:
    value = expression.this if isinstance(expression, exp.Alias) else expression
    return not any(value.find_all(exp.Column)) and not isinstance(value, exp.Table)


def _is_star_projection(projection: exp.Expression) -> bool:
    value = projection.this if isinstance(projection, exp.Alias) else projection
    return isinstance(value, exp.Star) or (
        isinstance(value, exp.Column) and value.is_star
    )


def _trace_expressions(root: TraceNode, *, role: str) -> list[str]:
    result: list[str] = []
    stack = [root]
    while stack:
        node = stack.pop()
        if node.role == role and node.kind == "transformation":
            if node.expression_sql not in result:
                result.append(node.expression_sql)
        stack.extend(reversed(node.children))
    return result


def _display_expression(node: Node) -> str:
    if isinstance(node.expression, exp.Table):
        return _table_name(node.expression)
    return _clean_sql(node.expression.sql(dialect="hive"))


def _display_name(name: str) -> str:
    return GENERATED_QUALIFIER.sub("", name)


def _clean_sql(value: str) -> str:
    return GENERATED_QUALIFIER.sub("", value)


def _table_name(table: exp.Table) -> str:
    return ".".join(
        part for part in (table.catalog, table.db, table.name) if part
    )
