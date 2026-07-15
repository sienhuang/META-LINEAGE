from __future__ import annotations

from collections import defaultdict
from typing import Iterable

from sqlglot import exp


class ColumnSqlSlicer:
    """Recursively prune a query to the columns required by one output field.

    Relational semantics are retained: FROM/JOIN/WHERE/GROUP BY stay in place,
    while SELECT and UNION projections are pushed down through subqueries/CTEs.
    """

    def slice(self, query: exp.Query, output_fields: set[str]) -> exp.Query:
        result = query.copy()
        self._slice_local_query(result, {name.lower() for name in output_fields})
        return result

    def _slice_local_query(self, query: exp.Query, required: set[str]) -> None:
        with_clause = query.args.get("with_")
        ctes: dict[str, exp.CTE] = {}
        cte_order: list[str] = []
        if with_clause is not None:
            for cte in with_clause.expressions:
                name = cte.alias_or_name.lower()
                ctes[name] = cte
                cte_order.append(name)
            query.set("with_", None)

        cte_requirements: dict[str, set[str]] = defaultdict(set)
        self._slice_query_body(query, required, ctes, cte_requirements)

        processed: dict[str, set[str]] = defaultdict(set)
        while True:
            pending = [
                name for name in cte_order
                if cte_requirements[name] - processed[name]
            ]
            if not pending:
                break
            for name in pending:
                needed = set(cte_requirements[name])
                processed[name] = set(needed)
                self._slice_query_body(
                    ctes[name].this, needed, ctes, cte_requirements
                )

        used = self._reachable_ctes(query, ctes)
        changed = True
        while changed:
            changed = False
            for name in list(used):
                nested = self._reachable_ctes(ctes[name].this, ctes)
                if not nested.issubset(used):
                    used.update(nested)
                    changed = True
        if with_clause is not None and used:
            query.set("with_", exp.With(
                expressions=[ctes[name] for name in cte_order if name in used],
                recursive=with_clause.args.get("recursive"),
            ))

    def _slice_query_body(
        self,
        query: exp.Query,
        required: set[str],
        ctes: dict[str, exp.CTE],
        cte_requirements: dict[str, set[str]],
    ) -> None:
        if isinstance(query, exp.SetOperation):
            self._slice_union(query, required, ctes, cte_requirements)
            return
        if not isinstance(query, exp.Select):
            return

        projections = list(query.expressions)
        selected = self._select_projections(projections, required)
        query.set("expressions", selected)

        relations = self._relations(query)
        relation_requirements: dict[str, set[str]] = defaultdict(set)
        expressions: list[exp.Expression] = list(selected)
        for key in ("where", "group", "having", "qualify", "order"):
            clause = query.args.get(key)
            if clause is not None:
                expressions.append(clause)
        for join in query.args.get("joins") or []:
            condition = join.args.get("on")
            if condition is not None:
                expressions.append(condition)

        aliases = {alias for alias, _relation in relations}
        for expression in expressions:
            for column in self._scope_columns(expression):
                name = column.name.lower()
                table = column.table.lower() if column.table else ""
                if table in aliases:
                    relation_requirements[table].add(name)
                elif len(relations) == 1:
                    relation_requirements[relations[0][0]].add(name)
                else:
                    # Unqualified columns over several inputs cannot be safely
                    # assigned without a schema. Retaining them for every
                    # subquery/CTE is conservative; unknown physical tables are
                    # unaffected.
                    for alias, _relation in relations:
                        relation_requirements[alias].add(name)

        for alias, relation in relations:
            needed = relation_requirements.get(alias, set())
            if isinstance(relation, exp.Subquery):
                # The subquery can reference CTEs declared by the outer query;
                # keep using the same CTE requirement accumulator so demand is
                # pushed through UNION/subquery layers back into those CTEs.
                self._slice_query_body(
                    relation.this, needed, ctes, cte_requirements
                )
            elif isinstance(relation, exp.Table):
                cte_name = relation.name.lower()
                if cte_name in ctes:
                    cte_requirements[cte_name].update(needed)

    def _slice_union(
        self,
        query: exp.SetOperation,
        required: set[str],
        ctes: dict[str, exp.CTE],
        cte_requirements: dict[str, set[str]],
    ) -> None:
        leaves = list(self._union_leaves(query))
        if not leaves:
            return
        first = leaves[0]
        indexes = [
            index for index, projection in enumerate(first.expressions)
            if projection.alias_or_name.lower() in required
        ]
        if not indexes and any(isinstance(item, exp.Star) for item in first.expressions):
            indexes = list(range(len(first.expressions)))
        for leaf in leaves:
            selected = [
                leaf.expressions[index].copy()
                for index in indexes
                if index < len(leaf.expressions)
            ]
            branch_required = {
                item.alias_or_name.lower() for item in selected
                if item.alias_or_name
            }
            leaf.set("expressions", selected)
            self._slice_query_body(
                leaf, branch_required, ctes, cte_requirements
            )

    @staticmethod
    def _select_projections(
        projections: list[exp.Expression], required: set[str]
    ) -> list[exp.Expression]:
        selected = [
            item.copy() for item in projections
            if item.alias_or_name and item.alias_or_name.lower() in required
        ]
        if selected:
            return selected
        star = next((item for item in projections if isinstance(item, exp.Star)), None)
        if star is not None:
            return [exp.column(name) for name in sorted(required)]
        # Keep the original projection when a parser cannot expose its alias;
        # producing an empty SELECT would be invalid and hide the gap.
        return [item.copy() for item in projections]

    @staticmethod
    def _relations(select: exp.Select) -> list[tuple[str, exp.Expression]]:
        relations: list[tuple[str, exp.Expression]] = []
        from_clause = select.args.get("from_")
        candidates = []
        if from_clause is not None and from_clause.this is not None:
            candidates.append(from_clause.this)
        candidates.extend(join.this for join in select.args.get("joins") or [])
        for relation in candidates:
            if isinstance(relation, (exp.Table, exp.Subquery)):
                relations.append((relation.alias_or_name.lower(), relation))
        return relations

    @staticmethod
    def _scope_columns(expression: exp.Expression) -> Iterable[exp.Column]:
        for node in expression.walk(
            prune=lambda item: isinstance(item, exp.Query) and item is not expression
        ):
            if isinstance(node, exp.Column):
                yield node

    @staticmethod
    def _union_leaves(query: exp.Query) -> Iterable[exp.Select]:
        if isinstance(query, exp.SetOperation):
            yield from ColumnSqlSlicer._union_leaves(query.this)
            yield from ColumnSqlSlicer._union_leaves(query.expression)
        elif isinstance(query, exp.Select):
            yield query

    @staticmethod
    def _reachable_ctes(query: exp.Expression, ctes: dict[str, exp.CTE]) -> set[str]:
        result: set[str] = set()
        for table in query.find_all(exp.Table):
            name = table.name.lower()
            if name in ctes:
                result.add(name)
        return result
