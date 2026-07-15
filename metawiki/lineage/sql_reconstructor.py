from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, Iterable, Optional

from sqlglot import exp, parse_one

from .dependency_graph import ProvenanceReader
from .production_bundle import ProductionBundle, ProductionBundleBuilder
from .column_sql_slicer import ColumnSqlSlicer


@dataclass
class ReconstructedSql:
    sql: str
    warnings: list[str] = field(default_factory=list)


class ProductionSqlReconstructor:
    """Build one executable query by inlining selected producer jobs.

    The provenance graph decides *which* physical-table producer is valid.
    SQLGlot is then used to replace that table with the producer's write query;
    this avoids the invalid CTEs created by the old metadata string renderer.
    """

    def __init__(self, reader: ProvenanceReader, dialect: str = "hive") -> None:
        self.reader = reader
        self.dialect = dialect

    def reconstruct(
        self,
        target_definition_id: str,
        producer_overrides: Optional[Dict[str, str]] = None,
        max_depth: int = 30,
    ) -> ReconstructedSql:
        bundle = ProductionBundleBuilder(self.reader).build(
            target_definition_id,
            producer_overrides=producer_overrides,
            max_depth=max_depth,
        )
        if bundle.unresolved_boundaries:
            reasons = ", ".join(sorted({
                item["reason"] for item in bundle.unresolved_boundaries
            }))
            raise ValueError(
                "Cannot reconstruct SQL while lineage boundaries are unresolved: "
                + reasons
            )

        target = self.reader.get_definition(target_definition_id)
        if target is None:
            raise ValueError(f"Definition not found: {target_definition_id}")

        queries: dict[str, exp.Query] = {}
        produced_datasets: dict[str, dict[str, set[str]]] = {}
        job_partitions: dict[str, dict[str, exp.Expression]] = {}
        warnings = list(bundle.warnings)

        for job in bundle.jobs:
            job_id = job["job_id"]
            insert = self._parse_insert(job)
            query = self._write_query(insert)

            for upstream_job_id in job.get("depends_on_job_ids") or []:
                upstream_query = queries[upstream_job_id]
                for dataset_name in produced_datasets[upstream_job_id]:
                    replacements = self._inline_table(
                        query,
                        dataset_name,
                        upstream_query,
                        job_partitions[upstream_job_id],
                        warnings,
                    )
                    if replacements == 0:
                        warnings.append(
                            f"job {job_id} did not reference selected upstream "
                            f"dataset {dataset_name}"
                        )

            output_fields: set[str] = set()
            if job_id == target["job_id"]:
                output_fields = {target["field_name"]}

            static_partitions = self._static_partitions(insert)
            if job_id == target["job_id"]:
                query = ColumnSqlSlicer().slice(query, output_fields)
            else:
                # Keep the complete materialized schema at job boundaries.
                # A downstream SELECT may pass through sibling columns before
                # reaching the target expression; pruning them here creates a
                # query that parses but fails at runtime with missing columns.
                self._append_static_partitions(query, static_partitions)
            queries[job_id] = query
            job_partitions[job_id] = static_partitions
            produced_datasets[job_id] = {}
            for item in job.get("materialized_outputs") or []:
                produced_datasets[job_id].setdefault(
                    item["dataset_name"], set()
                ).add(item["field_name"])

        target_query = queries[target["job_id"]]
        body = target_query.sql(dialect=self.dialect, pretty=True)
        # A second parse is a structural validity check (undefined columns are a
        # runtime/catalog concern, but malformed SQL/CTEs are caught here).
        parse_one(body, read=self.dialect)

        header = self._header(bundle, target, warnings)
        return ReconstructedSql(sql=header + body.rstrip(";") + ";\n", warnings=warnings)

    def _parse_insert(self, job: dict) -> exp.Insert:
        raw_sql = (job.get("raw_sql") or "").strip()
        if not raw_sql:
            raise ValueError(f"raw_sql is missing for job {job.get('job_id')}")
        tree = parse_one(raw_sql, read=job.get("engine") or self.dialect)
        if not isinstance(tree, exp.Insert):
            raise ValueError(
                f"job {job.get('job_id')} is not an INSERT statement: "
                f"{type(tree).__name__}"
            )
        return tree

    @staticmethod
    def _write_query(insert: exp.Insert) -> exp.Query:
        query = insert.expression.copy()
        if not isinstance(query, exp.Query):
            raise ValueError("INSERT source is not a query")
        with_clause = insert.args.get("with_")
        if with_clause is not None:
            query.set("with_", with_clause.copy())
        return query

    @staticmethod
    def _static_partitions(insert: exp.Insert) -> dict[str, exp.Expression]:
        partition = insert.this.args.get("partition")
        result: dict[str, exp.Expression] = {}
        if not isinstance(partition, exp.Partition):
            return result
        for item in partition.expressions:
            if isinstance(item, exp.EQ) and isinstance(item.this, exp.Column):
                result[item.this.name] = item.expression.copy()
        return result

    @staticmethod
    def _union_leaves(query: exp.Query) -> Iterable[exp.Select]:
        if isinstance(query, exp.SetOperation):
            yield from ProductionSqlReconstructor._union_leaves(query.this)
            yield from ProductionSqlReconstructor._union_leaves(query.expression)
        elif isinstance(query, exp.Select):
            yield query
        else:
            raise ValueError(f"Unsupported INSERT query: {type(query).__name__}")

    def _project_outputs(
        self,
        query: exp.Query,
        field_names: set[str],
        static_partitions: dict[str, exp.Expression],
    ) -> exp.Query:
        if not field_names:
            return query
        leaves = list(self._union_leaves(query))
        for leaf in leaves:
            by_name = {
                projection.alias_or_name.lower(): projection
                for projection in leaf.expressions
                if projection.alias_or_name
            }
            selected: list[exp.Expression] = []
            missing: list[str] = []
            for name in sorted(field_names):
                projection = by_name.get(name.lower())
                if projection is not None:
                    selected.append(projection.copy())
                elif name in static_partitions:
                    selected.append(exp.alias_(
                        static_partitions[name].copy(), name, quoted=False
                    ))
                else:
                    missing.append(name)
            if missing:
                raise ValueError(
                    "Selected output column(s) not found in every UNION branch: "
                    + ", ".join(sorted(missing))
                )
            leaf.set("expressions", selected)
        return query

    def _append_static_partitions(
        self,
        query: exp.Query,
        static_partitions: dict[str, exp.Expression],
    ) -> None:
        for leaf in self._union_leaves(query):
            existing = {
                projection.alias_or_name.lower()
                for projection in leaf.expressions
                if projection.alias_or_name
            }
            additions = [
                exp.alias_(value.copy(), name, quoted=False)
                for name, value in sorted(static_partitions.items())
                if name.lower() not in existing
            ]
            if additions:
                leaf.set("expressions", list(leaf.expressions) + additions)

    @staticmethod
    def _inline_table(
        query: exp.Query,
        dataset_name: str,
        upstream_query: exp.Query,
        static_partitions: dict[str, exp.Expression],
        warnings: list[str],
    ) -> int:
        inline_query = upstream_query.copy()
        ProductionSqlReconstructor._hoist_ctes(query, inline_query)
        parts = dataset_name.split(".")
        table_name = parts[-1].lower()
        db_name = parts[-2].lower() if len(parts) > 1 else ""
        replaced = 0
        for table in list(query.find_all(exp.Table)):
            if table.name.lower() != table_name:
                continue
            if db_name and (table.db or "").lower() != db_name:
                continue
            ProductionSqlReconstructor._warn_partition_conflicts(
                table, dataset_name, static_partitions, warnings
            )
            alias_name = table.alias_or_name
            alias = table.args.get("alias")
            if alias is None:
                alias = exp.TableAlias(this=exp.to_identifier(alias_name))
            table.replace(exp.Subquery(
                this=inline_query.copy(),
                alias=alias.copy(),
            ))
            replaced += 1
        return replaced

    @staticmethod
    def _hoist_ctes(target: exp.Query, source: exp.Query) -> None:
        """Move source CTEs to the outer query for Hive compatibility."""
        source_with = source.args.get("with_")
        if source_with is None:
            return
        target_with = target.args.get("with_")
        existing = {
            cte.alias_or_name.lower()
            for cte in (target_with.expressions if target_with else [])
        }
        incoming = [cte.copy() for cte in source_with.expressions]
        conflicts = sorted({
            cte.alias_or_name for cte in incoming
            if cte.alias_or_name.lower() in existing
        })
        if conflicts:
            raise ValueError(
                "Cannot inline jobs with conflicting CTE names: "
                + ", ".join(conflicts)
            )
        if target_with is None:
            target.set("with_", exp.With(
                expressions=incoming,
                recursive=source_with.args.get("recursive"),
            ))
        else:
            target_with.set(
                "expressions", list(target_with.expressions) + incoming
            )
        source.set("with_", None)

    @staticmethod
    def _warn_partition_conflicts(
        table: exp.Table,
        dataset_name: str,
        static_partitions: dict[str, exp.Expression],
        warnings: list[str],
    ) -> None:
        select = table.find_ancestor(exp.Select)
        where = select.args.get("where") if select is not None else None
        if where is None:
            return
        for condition in where.find_all(exp.EQ):
            column: exp.Column | None = None
            value: exp.Expression | None = None
            if isinstance(condition.this, exp.Column):
                column, value = condition.this, condition.expression
            elif isinstance(condition.expression, exp.Column):
                column, value = condition.expression, condition.this
            if column is None or value is None:
                continue
            produced = static_partitions.get(column.name)
            if produced is None or produced == value:
                continue
            warning = (
                f"selected producer for {dataset_name} writes static partition "
                f"{column.name}={produced.sql()}, but downstream filters "
                f"{column.name}={value.sql()}; this branch returns no rows"
            )
            if warning not in warnings:
                warnings.append(warning)

    @staticmethod
    def _header(
        bundle: ProductionBundle,
        target: dict,
        warnings: list[str],
    ) -> str:
        lines = [
            "-- MetaWIKI · reconstructed column production SQL",
            f"-- target: {target['dataset_name']}.{target['field_name']}",
            f"-- target_definition_id: {target['definition_id']}",
            "-- inlined jobs: " + " -> ".join(
                item["job_id"] for item in bundle.jobs
            ),
        ]
        for source in bundle.external_sources:
            lines.append(
                "-- external boundary: "
                f"{source.get('source_dataset_name')}."
                f"{source.get('source_field_name')}"
            )
        for boundary in bundle.recovered_internal_boundaries:
            lines.append(
                "-- internal lineage gap recovered from raw SQL AST: "
                f"{boundary.get('source_dataset_name')}."
                f"{boundary.get('source_field_name')}"
            )
        for warning in warnings:
            lines.append(f"-- WARNING: {warning}")
        return "\n".join(lines) + "\n"
