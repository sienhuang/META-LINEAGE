from __future__ import annotations

from collections import deque
from dataclasses import asdict, dataclass, field
from typing import Dict, Optional

from .dependency_graph import DependencyGraphBuilder, ProvenanceReader
from .production_bundle import ProductionBundleBuilder


AMBIGUOUS_REASONS = {"ambiguous_producer", "ambiguous_internal_producer"}


class CachingProvenanceReader:
    """Request-scoped cache; path branches revisit most of the same graph."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = reader
        self._field_producers: dict[tuple[str, str], list[dict]] = {}
        self._producers_by_field: dict[str, list[dict]] = {}
        self._definitions: dict[str, Optional[dict]] = {}
        self._dependencies: dict[str, list[dict]] = {}

    def list_field_producers(self, dataset_name: str, field_name: str) -> list[dict]:
        key = (dataset_name, field_name)
        if key not in self._field_producers:
            self._field_producers[key] = self.reader.list_field_producers(
                dataset_name, field_name
            )
        return self._field_producers[key]

    def list_producers_for_field(self, field_id: str) -> list[dict]:
        if field_id not in self._producers_by_field:
            self._producers_by_field[field_id] = (
                self.reader.list_producers_for_field(field_id)
            )
        return self._producers_by_field[field_id]

    def get_definition(self, definition_id: str) -> Optional[dict]:
        if definition_id not in self._definitions:
            self._definitions[definition_id] = self.reader.get_definition(
                definition_id
            )
        return self._definitions[definition_id]

    def list_dependencies(self, definition_id: str) -> list[dict]:
        if definition_id not in self._dependencies:
            self._dependencies[definition_id] = self.reader.list_dependencies(
                definition_id
            )
        return self._dependencies[definition_id]


@dataclass
class ProductionPaths:
    target_ref: str
    target_producer_count: int
    path_count: int = 0
    truncated: bool = False
    max_paths: int = 100
    explored_states: int = 0
    complete_path_count: int = 0
    incomplete_path_count: int = 0
    paths: list[dict] = field(default_factory=list)

    def as_dict(self) -> dict:
        return asdict(self)


class ProductionPathEnumerator:
    """Enumerate every producer choice instead of stopping at ambiguity."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = (
            reader
            if isinstance(reader, CachingProvenanceReader)
            else CachingProvenanceReader(reader)
        )
        self.graph_builder = DependencyGraphBuilder(self.reader)
        self.bundle_builder = ProductionBundleBuilder(self.reader)

    def enumerate(
        self,
        ref: str,
        target_definition_id: Optional[str] = None,
        producer_overrides: Optional[Dict[str, str]] = None,
        max_depth: int = 30,
        max_paths: int = 100,
        include_definitions: bool = False,
    ) -> ProductionPaths:
        if max_paths < 1:
            raise ValueError("max_paths must be >= 1")
        producers = self.graph_builder.list_field_producers(ref)
        if not producers:
            raise ValueError(f"Field definition not found: {ref}")
        if target_definition_id:
            producers = [
                item for item in producers
                if item["definition_id"] == target_definition_id
            ]
            if not producers:
                raise ValueError(
                    f"Definition {target_definition_id} does not produce {ref}"
                )

        result = ProductionPaths(
            target_ref=ref,
            target_producer_count=len(producers),
            max_paths=max_paths,
        )
        initial = dict(producer_overrides or {})
        queue = deque(
            (item["definition_id"], dict(initial))
            for item in producers
        )
        seen: set[tuple[str, tuple[tuple[str, str], ...]]] = set()

        while queue and len(result.paths) < max_paths:
            target_id, overrides = queue.popleft()
            state_key = (target_id, tuple(sorted(overrides.items())))
            if state_key in seen:
                continue
            seen.add(state_key)
            result.explored_states += 1

            graph = self.graph_builder.build(
                target_id,
                producer_overrides=overrides,
                max_depth=max_depth,
            )
            ambiguous = sorted(
                (
                    item for item in graph.boundaries
                    if item.get("reason") in AMBIGUOUS_REASONS
                ),
                key=lambda item: (
                    item.get("source_field_id") or "",
                    item.get("edge_id") or "",
                ),
            )
            if ambiguous:
                boundary = ambiguous[0]
                field_id = boundary["source_field_id"]
                for candidate_id in sorted(
                    boundary.get("candidate_definition_ids") or []
                ):
                    selected = overrides.get(field_id)
                    if selected is not None and selected != candidate_id:
                        continue
                    branched = dict(overrides)
                    branched[field_id] = candidate_id
                    queue.append((target_id, branched))
                continue

            bundle = self.bundle_builder.build(
                target_id,
                producer_overrides=overrides,
                max_depth=max_depth,
            )
            result.paths.append(self._path_record(
                len(result.paths) + 1,
                target_id,
                overrides,
                graph.as_dict(),
                bundle.as_dict(),
                include_definitions=include_definitions,
            ))

        result.path_count = len(result.paths)
        result.complete_path_count = sum(
            1 for item in result.paths if item["complete"]
        )
        result.incomplete_path_count = result.path_count - result.complete_path_count
        result.truncated = bool(queue)
        return result

    def _path_record(
        self,
        path_id: int,
        target_definition_id: str,
        overrides: dict[str, str],
        graph: dict,
        bundle: dict,
        include_definitions: bool,
    ) -> dict:
        definitions = [
            {
                "definition_id": node["definition_id"],
                "dataset_name": node.get("dataset_name"),
                "field_name": node.get("field_name"),
                "job_id": node.get("job_id"),
                "expression_sql": node.get("expression_sql"),
                "depth": node.get("depth"),
            }
            for node in graph["nodes"].values()
            if node.get("node_type") == "definition"
        ]
        definitions.sort(key=lambda item: (
            item.get("depth") or 0,
            item.get("job_id") or "",
            item["definition_id"],
        ))
        choices = []
        for field_id, definition_id in sorted(overrides.items()):
            definition = self.reader.get_definition(definition_id)
            choices.append({
                "source_field_id": field_id,
                "selected_definition_id": definition_id,
                "dataset_name": definition.get("dataset_name") if definition else None,
                "field_name": definition.get("field_name") if definition else None,
                "job_id": definition.get("job_id") if definition else None,
                "expression_sql": definition.get("expression_sql") if definition else None,
            })
        record = {
            "path_id": path_id,
            "target_definition_id": target_definition_id,
            "complete": bundle["complete"],
            "producer_choices": choices,
            "job_ids": [item["job_id"] for item in bundle["jobs"]],
            "definition_count": len(definitions),
            "external_sources": bundle["external_sources"],
            "recovered_internal_boundaries": bundle.get(
                "recovered_internal_boundaries", []
            ),
            "unresolved_boundaries": bundle["unresolved_boundaries"],
            "warnings": bundle["warnings"],
        }
        if include_definitions:
            record["definitions"] = definitions
        return record
