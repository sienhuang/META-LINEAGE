from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Dict, List, Optional

from .dependency_graph import DependencyGraphBuilder, ProvenanceReader


@dataclass
class ProductionBundle:
    target_definition_id: str
    complete: bool
    jobs: List[dict] = field(default_factory=list)
    job_dependencies: List[dict] = field(default_factory=list)
    external_sources: List[dict] = field(default_factory=list)
    recovered_internal_boundaries: List[dict] = field(default_factory=list)
    unresolved_boundaries: List[dict] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)

    def as_dict(self) -> dict:
        return asdict(self)


class ProductionBundleBuilder:
    """Turn a producer-aware field DAG into an ordered bundle of raw job SQL."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = reader
        self.graph_builder = DependencyGraphBuilder(reader)

    def build(
        self,
        target_definition_id: str,
        producer_overrides: Optional[Dict[str, str]] = None,
        max_depth: int = 30,
    ) -> ProductionBundle:
        graph = self.graph_builder.build(
            target_definition_id,
            producer_overrides=producer_overrides,
            max_depth=max_depth,
        )

        definition_nodes = {
            node_id: node
            for node_id, node in graph.nodes.items()
            if node.get("node_type") == "definition"
        }
        job_ids = {
            node["job_id"] for node in definition_nodes.values()
            if node.get("job_id")
        }
        upstream_by_job: dict[str, set[str]] = {
            job_id: set() for job_id in job_ids
        }
        downstream_by_job: dict[str, set[str]] = {
            job_id: set() for job_id in job_ids
        }
        job_dependencies: list[dict] = []
        emitted_job_edges: set[tuple[str, str]] = set()

        for edge in graph.edges:
            target = definition_nodes.get(edge["target_node_id"])
            source = definition_nodes.get(edge["source_node_id"])
            if not target or not source:
                continue
            downstream_job = target["job_id"]
            upstream_job = source["job_id"]
            if not upstream_job or not downstream_job or upstream_job == downstream_job:
                continue
            job_edge = (upstream_job, downstream_job)
            upstream_by_job[downstream_job].add(upstream_job)
            downstream_by_job[upstream_job].add(downstream_job)
            if job_edge in emitted_job_edges:
                continue
            emitted_job_edges.add(job_edge)
            job_dependencies.append({
                "upstream_job_id": upstream_job,
                "downstream_job_id": downstream_job,
                "via_source_field_id": edge["source_field_id"],
                "dependency_type": edge["dependency_type"],
            })

        ordered_job_ids, topo_warnings = self._topological_order(
            job_ids, upstream_by_job, downstream_by_job
        )
        jobs = [
            self._job_record(
                job_id,
                order,
                definition_nodes,
                upstream_by_job[job_id],
            )
            for order, job_id in enumerate(ordered_job_ids, start=1)
        ]

        external_sources = self._deduplicate_boundaries([
            item for item in graph.boundaries
            if item["reason"] == "producer_not_found"
        ])
        recovered_internal = self._deduplicate_boundaries([
            item for item in graph.boundaries
            if self._is_recoverable_internal_gap(item)
        ])
        unresolved = self._deduplicate_boundaries([
            item for item in graph.boundaries
            if item["reason"] != "producer_not_found"
            and not self._is_recoverable_internal_gap(item)
        ])
        warnings = list(graph.warnings) + topo_warnings
        return ProductionBundle(
            target_definition_id=target_definition_id,
            complete=not unresolved and not warnings,
            jobs=jobs,
            job_dependencies=sorted(
                job_dependencies,
                key=lambda item: (
                    ordered_job_ids.index(item["upstream_job_id"]),
                    ordered_job_ids.index(item["downstream_job_id"]),
                ),
            ),
            external_sources=external_sources,
            recovered_internal_boundaries=recovered_internal,
            unresolved_boundaries=unresolved,
            warnings=warnings,
        )

    def _job_record(
        self,
        job_id: str,
        order: int,
        definition_nodes: dict[str, dict],
        upstream_job_ids: set[str],
    ) -> dict:
        selected = [
            node for node in definition_nodes.values()
            if node["job_id"] == job_id
        ]
        selected.sort(key=lambda item: (
            item.get("stage_id") or "",
            item.get("dataset_name") or "",
            item.get("field_name") or "",
        ))
        # Fetch one full record to retrieve raw_sql/engine. Graph nodes remain
        # compact so the same SQL is not duplicated on every definition node.
        full = self.reader.get_definition(selected[0]["definition_id"])
        if full is None:
            raise ValueError(
                f"Definition disappeared while building bundle: {selected[0]['definition_id']}"
            )
        materialized_outputs = [
            {
                "dataset_name": item["dataset_name"],
                "field_name": item["field_name"],
                "definition_id": item["definition_id"],
                "expression_sql": item.get("expression_sql"),
            }
            for item in selected
            if item.get("is_materialized")
        ]
        return {
            "order": order,
            "job_id": job_id,
            "job_name": full.get("job_name"),
            "engine": full.get("engine"),
            "write_mode": full.get("write_mode"),
            "depends_on_job_ids": sorted(upstream_job_ids),
            "materialized_outputs": materialized_outputs,
            "selected_definitions": [
                {
                    "definition_id": item["definition_id"],
                    "dataset_name": item["dataset_name"],
                    "field_name": item["field_name"],
                    "stage_id": item.get("stage_id"),
                    "stage_name": item.get("stage_name"),
                    "expression_sql": item.get("expression_sql"),
                }
                for item in selected
            ],
            "raw_sql": full.get("raw_sql"),
        }

    @staticmethod
    def _topological_order(
        job_ids: set[str],
        upstream_by_job: dict[str, set[str]],
        downstream_by_job: dict[str, set[str]],
    ) -> tuple[list[str], list[str]]:
        indegree = {
            job_id: len(upstream_by_job[job_id]) for job_id in job_ids
        }
        ready = sorted(job_id for job_id, degree in indegree.items() if degree == 0)
        ordered: list[str] = []
        while ready:
            job_id = ready.pop(0)
            ordered.append(job_id)
            for downstream in sorted(downstream_by_job[job_id]):
                indegree[downstream] -= 1
                if indegree[downstream] == 0:
                    ready.append(downstream)
                    ready.sort()

        remaining = sorted(job_ids - set(ordered))
        if not remaining:
            return ordered, []
        ordered.extend(remaining)
        return ordered, [
            "job dependency cycle detected: " + ", ".join(remaining)
        ]

    @staticmethod
    def _deduplicate_boundaries(items: List[dict]) -> List[dict]:
        result: list[dict] = []
        seen: set[tuple] = set()
        for item in items:
            key = (
                item.get("definition_id"),
                item.get("source_field_id"),
                item.get("reason"),
                tuple(item.get("candidate_definition_ids") or []),
            )
            if key in seen:
                continue
            seen.add(key)
            result.append(item)
        return result

    @staticmethod
    def _is_recoverable_internal_gap(item: dict) -> bool:
        return (
            item.get("reason") == "lineage_gap"
            and (item.get("source_field_id") or "").startswith("field.ds.")
        )


def render_production_sql(bundle: ProductionBundle | dict) -> str:
    """Render an ordered, human-readable SQL script bundle.

    This deliberately emits the original production SQL for every selected
    job instead of trying to inline independent scheduled tasks into a single
    synthetic query.
    """
    value = bundle.as_dict() if isinstance(bundle, ProductionBundle) else bundle
    jobs = value.get("jobs") or []
    external_sources = value.get("external_sources") or []
    unresolved = value.get("unresolved_boundaries") or []
    lines = [
        "-- MetaWIKI · ordered production SQL bundle",
        f"-- target_definition_id: {value.get('target_definition_id')}",
        f"-- known production jobs: {len(jobs)}",
    ]
    if unresolved:
        lines.append("-- WARNING: unresolved lineage boundaries remain:")
        for item in unresolved:
            ref = ".".join(filter(None, (
                item.get("source_dataset_name"), item.get("source_field_name")
            )))
            lines.append(f"--   {ref or item.get('source_field_id')} [{item.get('reason')}]")
    if external_sources:
        lines.append("-- External inputs with no producer SQL in current metadata:")
        for item in external_sources:
            dataset = item.get("source_dataset_name") or "?"
            field_name = item.get("source_field_name") or "?"
            dependency = "rowset" if field_name == "*" else "column"
            lines.append(f"--   {dataset}.{field_name} [{dependency}]")

    for job in jobs:
        outputs = job.get("materialized_outputs") or []
        output_refs = ", ".join(
            f"{item.get('dataset_name')}.{item.get('field_name')}"
            for item in outputs
        ) or "(intermediate definitions only)"
        lines.extend([
            "",
            "-- " + "=" * 76,
            f"-- STEP {job.get('order')} · job={job.get('job_id')} · engine={job.get('engine')}",
            f"-- produces selected field(s): {output_refs}",
            "-- " + "=" * 76,
        ])
        raw_sql = (job.get("raw_sql") or "").strip()
        if not raw_sql:
            lines.append("-- ERROR: raw_sql is missing for this job")
            continue
        lines.append(raw_sql.rstrip(";") + ";")
    return "\n".join(lines) + "\n"
