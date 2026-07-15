from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Dict, List, Optional, Protocol

from psycopg2.extras import RealDictCursor

from .repository import PostgresJobModelRepository


class ProvenanceReader(Protocol):
    def list_field_producers(self, dataset_name: str, field_name: str) -> List[dict]: ...

    def list_producers_for_field(self, field_id: str) -> List[dict]: ...

    def get_definition(self, definition_id: str) -> Optional[dict]: ...

    def list_dependencies(self, definition_id: str) -> List[dict]: ...


class PostgresProvenanceReader:
    """Read producer-scoped V2 provenance records from PostgreSQL."""

    _DEFINITION_SELECT = """
        select
          fd.definition_id,
          fd.field_id,
          f.field_name,
          d.dataset_id,
          d.dataset_name,
          d.dataset_type,
          fd.expression_id,
          fd.expression_sql,
          fd.expression_type,
          fd.ordinal_no,
          dp.production_id,
          dp.job_id,
          dp.stage_id,
          dp.write_mode,
          dp.is_materialized,
          dp.is_current,
          dp.source_instance_id,
          j.job_name,
          j.engine,
          j.raw_sql,
          s.stage_name,
          s.stage_type,
          s.ordinal_no as stage_ordinal_no
        from {schema}.field_definition fd
        join {schema}.field f on f.field_id = fd.field_id
        join {schema}.dataset d on d.dataset_id = f.dataset_id
        join {schema}.dataset_production dp on dp.production_id = fd.production_id
        join {schema}.job j on j.job_id = dp.job_id
        join {schema}.stage s on s.stage_id = dp.stage_id
    """

    def __init__(self, repo: PostgresJobModelRepository) -> None:
        self.repo = repo
        self.schema = repo.schema

    def _fetchall(self, sql: str, params: tuple = ()) -> List[dict]:
        with self.repo.connect() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sql, params)
                return [dict(item) for item in cur.fetchall()]

    def _definition_query(self, where_sql: str, params: tuple) -> List[dict]:
        sql = self._DEFINITION_SELECT.format(schema=self.schema)
        return self._fetchall(
            sql + f" where {where_sql} "
            "order by dp.is_current desc, dp.job_id, s.ordinal_no, fd.ordinal_no",
            params,
        )

    def list_field_producers(self, dataset_name: str, field_name: str) -> List[dict]:
        return self._definition_query(
            "d.dataset_name = %s and f.field_name = %s",
            (dataset_name, field_name),
        )

    def list_producers_for_field(self, field_id: str) -> List[dict]:
        return self._definition_query("fd.field_id = %s", (field_id,))

    def get_definition(self, definition_id: str) -> Optional[dict]:
        rows = self._definition_query("fd.definition_id = %s", (definition_id,))
        return rows[0] if rows else None

    def list_dependencies(self, definition_id: str) -> List[dict]:
        return self._fetchall(
            f"""
            select
              dep.edge_id,
              dep.target_definition_id,
              dep.source_field_id,
              dep.dependency_type,
              dep.lineage_type,
              dep.source_ordinal,
              sf.field_name as source_field_name,
              sd.dataset_id as source_dataset_id,
              sd.dataset_name as source_dataset_name,
              sd.dataset_type as source_dataset_type
            from {self.schema}.field_dependency dep
            join {self.schema}.field sf on sf.field_id = dep.source_field_id
            join {self.schema}.dataset sd on sd.dataset_id = sf.dataset_id
            where dep.target_definition_id = %s
            order by dep.source_ordinal, dep.edge_id
            """,
            (definition_id,),
        )


@dataclass
class DependencyGraph:
    target_definition_id: str
    nodes: Dict[str, dict] = field(default_factory=dict)
    edges: List[dict] = field(default_factory=list)
    boundaries: List[dict] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)

    def as_dict(self) -> dict:
        return asdict(self)


class DependencyGraphBuilder:
    """Expand a selected field definition into a producer-aware dependency DAG."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = reader

    def list_field_producers(self, ref: str) -> List[dict]:
        dataset_name, field_name = self._split_ref(ref)
        return self.reader.list_field_producers(dataset_name, field_name)

    def build(
        self,
        target_definition_id: str,
        producer_overrides: Optional[Dict[str, str]] = None,
        max_depth: int = 30,
    ) -> DependencyGraph:
        target = self.reader.get_definition(target_definition_id)
        if target is None:
            raise ValueError(f"Definition not found: {target_definition_id}")
        if max_depth < 1:
            raise ValueError("max_depth must be >= 1")

        graph = DependencyGraph(target_definition_id=target_definition_id)
        overrides = producer_overrides or {}
        expanded: set[str] = set()
        self._expand(target, graph, overrides, expanded, (), 0, max_depth)
        return graph

    def _expand(
        self,
        definition: dict,
        graph: DependencyGraph,
        overrides: Dict[str, str],
        expanded: set[str],
        path: tuple[str, ...],
        depth: int,
        max_depth: int,
    ) -> None:
        definition_id = definition["definition_id"]
        graph.nodes.setdefault(definition_id, self._definition_node(definition, depth))
        if definition_id in expanded:
            return
        expanded.add(definition_id)

        dependencies = self.reader.list_dependencies(definition_id)
        if not dependencies and definition.get("expression_type") != "literal":
            graph.boundaries.append({
                "definition_id": definition_id,
                "source_field_id": definition.get("field_id"),
                "source_dataset_name": definition.get("dataset_name"),
                "source_field_name": definition.get("field_name"),
                "reason": "lineage_gap",
                "candidate_definition_ids": [],
            })
            return

        for dependency in dependencies:
            source_field_id = dependency["source_field_id"]
            candidates = self.reader.list_producers_for_field(source_field_id)
            selected, reason = self._select_producer(
                definition, dependency, candidates, overrides.get(source_field_id)
            )

            if selected is None:
                field_node_id = f"field:{source_field_id}"
                graph.nodes.setdefault(
                    field_node_id, self._field_node(dependency, depth + 1)
                )
                graph.edges.append(
                    self._edge(dependency, definition_id, field_node_id, depth)
                )
                graph.boundaries.append({
                    "edge_id": dependency["edge_id"],
                    "source_field_id": source_field_id,
                    "source_dataset_name": dependency["source_dataset_name"],
                    "source_field_name": dependency["source_field_name"],
                    "reason": reason,
                    "candidate_definition_ids": [
                        item["definition_id"] for item in candidates
                    ],
                })
                continue

            selected_id = selected["definition_id"]
            graph.nodes.setdefault(
                selected_id, self._definition_node(selected, depth + 1)
            )
            graph.edges.append(
                self._edge(dependency, definition_id, selected_id, depth)
            )
            if selected_id in path or selected_id == definition_id:
                graph.warnings.append(
                    f"cycle detected: {definition_id} -> {selected_id}"
                )
                continue
            if depth + 1 >= max_depth:
                graph.boundaries.append({
                    "edge_id": dependency["edge_id"],
                    "source_field_id": source_field_id,
                    "reason": "max_depth_reached",
                    "candidate_definition_ids": [selected_id],
                })
                continue
            self._expand(
                selected,
                graph,
                overrides,
                expanded,
                path + (definition_id,),
                depth + 1,
                max_depth,
            )

    @staticmethod
    def _select_producer(
        target_definition: dict,
        dependency: dict,
        candidates: List[dict],
        override: Optional[str],
    ) -> tuple[Optional[dict], str]:
        if override:
            selected = next(
                (item for item in candidates if item["definition_id"] == override),
                None,
            )
            return (selected, "override_not_found" if selected is None else "selected")

        # CTE/subquery/temp datasets are job-scoped and should resolve to the
        # definition produced inside the same job.
        if dependency["source_dataset_type"] != "table":
            same_job = [
                item for item in candidates
                if item["job_id"] == target_definition["job_id"]
            ]
            if len(same_job) == 1:
                return same_job[0], "selected"
            if len(same_job) > 1:
                return None, "ambiguous_internal_producer"
            return None, "producer_not_found"

        current = [item for item in candidates if item.get("is_current", True)]
        if len(current) == 1:
            return current[0], "selected"
        if not current:
            return None, "producer_not_found"
        return None, "ambiguous_producer"

    @staticmethod
    def _definition_node(item: dict, depth: int) -> dict:
        keys = (
            "definition_id", "field_id", "field_name", "dataset_id",
            "dataset_name", "dataset_type", "expression_sql", "expression_type",
            "production_id", "job_id", "job_name", "stage_id", "stage_name",
            "stage_type", "write_mode", "is_materialized", "is_current",
        )
        node = {key: item.get(key) for key in keys}
        node.update({"node_type": "definition", "depth": depth})
        return node

    @staticmethod
    def _field_node(item: dict, depth: int) -> dict:
        return {
            "node_type": "field_boundary",
            "field_id": item["source_field_id"],
            "field_name": item["source_field_name"],
            "dataset_id": item["source_dataset_id"],
            "dataset_name": item["source_dataset_name"],
            "dataset_type": item["source_dataset_type"],
            "depth": depth,
        }

    @staticmethod
    def _edge(item: dict, target_node_id: str, source_node_id: str, depth: int) -> dict:
        return {
            "edge_id": item["edge_id"],
            "target_node_id": target_node_id,
            "source_node_id": source_node_id,
            "source_field_id": item["source_field_id"],
            "dependency_type": item["dependency_type"],
            "lineage_type": item["lineage_type"],
            "source_ordinal": item["source_ordinal"],
            "depth": depth,
        }

    @staticmethod
    def _split_ref(ref: str) -> tuple[str, str]:
        parts = ref.rsplit(".", 1)
        if len(parts) != 2:
            raise ValueError("ref 形如 'mt_ads.ads_x.active_cnt'(表名.列名)")
        return parts[0], parts[1]
