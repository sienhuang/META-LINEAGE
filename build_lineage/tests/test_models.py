from __future__ import annotations

import unittest

from build_lineage.models import (
    Boundary,
    BoundaryKind,
    Branch,
    ColumnLogic,
    DependencyKind,
    SourceDependency,
    TargetColumn,
    Transformation,
)


class TargetColumnTests(unittest.TestCase):
    def test_parses_job_and_full_column_ref(self) -> None:
        target = TargetColumn.from_ref(
            "100021029",
            "mt_ads.ads_gamebi_roger_primary_di.active_cnt",
        )

        self.assertEqual("mt_ads.ads_gamebi_roger_primary_di", target.dataset)
        self.assertEqual("active_cnt", target.field)
        self.assertEqual(
            "mt_ads.ads_gamebi_roger_primary_di.active_cnt", target.ref
        )


class ColumnLogicTests(unittest.TestCase):
    def test_serializes_business_dependency_types_without_internal_ids(self) -> None:
        logic = ColumnLogic(
            target=TargetColumn(
                job_id="100021029",
                dataset="mt_ads.ads_gamebi_roger_primary_di",
                field="active_cnt",
            ),
            value_sources=[SourceDependency(
                dataset="adbi.dm_sdk_device_multi_behavior_ug_df",
                field="active_info",
                kind=DependencyKind.VALUE,
            )],
            transformations=[Transformation(
                order=1,
                output_field="is_active",
                expression_sql=(
                    "IF(SUBSTRING(active_info, 1 + diffdays, 1) > 0, 1, 0) "
                    "AS is_active"
                ),
            )],
            branches=[Branch(
                order=1,
                expression_sql="SUM(is_active) AS active_cnt",
                kind=DependencyKind.VALUE,
                source_datasets=("adbi.dm_sdk_device_multi_behavior_ug_df",),
            )],
            boundaries=[Boundary(
                kind=BoundaryKind.EXTERNAL,
                dataset="adbi.dm_sdk_device_multi_behavior_ug_df",
                field="active_info",
            )],
        )

        value = logic.to_dict()

        self.assertTrue(value["complete"])
        self.assertEqual("value", value["value_sources"][0]["kind"])
        self.assertNotIn("definition_id", str(value))

    def test_unresolved_boundary_marks_logic_incomplete(self) -> None:
        logic = ColumnLogic(
            target=TargetColumn(
                job_id="1", dataset="schema.table", field="metric"
            ),
            boundaries=[Boundary(
                kind=BoundaryKind.UNRESOLVED,
                dataset="internal_cte",
                field="metric",
                reason="expression_not_found",
            )],
        )

        self.assertFalse(logic.complete)


if __name__ == "__main__":
    unittest.main()

