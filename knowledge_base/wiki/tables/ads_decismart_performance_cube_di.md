# test.ads_decismart_performance_cube_di  ()

> 

- 物理表: `test.ads_decismart_performance_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[carden_battle_cnt]], [[carden_battle_cnt_total]], [[carden_caton_cnt]], [[user_download_login_cnt]], [[user_download_login_cnt_total]], [[user_storage_download_complete_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[battle_rate]], [[carden_battle_cnt]], [[carden_caton_rate]], [[user_download_login_cnt]], [[user_rate]], [[user_storage_download_complet_rate]], [[新老用户]], [[机型]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, model_type, rendering_std_role_cnt_total, t1.rendering_std_role_cnt, t1.rendering_std_total, t1.rendering_battle_cnt from( select logymd, array_sum(rendering_std_role_cnt) as rendering_std_role_cnt_total, ${qffm_model_type_x} from test.ads_decismart_performance_cube_di where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${definition_type} and ${grouping_name} and ${country} and ${region} and ${zone}) res, unnest(model_type_arr, rendering_std_total, rendering_battle_cnt,rendering_std_role_cnt) as t1(model_type, rendering_std_total, rendering_battle_cnt,rendering_std_role_cnt) where ${model_type}
```