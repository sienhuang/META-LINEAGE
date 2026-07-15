{
  "target_ref": "mt_ads.ads_gamebi_roger_primary_di.active_cnt",
  "target_producer_count": 20,
  "path_count": 100,
  "truncated": true,
  "max_paths": 100,
  "explored_states": 267,
  "complete_path_count": 48,
  "incomplete_path_count": 52,
  "paths": [
    {
      "path_id": 1,
      "target_definition_id": "definition.2ca921cbbe7afbc501cee2fc",
      "complete": false,
      "producer_choices": [],
      "job_ids": [
        "job.100021029_0"
      ],
      "definition_count": 21,
      "external_sources": [
        {
          "edge_id": "dependency.c3b994010e012daecd72d01f",
          "source_field_id": "field.table.adbi.dm_sdk_device_multi_behavior_ug_df.active_info",
          "source_dataset_name": "adbi.dm_sdk_device_multi_behavior_ug_df",
          "source_field_name": "active_info",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.33718585f5b5b0f72d2695ba",
          "source_field_id": "field.table.adbi.dm_sdk_device_multi_behavior_ug_df.__rows__",
          "source_dataset_name": "adbi.dm_sdk_device_multi_behavior_ug_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.250c43838895a038462bf014",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c368497c6b4d1eab8e762cfe",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [
        {
          "definition_id": "definition.665772ebcbbe258cf7f34274",
          "source_field_id": "field.ds.100021029_0.subquery_3.p_date",
          "source_dataset_name": "subquery_3",
          "source_field_name": "p_date",
          "reason": "lineage_gap",
          "candidate_definition_ids": []
        },
        {
          "definition_id": "definition.1be97e6db22dbc6013bb3e72",
          "source_field_id": "field.ds.100021029_0.subquery_3.__rows__",
          "source_dataset_name": "subquery_3",
          "source_field_name": "*",
          "reason": "lineage_gap",
          "candidate_definition_ids": []
        }
      ],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.2ca921cbbe7afbc501cee2fc",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.63df35c1aa0fa2f59d4463ac",
          "dataset_name": "subquery_8",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.331b468b9b2edad52305c481",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "UNION_BRANCH_COLUMN[6]",
          "depth": 2
        },
        {
          "definition_id": "definition.9cdf93eeebc69fd0c862271e",
          "dataset_name": "subquery_9",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": "UNION_BRANCH_COLUMN[20]",
          "depth": 2
        },
        {
          "definition_id": "definition.0fc6f292db0883849ab7eb92",
          "dataset_name": "subquery_9_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.23e9fb352f9348b55d09e92d",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.9eb76d08e15ab98c325fcb93",
          "dataset_name": "subquery_9_branch_3",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.a97a0ab8c0fd176f37e689b0",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea5aa70e85746847e4d31b8e",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.ed43d5be157802655a0c52ca",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100021029_0",
          "expression_sql": "SUM(is_active) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.80ce49771e8e20674f9574ef",
          "dataset_name": "dm_sdk_device_df",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.9702ecf2901f414a40bc102f",
          "dataset_name": "dm_sdk_device_df",
          "field_name": "is_active",
          "job_id": "job.100021029_0",
          "expression_sql": "IF(SUBSTRING(active_info, 1 + diffdays, 1) > 0, 1, 0) AS is_active",
          "depth": 4
        },
        {
          "definition_id": "definition.0d43803dc22e272c77b7985e",
          "dataset_name": "t1",
          "field_name": "active_info",
          "job_id": "job.100021029_0",
          "expression_sql": "SUBSTRING(a.active_info, 1, 60) AS active_info /* 截取59位 */",
          "depth": 5
        },
        {
          "definition_id": "definition.2a1c5a2890fe3129d9e501fe",
          "dataset_name": "t1",
          "field_name": "diffdays",
          "job_id": "job.100021029_0",
          "expression_sql": "DATEDIFF('2026-05-31', c.logymd) AS diffdays /* 数据日期与业务日期相差天数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.c23008983fb4af18f03d8234",
          "dataset_name": "t1",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.a5f805c3200ece7fd58df7d9",
          "dataset_name": "date_list",
          "field_name": "logymd",
          "job_id": "job.100021029_0",
          "expression_sql": "DATE_ADD(p_date, (ROW_NUMBER() OVER (PARTITION BY p_date ORDER BY p_date) - 1) * -1) AS logymd",
          "depth": 6
        },
        {
          "definition_id": "definition.ac8b3250993c6c044d42ff28",
          "dataset_name": "date_list",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.094eb96169cdc2005deb2993",
          "dataset_name": "subquery_2",
          "field_name": "p_date",
          "job_id": "job.100021029_0",
          "expression_sql": "p_date",
          "depth": 7
        },
        {
          "definition_id": "definition.5ec47367cc7c32eb13e79603",
          "dataset_name": "subquery_2",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.1be97e6db22dbc6013bb3e72",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.665772ebcbbe258cf7f34274",
          "dataset_name": "subquery_3",
          "field_name": "p_date",
          "job_id": "job.100021029_0",
          "expression_sql": null,
          "depth": 8
        }
      ]
    },
    {
      "path_id": 2,
      "target_definition_id": "definition.582ef4f946d4db75b88736c6",
      "complete": false,
      "producer_choices": [],
      "job_ids": [
        "job.100031311_0"
      ],
      "definition_count": 2,
      "external_sources": [],
      "unresolved_boundaries": [
        {
          "definition_id": "definition.a5bd279dbf4957fea4c740e9",
          "source_field_id": "field.ds.100031311_0.t2.active_cnt",
          "source_dataset_name": "t2",
          "source_field_name": "active_cnt",
          "reason": "lineage_gap",
          "candidate_definition_ids": []
        }
      ],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.582ef4f946d4db75b88736c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100031311_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.a5bd279dbf4957fea4c740e9",
          "dataset_name": "t2",
          "field_name": "active_cnt",
          "job_id": "job.100031311_0",
          "expression_sql": null,
          "depth": 1
        }
      ]
    },
    {
      "path_id": 3,
      "target_definition_id": "definition.904ff480d850cca6ff1e3933",
      "complete": true,
      "producer_choices": [],
      "job_ids": [
        "job.100050909_0"
      ],
      "definition_count": 11,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.904ff480d850cca6ff1e3933",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100050909_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.d44b245453ac891454f4c183",
          "dataset_name": "t3",
          "field_name": "active_cnt",
          "job_id": "job.100050909_0",
          "expression_sql": "t1.active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.4357d0b96a6ff65dad59290d",
          "dataset_name": "t1",
          "field_name": "active_cnt",
          "job_id": "job.100050909_0",
          "expression_sql": "SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.92bdea5dce8c5da533897114",
          "dataset_name": "indicator_role",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "tag",
          "depth": 3
        },
        {
          "definition_id": "definition.b1d5e91c0bfd6dbc9ad930c1",
          "dataset_name": "t",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "UNION_BRANCH_COLUMN[2]",
          "depth": 4
        },
        {
          "definition_id": "definition.2e032fa511a10b448809d546",
          "dataset_name": "t_branch_1",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "'create' AS tag",
          "depth": 5
        },
        {
          "definition_id": "definition.3cf85739c94376281b1f187e",
          "dataset_name": "t_branch_2",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "tag",
          "depth": 5
        },
        {
          "definition_id": "definition.b48b3bbff0d56a92405bf100",
          "dataset_name": "t_branch_3",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "tag",
          "depth": 5
        },
        {
          "definition_id": "definition.5495cfe9bd4feb2eb52d016f",
          "dataset_name": "t_logout",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "'logout' AS tag",
          "depth": 6
        },
        {
          "definition_id": "definition.dbd67aad27927be88daa7719",
          "dataset_name": "t_login",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "tag",
          "depth": 6
        },
        {
          "definition_id": "definition.f4dc07b6a5f367428f77ad62",
          "dataset_name": "t2",
          "field_name": "tag",
          "job_id": "job.100050909_0",
          "expression_sql": "'login' AS tag",
          "depth": 7
        }
      ]
    },
    {
      "path_id": 4,
      "target_definition_id": "definition.64e2351083088a7ff6773b5f",
      "complete": true,
      "producer_choices": [],
      "job_ids": [
        "job.100052167_0"
      ],
      "definition_count": 12,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.64e2351083088a7ff6773b5f",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100052167_0",
          "expression_sql": "COALESCE(t3.active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.1b968c164e30cb046955cbc8",
          "dataset_name": "t3",
          "field_name": "active_cnt",
          "job_id": "job.100052167_0",
          "expression_sql": "SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.28a026a03d8f06fb1e6b4a2b",
          "dataset_name": "indicator_role",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "tag",
          "depth": 2
        },
        {
          "definition_id": "definition.bb4810ad89f3f93a466ff9ce",
          "dataset_name": "t",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "UNION_BRANCH_COLUMN[2]",
          "depth": 3
        },
        {
          "definition_id": "definition.0cb1e429074ba18eaadb7628",
          "dataset_name": "t_branch_2",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "tag",
          "depth": 4
        },
        {
          "definition_id": "definition.3e9422a4531b0938eb27abf8",
          "dataset_name": "t_branch_1",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "'create' AS tag",
          "depth": 4
        },
        {
          "definition_id": "definition.872d3ad9f4d5e311cc125342",
          "dataset_name": "t_branch_3",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "tag",
          "depth": 4
        },
        {
          "definition_id": "definition.946213b425cf10cfd4769e32",
          "dataset_name": "t_branch_4",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "tag",
          "depth": 4
        },
        {
          "definition_id": "definition.5907e8d89ed500c189a37b02",
          "dataset_name": "t_login",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "tag",
          "depth": 5
        },
        {
          "definition_id": "definition.88fd1045bbb4b078d71d1a9d",
          "dataset_name": "t_charge",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "'charge' AS tag",
          "depth": 5
        },
        {
          "definition_id": "definition.ee6bf22cd97b3551c2269652",
          "dataset_name": "t_logout",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "'logout' AS tag",
          "depth": 5
        },
        {
          "definition_id": "definition.fcecc91bd5286f4b8c62b150",
          "dataset_name": "t",
          "field_name": "tag",
          "job_id": "job.100052167_0",
          "expression_sql": "'login' AS tag",
          "depth": 6
        }
      ]
    },
    {
      "path_id": 5,
      "target_definition_id": "definition.2b449514624114cd083d9887",
      "complete": true,
      "producer_choices": [],
      "job_ids": [
        "job.100052824_0"
      ],
      "definition_count": 23,
      "external_sources": [
        {
          "edge_id": "dependency.df29fc7d48f6a458b8658482",
          "source_field_id": "field.table.w5_ods.create_role.__rows__",
          "source_dataset_name": "w5_ods.create_role",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.d6da9fb50a6c4c84e4b36b8e",
          "source_field_id": "field.table.w5_ods.login.__rows__",
          "source_dataset_name": "w5_ods.login",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.6edafcb3f6dc9022f9b26c38",
          "source_field_id": "field.table.w5_ods.logout.__rows__",
          "source_dataset_name": "w5_ods.logout",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.2714fc608868f90ed8f8a0eb",
          "source_field_id": "field.table.w5_ods.charge.__rows__",
          "source_dataset_name": "w5_ods.charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.2b449514624114cd083d9887",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100052824_0",
          "expression_sql": "COALESCE(t3.active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.6112a4feed9e77a43879ebfa",
          "dataset_name": "t3",
          "field_name": "active_cnt",
          "job_id": "job.100052824_0",
          "expression_sql": "SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt /* DAU */",
          "depth": 1
        },
        {
          "definition_id": "definition.279f790fea90ebda62b0de0d",
          "dataset_name": "indicator_role",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "tag",
          "depth": 2
        },
        {
          "definition_id": "definition.6dedd11b0abbc9ca110787af",
          "dataset_name": "indicator_role",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 2
        },
        {
          "definition_id": "definition.4072712adf404a88b5b684b6",
          "dataset_name": "t",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "UNION_BRANCH_COLUMN[2]",
          "depth": 3
        },
        {
          "definition_id": "definition.5d5510d9d27652bad543eeeb",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 3
        },
        {
          "definition_id": "definition.136139665a9a6a938cc506d3",
          "dataset_name": "t_branch_2",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.1e94ae8e3f86036ac6f22418",
          "dataset_name": "t_branch_1",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.2c0ec35e592bd3a04f5802fe",
          "dataset_name": "t_branch_4",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "'charge' AS tag",
          "depth": 4
        },
        {
          "definition_id": "definition.31ea0ed18d3d1c86c339a4db",
          "dataset_name": "t_branch_3",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ba2e7db68d9e034068cb2855",
          "dataset_name": "t_branch_4",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ba9bdeda8edba4855af07234",
          "dataset_name": "t_branch_3",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "'logout' AS tag",
          "depth": 4
        },
        {
          "definition_id": "definition.e3de88308576da343419b5b1",
          "dataset_name": "t_branch_1",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "'create' AS tag",
          "depth": 4
        },
        {
          "definition_id": "definition.f2d533d8ebdedef0aab62adf",
          "dataset_name": "t_branch_2",
          "field_name": "tag",
          "job_id": "job.100052824_0",
          "expression_sql": "'login' AS tag",
          "depth": 4
        },
        {
          "definition_id": "definition.51e1f0017a7d544d4db294e9",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.6f3fb0860dc5dd53b53e1489",
          "dataset_name": "t_login",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.b48dfa77fc63cc8110b8b307",
          "dataset_name": "t_logout",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.b499c0219d9a993b1243edc2",
          "dataset_name": "t_charge",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.1b34a7d5e8c163d22aa02767",
          "dataset_name": "subquery_10",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.7f4d9af1dbb5a57c928ba460",
          "dataset_name": "t_create",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.d88ac5e6030109035d1cab02",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.edd1b2c48f27ec6d42d0f1dd",
          "dataset_name": "t_logout_agg",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.ddfdc7937aa7fa9463f9383a",
          "dataset_name": "subquery_11",
          "field_name": "*",
          "job_id": "job.100052824_0",
          "expression_sql": null,
          "depth": 7
        }
      ]
    },
    {
      "path_id": 6,
      "target_definition_id": "definition.5161b506a99bfdb821541531",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037150_0",
        "job.100031072_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.0e40c2e471aa40c4d5f05046",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5161b506a99bfdb821541531",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8936a8f7ac884877879c4645",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.787ea7e2d1d7ca66ae9ac294",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.7ea2f3fb5066a9a6576d00f9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.272688874a57134b295e47a3",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037150_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 7,
      "target_definition_id": "definition.5161b506a99bfdb821541531",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037207_0",
        "job.100031072_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.545835a09aa6dd4ce812e1d2",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5161b506a99bfdb821541531",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8936a8f7ac884877879c4645",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.c15f1011c814b16f599e770e",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.655adfaf263e90ec7069e1e9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ebf1a23065f1c422c908c328",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037207_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 8,
      "target_definition_id": "definition.5161b506a99bfdb821541531",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037158_0",
        "job.100031072_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.e1ef6cf2b2a61599e49f459f",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5161b506a99bfdb821541531",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8936a8f7ac884877879c4645",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100031072_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.39f11aafc98724f9142b837d",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.97f31d2bc74e8b1a7dca0a80",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.25c31cd70239efae2c0c7040",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037158_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 9,
      "target_definition_id": "definition.654b4cc240bcbfb4b570cf24",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_dm.dm_multi_decismart_core_df.is_active",
          "selected_definition_id": "definition.54ab89ff4b59462f0816c30c",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100039145_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active"
        }
      ],
      "job_ids": [
        "job.100039145_0",
        "job.100033108_0"
      ],
      "definition_count": 8,
      "external_sources": [
        {
          "edge_id": "dependency.a480e23091d94f8bc764e83d",
          "source_field_id": "field.table.wefly_dw.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "wefly_dw.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.654b4cc240bcbfb4b570cf24",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.0911ad5cdf9648da2c1cecd8",
          "dataset_name": "t1",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.c6e54fd0d699ca658ba77411",
          "dataset_name": "tmp_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "UNION_BRANCH_COLUMN[11]",
          "depth": 2
        },
        {
          "definition_id": "definition.3579931f1539ea2f9dfde33c",
          "dataset_name": "tmp_tbl_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.898d2957c189de1e9bb6fca9",
          "dataset_name": "tmp_tbl_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "SUM(IF(is_active = 1, 1, 0)) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.b0bd80ec310e92b896a21fe5",
          "dataset_name": "tmp_tbl_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.54ab89ff4b59462f0816c30c",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100039145_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active",
          "depth": 4
        },
        {
          "definition_id": "definition.b338d253a95a472f673b3637",
          "dataset_name": "act",
          "field_name": "is_td",
          "job_id": "job.100039145_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 10,
      "target_definition_id": "definition.654b4cc240bcbfb4b570cf24",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_dm.dm_multi_decismart_core_df.is_active",
          "selected_definition_id": "definition.5f6390468645e6999ac1e9bb",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100033088_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active /*\t当日是否活跃(1:是，0:否) */"
        }
      ],
      "job_ids": [
        "job.100033088_0",
        "job.100033108_0"
      ],
      "definition_count": 8,
      "external_sources": [
        {
          "edge_id": "dependency.043018e0dc7e193c33ee9f14",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.654b4cc240bcbfb4b570cf24",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.0911ad5cdf9648da2c1cecd8",
          "dataset_name": "t1",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.c6e54fd0d699ca658ba77411",
          "dataset_name": "tmp_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "UNION_BRANCH_COLUMN[11]",
          "depth": 2
        },
        {
          "definition_id": "definition.3579931f1539ea2f9dfde33c",
          "dataset_name": "tmp_tbl_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.898d2957c189de1e9bb6fca9",
          "dataset_name": "tmp_tbl_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "SUM(IF(is_active = 1, 1, 0)) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.b0bd80ec310e92b896a21fe5",
          "dataset_name": "tmp_tbl_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100033108_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.5f6390468645e6999ac1e9bb",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100033088_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active /*\t当日是否活跃(1:是，0:否) */",
          "depth": 4
        },
        {
          "definition_id": "definition.43464d476d67adde5ac13560",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033088_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 11,
      "target_definition_id": "definition.4247cfe9278c82783b741822",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_dm.dm_multi_decismart_core_df.is_active",
          "selected_definition_id": "definition.54ab89ff4b59462f0816c30c",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100039145_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active"
        }
      ],
      "job_ids": [
        "job.100039145_0",
        "job.100033187_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.a480e23091d94f8bc764e83d",
          "source_field_id": "field.table.wefly_dw.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "wefly_dw.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.4247cfe9278c82783b741822",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100033187_0",
          "expression_sql": "COALESCE(SUM(b.active_days), 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3b5dfac6b742d9726dbdb4d7",
          "dataset_name": "b",
          "field_name": "active_days",
          "job_id": "job.100033187_0",
          "expression_sql": "SUM(IF(is_active = 1, 1, 0)) AS active_days /* 活跃天数 */",
          "depth": 1
        },
        {
          "definition_id": "definition.54ab89ff4b59462f0816c30c",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100039145_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active",
          "depth": 2
        },
        {
          "definition_id": "definition.b338d253a95a472f673b3637",
          "dataset_name": "act",
          "field_name": "is_td",
          "job_id": "job.100039145_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 12,
      "target_definition_id": "definition.4247cfe9278c82783b741822",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_dm.dm_multi_decismart_core_df.is_active",
          "selected_definition_id": "definition.5f6390468645e6999ac1e9bb",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100033088_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active /*\t当日是否活跃(1:是，0:否) */"
        }
      ],
      "job_ids": [
        "job.100033088_0",
        "job.100033187_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.043018e0dc7e193c33ee9f14",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.4247cfe9278c82783b741822",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100033187_0",
          "expression_sql": "COALESCE(SUM(b.active_days), 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3b5dfac6b742d9726dbdb4d7",
          "dataset_name": "b",
          "field_name": "active_days",
          "job_id": "job.100033187_0",
          "expression_sql": "SUM(IF(is_active = 1, 1, 0)) AS active_days /* 活跃天数 */",
          "depth": 1
        },
        {
          "definition_id": "definition.5f6390468645e6999ac1e9bb",
          "dataset_name": "mt_dm.dm_multi_decismart_core_df",
          "field_name": "is_active",
          "job_id": "job.100033088_0",
          "expression_sql": "IF(act.is_td = 1, 1, 0) AS is_active /*\t当日是否活跃(1:是，0:否) */",
          "depth": 2
        },
        {
          "definition_id": "definition.43464d476d67adde5ac13560",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033088_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 13,
      "target_definition_id": "definition.ae9c85d0b2876d6aef089ac0",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037150_0",
        "job.100037162_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.0e40c2e471aa40c4d5f05046",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ae9c85d0b2876d6aef089ac0",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8afff8f68686aa4273e9759e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.787ea7e2d1d7ca66ae9ac294",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.7ea2f3fb5066a9a6576d00f9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.272688874a57134b295e47a3",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037150_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 14,
      "target_definition_id": "definition.ae9c85d0b2876d6aef089ac0",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037207_0",
        "job.100037162_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.545835a09aa6dd4ce812e1d2",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ae9c85d0b2876d6aef089ac0",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8afff8f68686aa4273e9759e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.c15f1011c814b16f599e770e",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.655adfaf263e90ec7069e1e9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ebf1a23065f1c422c908c328",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037207_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 15,
      "target_definition_id": "definition.ae9c85d0b2876d6aef089ac0",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037158_0",
        "job.100037162_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.e1ef6cf2b2a61599e49f459f",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ae9c85d0b2876d6aef089ac0",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.8afff8f68686aa4273e9759e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037162_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.39f11aafc98724f9142b837d",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.97f31d2bc74e8b1a7dca0a80",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.25c31cd70239efae2c0c7040",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037158_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 16,
      "target_definition_id": "definition.1873ec097e14d89be1ef8e6a",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037150_0",
        "job.100037206_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.0e40c2e471aa40c4d5f05046",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.1873ec097e14d89be1ef8e6a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.a756f38b72bb763eef357cd1",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.2f84b47862016d1324f251c6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.787ea7e2d1d7ca66ae9ac294",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.7ea2f3fb5066a9a6576d00f9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037150_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.272688874a57134b295e47a3",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037150_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 17,
      "target_definition_id": "definition.1873ec097e14d89be1ef8e6a",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037207_0",
        "job.100037206_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.545835a09aa6dd4ce812e1d2",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.1873ec097e14d89be1ef8e6a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.a756f38b72bb763eef357cd1",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.6324d6f4115bdabbdae46ac1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.c15f1011c814b16f599e770e",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.655adfaf263e90ec7069e1e9",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037207_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ebf1a23065f1c422c908c328",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037207_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 18,
      "target_definition_id": "definition.1873ec097e14d89be1ef8e6a",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt",
          "selected_definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100037158_0",
        "job.100037206_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.e1ef6cf2b2a61599e49f459f",
          "source_field_id": "field.table.mt_dwm.dwm_active_role_zone_di_timezone.logymd",
          "source_dataset_name": "mt_dwm.dwm_active_role_zone_di_timezone",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.1873ec097e14d89be1ef8e6a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.a756f38b72bb763eef357cd1",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100037206_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a9aa749493aa755dd2720550",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid_timezone",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.39f11aafc98724f9142b837d",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.97f31d2bc74e8b1a7dca0a80",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100037158_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.25c31cd70239efae2c0c7040",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100037158_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 19,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 20,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 21,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100039140_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 22,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 23,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 24,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100039140_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 25,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 26,
      "target_definition_id": "definition.0cbb5045f63444ad0b8e7305",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100039140_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.0cbb5045f63444ad0b8e7305",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.3f050a4464e0d02c39389c26",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100039140_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 27,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 28,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 29,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100041395_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 30,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 31,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 32,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100041395_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 33,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 34,
      "target_definition_id": "definition.ec45a10e179976b5e7991edd",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100041395_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.ec45a10e179976b5e7991edd",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.2f4611fd3085f64edfad917d",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041395_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 35,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 36,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 37,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100041406_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 38,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 39,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 40,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100041406_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 41,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 42,
      "target_definition_id": "definition.37e1179df291930c9974e57d",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100041406_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.37e1179df291930c9974e57d",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.29afd25b69a1b0d33433c73e",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041406_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 43,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 44,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 45,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100041407_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 46,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 47,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 48,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100041407_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 49,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 50,
      "target_definition_id": "definition.b6d99ffe31d14f27d216d55b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100041407_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.b6d99ffe31d14f27d216d55b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.f9c3079b7f92a1a658d252f7",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041407_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 51,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 52,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 53,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100041408_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 54,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 55,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 56,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100041408_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 57,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 58,
      "target_definition_id": "definition.205be010f49cfabd5797f1e1",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100041408_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.205be010f49cfabd5797f1e1",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.20688754c6d963c9008231b6",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041408_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 59,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041279_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 60,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033331_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 61,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100035813_0",
        "job.100041409_0"
      ],
      "definition_count": 6,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 62,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041282_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 63,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100032988_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 64,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100033425_0",
        "job.100041409_0"
      ],
      "definition_count": 7,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 3
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        }
      ]
    },
    {
      "path_id": 65,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041280_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 66,
      "target_definition_id": "definition.67d25e82470e2229dad8f388",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100041283_0",
        "job.100041409_0"
      ],
      "definition_count": 4,
      "external_sources": [],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.67d25e82470e2229dad8f388",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 0
        },
        {
          "definition_id": "definition.fe030e9fefc3d307362d8652",
          "dataset_name": "a",
          "field_name": "active_cnt",
          "job_id": "job.100041409_0",
          "expression_sql": "active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 2
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 3
        }
      ]
    },
    {
      "path_id": 67,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041279_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 68,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100033331_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 69,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100035813_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 26,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 70,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100041282_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 71,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 72,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100033425_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 27,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 73,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 74,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100041283_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 75,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100025255_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.cf6e7a9daf4bde6223293b9f -> definition.ff991a108faf45afa48e931b",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.cf6e7a9daf4bde6223293b9f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 8
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 11
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 12
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 12
        }
      ]
    },
    {
      "path_id": 76,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041279_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 77,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100033331_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 78,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100035813_0",
        "job.100020886_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 79,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041282_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 80,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 81,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100033425_0",
        "job.100020886_0"
      ],
      "definition_count": 25,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 82,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041280_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 83,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041283_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 84,
      "target_definition_id": "definition.5d9c04abb8e35562a35abe9b",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100025255_0",
        "job.100020886_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ce95c984c126d91315a978ca",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.c1fe4873770e68db2cee22cf",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.cf6e7a9daf4bde6223293b9f -> definition.ff991a108faf45afa48e931b"
      ],
      "definitions": [
        {
          "definition_id": "definition.5d9c04abb8e35562a35abe9b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.acc33a707ac69d574ff1a073",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.7736f524658648d1b96a1940",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[36]",
          "depth": 2
        },
        {
          "definition_id": "definition.e1473d3c5a7e5c1d75a10ce5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.153d8baf732fe0b4aaeccbf1",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.41616c22ba585e28a24116a0",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.4b058f7f5e50873b40695385",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.5f105e6aba8991dbaf0635cc",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100020886_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.dccbb16b0db51d0823ededa6",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ea691335afd7a276de67b395",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100020886_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.cf6e7a9daf4bde6223293b9f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 7
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 11
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 11
        }
      ]
    },
    {
      "path_id": 85,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041279_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 86,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100033331_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 87,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100035813_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 26,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 88,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100041282_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 89,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 90,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100033425_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 27,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 5
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 91,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 92,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100041283_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.ec908c04bbebe84593f082a8 -> definition.be8b4263e74db18cf8652a5a",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.be8b4263e74db18cf8652a5a",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.ec908c04bbebe84593f082a8",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041283_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 6
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 10
        }
      ]
    },
    {
      "path_id": 93,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100041280_0",
        "job.100025255_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.cade2648cac189eb4d124dcd",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.32000e23f020a5f30e18910a",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.cf6e7a9daf4bde6223293b9f -> definition.ff991a108faf45afa48e931b",
        "cycle detected: definition.5f7f72a70d0aa916f086d184 -> definition.1eec4f23ce5ee80107fa5568"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.ff991a108faf45afa48e931b",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.cf6e7a9daf4bde6223293b9f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100025255_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.1eec4f23ce5ee80107fa5568",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.5f7f72a70d0aa916f086d184",
          "dataset_name": "daily_tbl",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.c281a226537d9f3063ee29e5",
          "dataset_name": "res_period",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.0c990215d874b493d32345d5",
          "dataset_name": "account_pay_di",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.2a3363c4f1bbc2422c960a2a",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": "*",
          "depth": 8
        },
        {
          "definition_id": "definition.318f0f40f4d7d2d11c73ee73",
          "dataset_name": "active_all_account",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cce664761f611cbb696c6845",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100041280_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 10
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 11
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 12
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 12
        }
      ]
    },
    {
      "path_id": 94,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041279_0",
        "job.100025287_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.b186c710ccaa4d8865e83d2e -> definition.17156d2d804fcf6854ef6f3e"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.17156d2d804fcf6854ef6f3e",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.b186c710ccaa4d8865e83d2e",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041279_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 95,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100033331_0",
        "job.100025287_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.39792a4b8c8bc1dde0969d9c",
          "source_field_id": "field.table.mcgg_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "mcgg_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.71120ff18e1ca7f43c1a73e6",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033331_0",
          "expression_sql": "COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.478875b1db9bf661374fdd24",
          "dataset_name": "active_all_account",
          "field_name": "is_td",
          "job_id": "job.100033331_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 96,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100035813_0",
        "job.100025287_0"
      ],
      "definition_count": 24,
      "external_sources": [
        {
          "edge_id": "dependency.36e498168b1d0378b95b900f",
          "source_field_id": "field.table.msdk_dwm.dwm_active_role_zone_di.logymd",
          "source_dataset_name": "msdk_dwm.dwm_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.73d084b3ca1d67a24d314044",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.621a7b95be22ccff55e0370b",
          "dataset_name": "b",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.1eda412255eba846e889ec00",
          "dataset_name": "subquery_5",
          "field_name": "active_cnt",
          "job_id": "job.100035813_0",
          "expression_sql": "SUM(is_td) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.ecd1e0c9c41ce27467f1b6b9",
          "dataset_name": "ad",
          "field_name": "is_td",
          "job_id": "job.100035813_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 97,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041282_0",
        "job.100025287_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.4f9e83a4afa789300abbfe4f -> definition.857e60cd7f6f1f47a23fb220"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.857e60cd7f6f1f47a23fb220",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.4f9e83a4afa789300abbfe4f",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041282_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 98,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100025287_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.af7a14e872d07223f0809388",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.logymd",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.a98768ce384e26f101a91189",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100032988_0",
          "expression_sql": "COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.ef6fb1bdad544445ad2b1e8d",
          "dataset_name": "active_di",
          "field_name": "is_td",
          "job_id": "job.100032988_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 99,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": true,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100033425_0",
        "job.100025287_0"
      ],
      "definition_count": 25,
      "external_sources": [
        {
          "edge_id": "dependency.8c140c8b92859edd1c05966f",
          "source_field_id": "field.table.bi_test.dwm_zgame_active_role_zone_di.logymd",
          "source_dataset_name": "bi_test.dwm_zgame_active_role_zone_di",
          "source_field_name": "logymd",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.ad30804a4d2f25701d7fb515",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "COALESCE(active_cnt, 0) AS active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.e1c43f3492d6499ea66a54a6",
          "dataset_name": "subquery_9",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "UNION_BRANCH_COLUMN[3]",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.36b9d9c49ca88da4c9f86c8c",
          "dataset_name": "subquery_9_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.36ce9028b88e0dae1caef5b3",
          "dataset_name": "subquery_9_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100033425_0",
          "expression_sql": "SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt",
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.e39f131510ae941e2556051d",
          "dataset_name": "active_info",
          "field_name": "is_td",
          "job_id": "job.100033425_0",
          "expression_sql": "MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td",
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    },
    {
      "path_id": 100,
      "target_definition_id": "definition.472b6d36ff96ab4e391e8842",
      "complete": false,
      "producer_choices": [
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__",
          "selected_definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null
        },
        {
          "source_field_id": "field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt",
          "selected_definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt"
        }
      ],
      "job_ids": [
        "job.100001123_0",
        "job.100032988_0",
        "job.100041280_0",
        "job.100025287_0"
      ],
      "definition_count": 22,
      "external_sources": [
        {
          "edge_id": "dependency.7b858866e081b5e1b9d254d8",
          "source_field_id": "field.table.mt_dim.dim_mla_basic_role_zone_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_basic_role_zone_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.e03fc9f488046f7de598dd70",
          "source_field_id": "field.table.mt_dwm.dwm_mla_active_role_zone_di.__rows__",
          "source_dataset_name": "mt_dwm.dwm_mla_active_role_zone_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.9f2828763f281c2bd33a3802",
          "source_field_id": "field.table.mh_ods.gameserver_charge.__rows__",
          "source_dataset_name": "mh_ods.gameserver_charge",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.cfaf9200e60fa9e3cafbf531",
          "source_field_id": "field.table.mt_dim.dim_mla_product_type_df.__rows__",
          "source_dataset_name": "mt_dim.dim_mla_product_type_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.fc34f89fccb3a7257a34ea09",
          "source_field_id": "field.table.mt_ads.ads_gamebi_create_reten_ltv_df.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_create_reten_ltv_df",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        },
        {
          "edge_id": "dependency.ee7a74b11aa70100a987c06f",
          "source_field_id": "field.table.mt_ads.ads_gamebi_active_reten_di.__rows__",
          "source_dataset_name": "mt_ads.ads_gamebi_active_reten_di",
          "source_field_name": "*",
          "reason": "producer_not_found",
          "candidate_definition_ids": []
        }
      ],
      "unresolved_boundaries": [],
      "warnings": [
        "cycle detected: definition.fd473f0b931afba76dbc2162 -> definition.bd90c9fab684ff59a9c793b3"
      ],
      "definitions": [
        {
          "definition_id": "definition.472b6d36ff96ab4e391e8842",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt /*\t活跃玩家数 */",
          "depth": 0
        },
        {
          "definition_id": "definition.28575986b1440c4cbd9178f2",
          "dataset_name": "subquery_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "COALESCE(SUM(active_cnt), 0) AS active_cnt",
          "depth": 1
        },
        {
          "definition_id": "definition.a7d62905c1c619b5520fdfa5",
          "dataset_name": "subquery_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[7]",
          "depth": 2
        },
        {
          "definition_id": "definition.b4bfdea4931c5ebf0f021a05",
          "dataset_name": "subquery_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": "UNION_BRANCH_COLUMN[34]",
          "depth": 2
        },
        {
          "definition_id": "definition.1923c556d3f404f4b9352481",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.36074b759fee54784aa5942a",
          "dataset_name": "subquery_3_branch_1",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.42ac0c2c738b5c27eba7aadc",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.8a19396056701b461aa24c7f",
          "dataset_name": "subquery_3_branch_2",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.c9d43f7ca9da33cf83c2c501",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "*",
          "job_id": "job.100025287_0",
          "expression_sql": null,
          "depth": 3
        },
        {
          "definition_id": "definition.cdf0179235235d6979f8c382",
          "dataset_name": "subquery_3_branch_3",
          "field_name": "active_cnt",
          "job_id": "job.100025287_0",
          "expression_sql": "0 AS active_cnt",
          "depth": 3
        },
        {
          "definition_id": "definition.2c6ecace7f6a3d2eae83ae95",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 4
        },
        {
          "definition_id": "definition.bd90c9fab684ff59a9c793b3",
          "dataset_name": "mt_ads.ads_gamebi_roger_primary_di_mid",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "dai.active_cnt",
          "depth": 4
        },
        {
          "definition_id": "definition.3aab3b333bec56929ec7c4fb",
          "dataset_name": "basic",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": "*",
          "depth": 5
        },
        {
          "definition_id": "definition.6b9fd0ff447e0b8b4833713a",
          "dataset_name": "pay_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.f7b8611aa29da2e739e6d03a",
          "dataset_name": "active_di",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 5
        },
        {
          "definition_id": "definition.fd473f0b931afba76dbc2162",
          "dataset_name": "daily_tbl",
          "field_name": "active_cnt",
          "job_id": "job.100041280_0",
          "expression_sql": "SUM(active_cnt) AS active_cnt /*\t活跃玩家数 */",
          "depth": 5
        },
        {
          "definition_id": "definition.af0aebf182a375095d097f69",
          "dataset_name": "mt_dwm.dwm_mla_pay_role_zone_di",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.72c25e8143dd19dadfad3c47",
          "dataset_name": "t",
          "field_name": "*",
          "job_id": "job.100032988_0",
          "expression_sql": null,
          "depth": 6
        },
        {
          "definition_id": "definition.8ee19d752200ecb6178a0638",
          "dataset_name": "subquery_7",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 7
        },
        {
          "definition_id": "definition.315cfbefaa4da2add1a7cbe6",
          "dataset_name": "charge",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 8
        },
        {
          "definition_id": "definition.b323a4dac65ffbcdb579cf1b",
          "dataset_name": "pro",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": null,
          "depth": 9
        },
        {
          "definition_id": "definition.cded00771d42b6b5713e41b0",
          "dataset_name": "chg",
          "field_name": "*",
          "job_id": "job.100001123_0",
          "expression_sql": "*",
          "depth": 9
        }
      ]
    }
  ]
}
