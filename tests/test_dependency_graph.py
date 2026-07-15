from __future__ import annotations

import unittest
from tempfile import TemporaryDirectory
from pathlib import Path
from sqlglot import parse_one

from metawiki.lineage.dependency_graph import DependencyGraphBuilder
from metawiki.lineage.production_bundle import (
    ProductionBundleBuilder,
    render_production_sql,
)
from metawiki.lineage.sql_reconstructor import ProductionSqlReconstructor
from metawiki.lineage.all_paths import ProductionPathEnumerator
from metawiki.lineage.all_sql import AllProductionSqlGenerator
from metawiki.lineage.column_sql_slicer import ColumnSqlSlicer
from metawiki.lineage.single_job_column_logic import SingleJobColumnLogicBuilder
from metawiki.lineage.repository import build_provenance_records
from metawiki.lineage.sql_ast_builder import SqlAstJobModelBuilder


class InMemoryProvenanceReader:
    def __init__(self, models) -> None:
        self.definitions: dict[str, dict] = {}
        self.dependencies: dict[str, list[dict]] = {}

        for model in models:
            records = build_provenance_records(model)
            fields = {item.field_id: item for item in model.fields}
            datasets = {item.dataset_id: item for item in model.datasets}
            stages = {item.stage_id: item for item in model.stages}
            productions = {
                item["production_id"]: item for item in records["productions"]
            }

            for item in records["definitions"]:
                field = fields[item["field_id"]]
                dataset = datasets[field.dataset_id]
                production = productions[item["production_id"]]
                stage = stages[production["stage_id"]]
                enriched = dict(item)
                enriched.update({
                    "field_name": field.field_name,
                    "dataset_id": dataset.dataset_id,
                    "dataset_name": dataset.dataset_name,
                    "dataset_type": dataset.dataset_type.value,
                    "job_id": model.job.job_id,
                    "job_name": model.job.job_name,
                    "engine": model.job.engine,
                    "raw_sql": model.job.raw_sql,
                    "stage_id": stage.stage_id,
                    "stage_name": stage.stage_name,
                    "stage_type": stage.stage_type.value,
                    "write_mode": model.job.write_mode.value,
                    "is_materialized": production["is_materialized"],
                    "is_current": production["is_current"],
                })
                self.definitions[item["definition_id"]] = enriched

            for item in records["dependencies"]:
                source = fields[item["source_field_id"]]
                dataset = datasets[source.dataset_id]
                enriched = dict(item)
                enriched.update({
                    "source_field_name": source.field_name,
                    "source_dataset_id": dataset.dataset_id,
                    "source_dataset_name": dataset.dataset_name,
                    "source_dataset_type": dataset.dataset_type.value,
                })
                self.dependencies.setdefault(
                    item["target_definition_id"], []
                ).append(enriched)

    def list_field_producers(self, dataset_name: str, field_name: str):
        return [
            item for item in self.definitions.values()
            if item["dataset_name"] == dataset_name
            and item["field_name"] == field_name
        ]

    def list_producers_for_field(self, field_id: str):
        return [
            item for item in self.definitions.values()
            if item["field_id"] == field_id
        ]

    def get_definition(self, definition_id: str):
        return self.definitions.get(definition_id)

    def list_dependencies(self, definition_id: str):
        return sorted(
            self.dependencies.get(definition_id, []),
            key=lambda item: item["source_ordinal"],
        )


class LineageGraphFixture:
    def setUp(self) -> None:
        builder = SqlAstJobModelBuilder(dialect="hive")
        self.upstream_a = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.mid "
            "SELECT SUM(amount) AS revenue FROM raw.orders_a",
            job_name="upstream_a",
        )
        self.upstream_b = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.mid "
            "SELECT SUM(amount) AS revenue FROM raw.orders_b",
            job_name="upstream_b",
        )
        self.downstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.final "
            "SELECT m.revenue AS revenue FROM mart.mid m",
            job_name="downstream",
        )

    @staticmethod
    def _definition(builder: DependencyGraphBuilder, ref: str) -> dict:
        producers = builder.list_field_producers(ref)
        if len(producers) != 1:
            raise AssertionError(f"expected one producer for {ref}: {producers}")
        return producers[0]


class DependencyGraphTests(LineageGraphFixture, unittest.TestCase):
    def test_unique_physical_producer_expands_across_job_boundary(self) -> None:
        graph_builder = DependencyGraphBuilder(
            InMemoryProvenanceReader([self.upstream_a, self.downstream])
        )
        target = self._definition(graph_builder, "mart.final.revenue")
        graph = graph_builder.build(target["definition_id"])

        jobs = {
            node.get("job_name") for node in graph.nodes.values()
            if node["node_type"] == "definition"
        }
        self.assertIn("downstream", jobs)
        self.assertIn("upstream_a", jobs)
        self.assertTrue(any(
            item["source_dataset_name"] == "raw.orders_a"
            and item["reason"] == "producer_not_found"
            for item in graph.boundaries
        ))

    def test_ambiguous_producer_stops_at_explicit_boundary(self) -> None:
        graph_builder = DependencyGraphBuilder(InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ]))
        target = self._definition(graph_builder, "mart.final.revenue")
        graph = graph_builder.build(target["definition_id"])

        ambiguous = [
            item for item in graph.boundaries
            if item["reason"] == "ambiguous_producer"
        ]
        self.assertEqual(1, len(ambiguous))
        self.assertEqual(2, len(ambiguous[0]["candidate_definition_ids"]))

    def test_override_selects_one_ambiguous_producer(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        graph_builder = DependencyGraphBuilder(reader)
        target = self._definition(graph_builder, "mart.final.revenue")
        upstream_a = next(
            item for item in graph_builder.list_field_producers("mart.mid.revenue")
            if item["job_name"] == "upstream_a"
        )
        graph = graph_builder.build(
            target["definition_id"],
            producer_overrides={
                upstream_a["field_id"]: upstream_a["definition_id"],
            },
        )

        self.assertFalse(any(
            item["reason"] == "ambiguous_producer"
            for item in graph.boundaries
        ))
        self.assertIn(upstream_a["definition_id"], graph.nodes)
        self.assertTrue(any(
            item.get("job_name") == "upstream_a"
            for item in graph.nodes.values()
        ))


class ProductionBundleTests(LineageGraphFixture, unittest.TestCase):
    def test_bundle_orders_upstream_job_before_downstream(self) -> None:
        reader = InMemoryProvenanceReader([self.upstream_a, self.downstream])
        graph_builder = DependencyGraphBuilder(reader)
        target = self._definition(graph_builder, "mart.final.revenue")
        bundle = ProductionBundleBuilder(reader).build(target["definition_id"])

        self.assertTrue(bundle.complete)
        self.assertEqual(
            ["upstream_a", "downstream"],
            [item["job_name"] for item in bundle.jobs],
        )
        self.assertIn("raw.orders_a", bundle.jobs[0]["raw_sql"])
        self.assertIn("mart.mid", bundle.jobs[1]["raw_sql"])
        self.assertEqual(
            [bundle.jobs[0]["job_id"]],
            bundle.jobs[1]["depends_on_job_ids"],
        )
        self.assertTrue(any(
            item["source_dataset_name"] == "raw.orders_a"
            for item in bundle.external_sources
        ))

    def test_ambiguous_bundle_is_explicitly_incomplete(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        graph_builder = DependencyGraphBuilder(reader)
        target = self._definition(graph_builder, "mart.final.revenue")
        bundle = ProductionBundleBuilder(reader).build(target["definition_id"])

        self.assertFalse(bundle.complete)
        self.assertEqual(["downstream"], [item["job_name"] for item in bundle.jobs])
        self.assertEqual(
            ["ambiguous_producer"],
            [item["reason"] for item in bundle.unresolved_boundaries],
        )

    def test_bundle_override_selects_requested_upstream_sql(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        graph_builder = DependencyGraphBuilder(reader)
        target = self._definition(graph_builder, "mart.final.revenue")
        upstream_a = next(
            item for item in graph_builder.list_field_producers("mart.mid.revenue")
            if item["job_name"] == "upstream_a"
        )
        bundle = ProductionBundleBuilder(reader).build(
            target["definition_id"],
            producer_overrides={
                upstream_a["field_id"]: upstream_a["definition_id"],
            },
        )

        self.assertTrue(bundle.complete)
        self.assertEqual(
            ["upstream_a", "downstream"],
            [item["job_name"] for item in bundle.jobs],
        )
        self.assertNotIn("raw.orders_b", bundle.jobs[0]["raw_sql"])

    def test_rendered_sql_is_ordered_and_hides_definition_debug_json(self) -> None:
        reader = InMemoryProvenanceReader([self.upstream_a, self.downstream])
        graph_builder = DependencyGraphBuilder(reader)
        target = self._definition(graph_builder, "mart.final.revenue")
        bundle = ProductionBundleBuilder(reader).build(target["definition_id"])

        sql = render_production_sql(bundle)
        self.assertLess(sql.index("job=job.upstream_a"), sql.index("job=job.downstream"))
        self.assertIn("INSERT OVERWRITE TABLE mart.mid", sql)
        self.assertIn("INSERT OVERWRITE TABLE mart.final", sql)
        self.assertIn("raw.orders_a.* [rowset]", sql)
        self.assertNotIn("selected_definitions", sql)


class ProductionPathEnumeratorTests(LineageGraphFixture, unittest.TestCase):
    def test_enumerates_every_ambiguous_upstream_producer(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        result = ProductionPathEnumerator(reader).enumerate(
            "mart.final.revenue"
        )

        self.assertEqual(2, result.path_count)
        self.assertFalse(result.truncated)
        self.assertEqual(
            {"upstream_a", "upstream_b"},
            {
                reader.get_definition(
                    path["producer_choices"][0]["selected_definition_id"]
                )["job_name"]
                for path in result.paths
            },
        )
        self.assertTrue(all(path["complete"] for path in result.paths))

    def test_enumerates_all_target_producers(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b,
        ])
        result = ProductionPathEnumerator(reader).enumerate("mart.mid.revenue")

        self.assertEqual(2, result.target_producer_count)
        self.assertEqual(2, result.path_count)
        self.assertEqual(
            2,
            len({path["target_definition_id"] for path in result.paths}),
        )

    def test_max_paths_marks_result_truncated(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        result = ProductionPathEnumerator(reader).enumerate(
            "mart.final.revenue", max_paths=1
        )

        self.assertEqual(1, result.path_count)
        self.assertTrue(result.truncated)

    def test_definitions_are_opt_in_to_keep_default_output_compact(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.downstream,
        ])
        compact = ProductionPathEnumerator(reader).enumerate(
            "mart.final.revenue"
        )
        verbose = ProductionPathEnumerator(reader).enumerate(
            "mart.final.revenue", include_definitions=True
        )

        self.assertNotIn("definitions", compact.paths[0])
        self.assertGreater(compact.paths[0]["definition_count"], 0)
        self.assertIn("definitions", verbose.paths[0])


class ProductionSqlReconstructorTests(unittest.TestCase):
    def test_inlines_upstream_query_and_keeps_boundary_schema(self) -> None:
        builder = SqlAstJobModelBuilder(dialect="hive")
        upstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.mid PARTITION(ds='2026-01-01') "
            "SELECT SUM(amount) AS revenue, COUNT(*) AS order_cnt "
            "FROM raw.orders",
            job_name="upstream",
        )
        downstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.final "
            "SELECT revenue AS revenue FROM mart.mid "
            "WHERE ds='2026-01-01'",
            job_name="downstream",
        )
        reader = InMemoryProvenanceReader([upstream, downstream])
        graph_builder = DependencyGraphBuilder(reader)
        target = graph_builder.list_field_producers("mart.final.revenue")[0]

        result = ProductionSqlReconstructor(reader).reconstruct(
            target["definition_id"]
        )

        self.assertIn("SUM(amount) AS revenue", result.sql)
        self.assertIn("'2026-01-01' AS ds", result.sql)
        self.assertNotIn("INSERT OVERWRITE", result.sql)
        self.assertNotIn("COUNT(*) AS order_cnt", result.sql)

    def test_warns_when_selected_producer_partition_is_filtered_out(self) -> None:
        builder = SqlAstJobModelBuilder(dialect="hive")
        upstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.mid PARTITION(appname='wefly5') "
            "SELECT SUM(amount) AS revenue FROM raw.orders",
            job_name="upstream",
        )
        downstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.final "
            "SELECT revenue AS revenue FROM mart.mid WHERE appname='mlbb'",
            job_name="downstream",
        )
        reader = InMemoryProvenanceReader([upstream, downstream])
        graph_builder = DependencyGraphBuilder(reader)
        target = graph_builder.list_field_producers("mart.final.revenue")[0]

        result = ProductionSqlReconstructor(reader).reconstruct(
            target["definition_id"]
        )

        self.assertTrue(any(
            "this branch returns no rows" in warning
            for warning in result.warnings
        ))
        self.assertIn("-- WARNING:", result.sql)

    def test_hoists_upstream_ctes_out_of_inlined_subquery(self) -> None:
        builder = SqlAstJobModelBuilder(dialect="hive")
        upstream = builder.parse_sql(
            "WITH base AS (SELECT amount FROM raw.orders) "
            "INSERT OVERWRITE TABLE mart.mid "
            "SELECT SUM(amount) AS revenue FROM base",
            job_name="upstream",
        )
        downstream = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.final "
            "SELECT revenue AS revenue FROM mart.mid",
            job_name="downstream",
        )
        reader = InMemoryProvenanceReader([upstream, downstream])
        graph_builder = DependencyGraphBuilder(reader)
        target = graph_builder.list_field_producers("mart.final.revenue")[0]

        result = ProductionSqlReconstructor(reader).reconstruct(
            target["definition_id"]
        )

        body = result.sql[result.sql.index("WITH base AS") :]
        self.assertTrue(body.startswith("WITH base AS"))
        self.assertNotIn("FROM (\n  WITH", body)


class AllProductionSqlGeneratorTests(LineageGraphFixture, unittest.TestCase):
    def test_writes_one_sql_per_complete_path_and_manifest(self) -> None:
        reader = InMemoryProvenanceReader([
            self.upstream_a, self.upstream_b, self.downstream,
        ])
        with TemporaryDirectory() as directory:
            result = AllProductionSqlGenerator(reader).generate(
                "mart.final.revenue", output_dir=directory
            )

            self.assertEqual(2, result.generated_sql_count)
            self.assertEqual(0, result.failed_sql_count)
            self.assertEqual(0, result.skipped_incomplete_count)
            self.assertTrue(Path(result.manifest_file).exists())
            for path in result.paths:
                sql_file = Path(directory) / path["sql_file"]
                self.assertTrue(sql_file.exists())
                self.assertIn("SELECT", sql_file.read_text(encoding="utf-8"))


class ColumnSqlSlicerTests(unittest.TestCase):
    def test_slices_union_value_logic_and_keeps_zero_branches(self) -> None:
        query = parse_one(
            "WITH dates AS (SELECT p_date, dt FROM raw.dates), "
            "base AS ("
            " SELECT a.country, d.dt, "
            " IF(SUBSTRING(a.active_info, 1 + DATEDIFF('2026-01-02', d.dt), 1) > 0, 1, 0) AS is_active"
            " FROM raw.device a LEFT JOIN dates d ON a.p_date=d.p_date"
            ") "
            "SELECT SUM(active_cnt) AS active_cnt FROM ("
            " SELECT country, SUM(is_active) AS active_cnt FROM base GROUP BY country"
            " UNION ALL SELECT country, 0 AS active_cnt FROM raw.reten_a"
            " UNION ALL SELECT country, 0 AS active_cnt FROM raw.reten_b"
            ") u GROUP BY country",
            read="hive",
        )

        sql = ColumnSqlSlicer().slice(query, {"active_cnt"}).sql(
            dialect="hive", pretty=True
        )

        self.assertIn("SUBSTRING(a.active_info", sql)
        self.assertIn("LEFT JOIN dates", sql)
        self.assertEqual(2, sql.count("0 AS active_cnt"))
        self.assertIn("SUM(is_active) AS active_cnt", sql)


class SingleJobColumnLogicBuilderTests(unittest.TestCase):
    def test_job_scoped_entry_writes_logic_and_sql(self) -> None:
        builder = SqlAstJobModelBuilder(dialect="hive")
        model = builder.parse_sql(
            "WITH base AS ("
            " SELECT IF(SUBSTRING(active_info, 1, 1) > 0, 1, 0) AS is_active, country"
            " FROM raw.device"
            ") "
            "INSERT OVERWRITE TABLE mart.final "
            "SELECT SUM(active_cnt) AS active_cnt FROM ("
            " SELECT country, SUM(is_active) AS active_cnt FROM base GROUP BY country"
            " UNION ALL SELECT country, 0 AS active_cnt FROM raw.reten_a"
            " UNION ALL SELECT country, 0 AS active_cnt FROM raw.reten_b"
            ") u GROUP BY country",
            job_name="100021029__0",
        )
        reader = InMemoryProvenanceReader([model])

        with TemporaryDirectory() as directory:
            result = SingleJobColumnLogicBuilder(reader).build(
                "100021029", "mart.final.active_cnt", directory
            )

            self.assertTrue(Path(result.logic_file).exists())
            self.assertTrue(Path(result.sql_file).exists())
            self.assertEqual("single_job", result.logic["scope"])
            self.assertEqual("job.100021029_0", result.logic["target"]["job_id"])
            self.assertEqual(
                "raw.device",
                result.logic["value_sources"][0]["dataset"],
            )
            branch_types = [
                item["dependency_type"] for item in result.logic["branches"]
            ]
            self.assertEqual(
                ["value", "constant_branch", "constant_branch"],
                branch_types,
            )
            self.assertEqual(
                [], result.logic["unresolved_boundaries"]
            )
            self.assertNotIn("INSERT OVERWRITE", result.sql)


if __name__ == "__main__":
    unittest.main()
