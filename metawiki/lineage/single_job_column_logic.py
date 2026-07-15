from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from sqlglot import exp, parse_one

from .column_sql_slicer import ColumnSqlSlicer
from .dependency_graph import ProvenanceReader


SAFE_PATH_RE = re.compile(r"[^A-Za-z0-9_.-]+")


@dataclass
class SingleJobColumnResult:
    output_dir: str
    logic_file: str
    sql_file: str
    logic: dict
    sql: str

    def summary(self) -> dict:
        return {
            "target": self.logic["target"],
            "complete": self.logic["complete"],
            "output_dir": self.output_dir,
            "logic_file": self.logic_file,
            "sql_file": self.sql_file,
        }


class SingleJobColumnLogicBuilder:
    """Recover one target column inside one explicitly selected ETL job."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = reader

    def build(
        self,
        job_ref: str,
        target_ref: str,
        output_dir: str | Path | None = None,
    ) -> SingleJobColumnResult:
        dataset_name, field_name = self._split_ref(target_ref)
        target = self._resolve_target(job_ref, dataset_name, field_name)
        print("11111")
        insert = self._parse_insert(target)
        written_dataset = self._table_name(insert.this)
        if written_dataset.lower() != dataset_name.lower():
            raise ValueError(
                f"Job {target['job_id']} writes {written_dataset}, not {dataset_name}"
            )

        query = insert.expression.copy()
        if not isinstance(query, exp.Query):
            raise ValueError(f"Job {target['job_id']} INSERT source is not a query")
        if insert.args.get("with_") is not None:
            query.set("with_", insert.args["with_"].copy())
        sliced = ColumnSqlSlicer().slice(query, {field_name})
        sql_body = sliced.sql(dialect=target.get("engine") or "hive", pretty=True)
        parse_one(sql_body, read=target.get("engine") or "hive")

        lineage = self._single_job_lineage(target)
        logic = self._logic_document(
            target_ref, target, sliced, lineage
        )
        header = "\n".join([
            "-- MetaWIKI · single-job column production SQL",
            f"-- job_id: {target['job_id']}",
            f"-- target: {target_ref}",
            "-- scope: current job only; physical tables are boundaries",
        ])
        sql = header + "\n" + sql_body.rstrip(";") + ";\n"

        destination = self._output_dir(output_dir, job_ref, field_name)
        destination.mkdir(parents=True, exist_ok=True)
        logic_path = destination / "column_logic.json"
        sql_path = destination / "production.sql"
        logic_path.write_text(
            json.dumps(logic, ensure_ascii=False, indent=2, default=str) + "\n",
            encoding="utf-8",
        )
        sql_path.write_text(sql, encoding="utf-8")
        return SingleJobColumnResult(
            output_dir=str(destination),
            logic_file=str(logic_path),
            sql_file=str(sql_path),
            logic=logic,
            sql=sql,
        )

    def _resolve_target(
        self, job_ref: str, dataset_name: str, field_name: str
    ) -> dict:
        producers = self.reader.list_field_producers(dataset_name, field_name)
        matches = [item for item in producers if self._job_matches(item, job_ref)]
        materialized = [item for item in matches if item.get("is_materialized")]
        if materialized:
            matches = materialized
        if not matches:
            raise ValueError(
                f"Job {job_ref} does not produce {dataset_name}.{field_name}"
            )
        if len(matches) != 1:
            ids = ", ".join(sorted(item["definition_id"] for item in matches))
            raise ValueError(
                f"Job {job_ref} has multiple definitions for "
                f"{dataset_name}.{field_name}: {ids}"
            )
        return matches[0]

    @staticmethod
    def _job_matches(item: dict, job_ref: str) -> bool:
        requested = job_ref.strip()
        if requested in {item.get("job_id"), item.get("job_name")}:
            return True
        numeric = requested.removeprefix("job.").split("_", 1)[0]
        job_id = item.get("job_id") or ""
        job_name = item.get("job_name") or ""
        return (
            job_id.startswith(f"job.{numeric}_")
            or job_name == numeric
            or job_name.startswith(f"{numeric}__")
        )

    @staticmethod
    def _parse_insert(target: dict) -> exp.Insert:
        raw_sql = (target.get("raw_sql") or "").strip()
        if not raw_sql:
            raise ValueError(f"Job {target['job_id']} has no raw_sql")
        tree = parse_one(raw_sql, read=target.get("engine") or "hive")
        if not isinstance(tree, exp.Insert):
            raise ValueError(
                f"Job {target['job_id']} is not an INSERT: {type(tree).__name__}"
            )
        return tree

    def _single_job_lineage(self, target: dict) -> dict:
        nodes: dict[str, dict] = {}
        boundaries: list[dict] = []
        recovered: list[dict] = []
        warnings: list[str] = []
        visited: set[str] = set()

        def walk(definition: dict, depth: int, path: tuple[str, ...]) -> None:
            definition_id = definition["definition_id"]
            if definition_id in path:
                warnings.append(f"cycle: {' -> '.join(path + (definition_id,))}")
                return
            nodes.setdefault(definition_id, {
                "definition_id": definition_id,
                "dataset_name": definition.get("dataset_name"),
                "field_name": definition.get("field_name"),
                "expression_sql": definition.get("expression_sql"),
                "expression_type": definition.get("expression_type"),
                "depth": depth,
            })
            if definition_id in visited:
                return
            visited.add(definition_id)
            dependencies = self.reader.list_dependencies(definition_id)
            if not dependencies and definition.get("expression_type") != "literal":
                if definition.get("dataset_type") == "table":
                    boundaries.append({
                        "dataset": definition.get("dataset_name"),
                        "field": definition.get("field_name"),
                        "dependency_type": "value",
                    })
                else:
                    recovered.append({
                        "dataset": definition.get("dataset_name"),
                        "field": definition.get("field_name"),
                        "reason": "internal_lineage_gap_recovered_from_raw_sql",
                    })
                return
            for dependency in dependencies:
                if dependency["source_dataset_type"] == "table":
                    boundaries.append({
                        "dataset": dependency["source_dataset_name"],
                        "field": dependency["source_field_name"],
                        "field_id": dependency["source_field_id"],
                        "dependency_type": dependency["dependency_type"],
                    })
                    continue
                candidates = [
                    item for item in self.reader.list_producers_for_field(
                        dependency["source_field_id"]
                    )
                    if item.get("job_id") == target.get("job_id")
                ]
                if len(candidates) == 1:
                    walk(candidates[0], depth + 1, path + (definition_id,))
                else:
                    recovered.append({
                        "dataset": dependency["source_dataset_name"],
                        "field": dependency["source_field_name"],
                        "reason": "internal_definition_not_unique_recovered_from_raw_sql",
                        "candidate_count": len(candidates),
                    })

        walk(target, 0, ())
        return {
            "nodes": list(nodes.values()),
            "boundaries": self._deduplicate(boundaries),
            "recovered": self._deduplicate(recovered),
            "warnings": list(dict.fromkeys(warnings)),
        }

    def _logic_document(
        self,
        target_ref: str,
        target: dict,
        query: exp.Query,
        lineage: dict,
    ) -> dict:
        boundaries = lineage["boundaries"]
        value_sources = [
            item for item in boundaries
            if item.get("dependency_type") == "value"
            and item.get("field") != "*"
        ]
        rowset_sources = [
            item for item in boundaries
            if item.get("dependency_type") == "rowset"
            or item.get("field") == "*"
        ]
        transformations = []
        for node in sorted(
            lineage["nodes"], key=lambda item: item["depth"], reverse=True
        ):
            expression_sql = node.get("expression_sql")
            if not expression_sql or expression_sql.startswith("UNION_BRANCH_COLUMN"):
                continue
            if expression_sql not in transformations:
                transformations.append(expression_sql)
        groups = self._unique_sql(
            expression
            for group in query.find_all(exp.Group)
            for expression in group.expressions
        )
        joins = [
            {
                "join_type": self._join_type(join),
                "relation": join.this.sql(dialect=target.get("engine") or "hive"),
                "condition": join.args["on"].sql(
                    dialect=target.get("engine") or "hive"
                ) if join.args.get("on") is not None else None,
            }
            for join in query.find_all(exp.Join)
        ]
        filters = self._unique_sql(
            where.this for where in query.find_all(exp.Where)
        )
        unresolved: list[dict] = []
        return {
            "schema_version": "1.0",
            "scope": "single_job",
            "target": {
                "requested_job_id": target.get("job_name", "").split("__", 1)[0],
                "job_id": target["job_id"],
                "job_name": target.get("job_name"),
                "dataset": target["dataset_name"],
                "field": target["field_name"],
                "definition_id": target["definition_id"],
                "expression_sql": target.get("expression_sql"),
                "ref": target_ref,
            },
            "value_sources": value_sources,
            "context_sources": [
                {"usage": "join", **item} for item in joins
            ] + [
                {"usage": "filter", "expression": item} for item in filters
            ],
            "rowset_sources": rowset_sources,
            "transformations": transformations,
            "branches": self._branches(query, target["field_name"]),
            "grain": groups,
            "relational_context": {
                "joins": joins,
                "filters": filters,
                "group_by": groups,
            },
            "external_boundaries": boundaries,
            "recovered_boundaries": lineage["recovered"],
            "unresolved_boundaries": unresolved,
            "warnings": lineage["warnings"],
            "complete": not unresolved,
        }

    def _branches(self, query: exp.Query, target_field: str) -> list[dict]:
        ctes = {
            cte.alias_or_name.lower(): cte
            for with_clause in query.find_all(exp.With)
            for cte in with_clause.expressions
        }
        result: list[dict] = []
        for union in query.find_all(exp.Union):
            if isinstance(union.parent, exp.SetOperation):
                continue
            leaves = list(self._union_leaves(union))
            projections = [
                next((
                    item for item in leaf.expressions
                    if item.alias_or_name.lower() == target_field.lower()
                ), None)
                for leaf in leaves
            ]
            if not projections or any(item is None for item in projections):
                continue
            for index, (leaf, projection) in enumerate(
                zip(leaves, projections), start=1
            ):
                expression = projection.this if isinstance(projection, exp.Alias) else projection
                if not list(expression.find_all(exp.Column)):
                    dependency_type = "constant_branch"
                elif isinstance(expression, exp.Column):
                    dependency_type = "passthrough"
                else:
                    dependency_type = "value"
                result.append({
                    "branch": index,
                    "expression": projection.sql(),
                    "dependency_type": dependency_type,
                    "source_datasets": sorted(
                        self._physical_sources(leaf, ctes, set())
                    ),
                })
            break
        return result

    @staticmethod
    def _join_type(join: exp.Join) -> str:
        side = str(join.args.get("side") or "").upper()
        kind = str(join.args.get("kind") or "").upper()
        parts = [item for item in (side, kind, "JOIN") if item]
        return " ".join(parts)

    def _physical_sources(
        self,
        expression: exp.Expression,
        ctes: dict[str, exp.CTE],
        visited: set[str],
    ) -> set[str]:
        result: set[str] = set()
        for table in expression.find_all(exp.Table):
            name = table.name.lower()
            if name in ctes:
                if name not in visited:
                    result.update(self._physical_sources(
                        ctes[name].this, ctes, visited | {name}
                    ))
            else:
                result.add(self._table_name(table))
        return result

    @staticmethod
    def _union_leaves(query: exp.Query):
        if isinstance(query, exp.SetOperation):
            yield from SingleJobColumnLogicBuilder._union_leaves(query.this)
            yield from SingleJobColumnLogicBuilder._union_leaves(query.expression)
        elif isinstance(query, exp.Select):
            yield query

    @staticmethod
    def _unique_sql(expressions) -> list[str]:
        result: list[str] = []
        for expression in expressions:
            sql = expression.sql(dialect="hive")
            if sql not in result:
                result.append(sql)
        return result

    @staticmethod
    def _deduplicate(items: list[dict]) -> list[dict]:
        result: list[dict] = []
        seen: set[str] = set()
        for item in items:
            key = json.dumps(item, sort_keys=True, default=str)
            if key not in seen:
                seen.add(key)
                result.append(item)
        return result

    @staticmethod
    def _split_ref(ref: str) -> tuple[str, str]:
        parts = ref.rsplit(".", 1)
        if len(parts) != 2:
            raise ValueError("target must be schema.table.column")
        return parts[0], parts[1]

    @staticmethod
    def _table_name(table: exp.Table) -> str:
        return ".".join(filter(None, (table.catalog, table.db, table.name)))

    @staticmethod
    def _output_dir(
        output_dir: str | Path | None, job_ref: str, field_name: str
    ) -> Path:
        if output_dir is not None:
            return Path(output_dir).expanduser().resolve()
        job_name = SAFE_PATH_RE.sub("_", job_ref)
        field = SAFE_PATH_RE.sub("_", field_name)
        return Path("generated/column_logic") / job_name / field
