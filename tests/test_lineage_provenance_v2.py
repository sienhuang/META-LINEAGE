from __future__ import annotations

import unittest

from metawiki.lineage.repository import build_provenance_records
from metawiki.lineage.sql_ast_builder import SqlAstJobModelBuilder
from metawiki.pipeline.p4_field_logic import (
    _model_from_persisted_job,
    _parse_overrides,
)


class ProvenanceV2Tests(unittest.TestCase):
    def setUp(self) -> None:
        self.builder = SqlAstJobModelBuilder(dialect="hive")

    def _parse(self, source_table: str, job_name: str):
        return self.builder.parse_sql(
            f"""
            INSERT OVERWRITE TABLE mart.shared_metrics
            SELECT SUM(src.amount) AS revenue
            FROM {source_table} src
            """,
            job_name=job_name,
        )

    def test_same_physical_field_keeps_one_definition_per_producer(self) -> None:
        first = build_provenance_records(self._parse("raw.orders_a", "job_a"))
        second = build_provenance_records(self._parse("raw.orders_b", "job_b"))

        first_def = next(
            item for item in first["definitions"]
            if item["expression_sql"] and "SUM" in item["expression_sql"]
        )
        second_def = next(
            item for item in second["definitions"]
            if item["expression_sql"] and "SUM" in item["expression_sql"]
        )

        # The canonical field is shared across jobs, while its producer-scoped
        # definitions and productions remain distinct.
        self.assertEqual(first_def["field_id"], second_def["field_id"])
        self.assertNotEqual(first_def["definition_id"], second_def["definition_id"])
        self.assertNotEqual(first_def["production_id"], second_def["production_id"])

        first_sources = {
            item["source_field_id"] for item in first["dependencies"]
            if item["target_definition_id"] == first_def["definition_id"]
        }
        second_sources = {
            item["source_field_id"] for item in second["dependencies"]
            if item["target_definition_id"] == second_def["definition_id"]
        }
        self.assertTrue(any("raw.orders_a" in item for item in first_sources))
        self.assertTrue(any("raw.orders_b" in item for item in second_sources))
        self.assertTrue(first_sources.isdisjoint(second_sources))

    def test_dependency_type_distinguishes_count_rows(self) -> None:
        model = self.builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.row_counts "
            "SELECT COUNT(*) AS row_cnt FROM raw.events",
            job_name="row_count_job",
        )
        records = build_provenance_records(model)

        target = next(
            item for item in records["definitions"]
            if item["expression_sql"] and "COUNT" in item["expression_sql"]
        )
        dependencies = [
            item for item in records["dependencies"]
            if item["target_definition_id"] == target["definition_id"]
        ]
        self.assertEqual(["rowset"], [item["dependency_type"] for item in dependencies])

    def test_aggregation_keeps_value_and_rowset_dependencies(self) -> None:
        model = self.builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.amounts "
            "SELECT SUM(amount) AS total_amount FROM raw.orders",
            job_name="amount_job",
        )
        records = build_provenance_records(model)
        target = next(
            item for item in records["definitions"]
            if item["expression_sql"] and "SUM" in item["expression_sql"]
        )
        dependency_types = {
            item["dependency_type"] for item in records["dependencies"]
            if item["target_definition_id"] == target["definition_id"]
        }
        self.assertEqual({"value", "rowset"}, dependency_types)

    def test_outer_column_lazily_expands_select_star(self) -> None:
        model = self.builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.star_target "
            "SELECT t.active_cnt FROM (SELECT * FROM raw.events) t",
            job_name="star_job",
        )
        records = build_provenance_records(model)
        definitions = {
            item["definition_id"]: item for item in records["definitions"]
        }
        passthrough = next(
            item for item in definitions.values()
            if item["expression_sql"] == "active_cnt"
            and item["field_id"] != "field.table.mart.star_target.active_cnt"
        )
        sources = {
            item["source_field_id"] for item in records["dependencies"]
            if item["target_definition_id"] == passthrough["definition_id"]
        }
        self.assertEqual(
            {"field.table.raw.events.active_cnt"},
            sources,
        )

    def test_catalog_resolves_unqualified_column_across_wildcard_inputs(self) -> None:
        builder = SqlAstJobModelBuilder(
            dialect="hive",
            known_fields={("raw.primary", "active_cnt_td")},
        )
        model = builder.parse_sql(
            "INSERT OVERWRITE TABLE mart.catalog_target "
            "SELECT active_cnt_td FROM "
            "(SELECT * FROM raw.primary) t0 "
            "LEFT JOIN (SELECT * FROM raw.retention) t1 ON t0.id = t1.id",
            job_name="catalog_job",
        )
        records = build_provenance_records(model)
        source_ids = {
            item["source_field_id"] for item in records["dependencies"]
        }
        self.assertIn("field.table.raw.primary.active_cnt_td", source_ids)
        self.assertNotIn("field.table.raw.retention.active_cnt_td", source_ids)

    def test_persisted_job_can_be_reparsed_for_v2_backfill(self) -> None:
        sql = (
            "INSERT OVERWRITE TABLE mart.backfill_target "
            "SELECT source_id FROM raw.backfill_source"
        )
        builders = {
            "hive": SqlAstJobModelBuilder(dialect="hive"),
            "spark": SqlAstJobModelBuilder(dialect="spark"),
        }
        model = _model_from_persisted_job(
            "job.backfill_job", "backfill_job", "hive", sql, builders
        )

        records = build_provenance_records(model)
        self.assertEqual("job.backfill_job", model.job.job_id)
        self.assertTrue(any(
            item["dataset_id"] == "table.mart.backfill_target"
            for item in records["productions"]
        ))

    def test_backfill_rejects_non_deterministic_job_identity(self) -> None:
        builders = {
            "hive": SqlAstJobModelBuilder(dialect="hive"),
            "spark": SqlAstJobModelBuilder(dialect="spark"),
        }
        with self.assertRaisesRegex(ValueError, "job id mismatch"):
            _model_from_persisted_job(
                "job.wrong", "actual_name", "hive",
                "SELECT 1 AS value", builders,
            )

    def test_cli_overrides_support_multiple_path_choices(self) -> None:
        self.assertEqual(
            {"field.a": "definition.1", "field.b": "definition.2"},
            _parse_overrides([
                "--override", "field.a=definition.1",
                "--override", "field.b=definition.2",
            ]),
        )


if __name__ == "__main__":
    unittest.main()
