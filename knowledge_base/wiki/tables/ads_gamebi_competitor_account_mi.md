# test.ads_gamebi_competitor_account_mi  ()

> 

- 物理表: `test.ads_gamebi_competitor_account_mi` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[compet_act_cnt]], [[compet_day_login_duration_avg]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[compet_act_cnt]], [[compet_day_login_duration_avg]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
with t_base_view as( select logymd, app_name, sum(compet_act_cnt) as compet_act_cnt, sum(mlbb_act_cnt) as mlbb_act_cnt from( select logymd, app_name, country, compet_act_cnt, mlbb_act_cnt from test.ads_gamebi_competitor_account_mi WHERE logymd between '#{base_logymd_start}' and '#{base_logymd_end}' and ${country}) a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${region} group by logymd, app_name ), t_top100_view as ( select app_name, compet_act_cnt from ( select app_name, compet_act_cnt, row_number() OVER ( ORDER BY compet_act_cnt DESC ) AS compet_act_cnt_rn from ( SELECT app_name, avg(compet_act_cnt) as compet_act_cnt FROM t_base_view group by app_name) t ) t where compet_act_cnt_rn <= 100 ), t_current_view as( select logymd, app_name, sum(compet_act_cnt) as compet_act_cnt, sum(mlbb_act_cnt) as mlbb_act_cnt from ( select logymd, app_name, country, compet_act_cnt, mlbb_act_cnt from test.ads_gamebi_competitor_account_mi WHERE ${logymd} and ${country} and app_name in (select app_name from t_top100_view )) a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type} ) b on a.country = b.country_code where ${region} group by logymd, app_name) SELECT app_name, avg(compet_act_cnt) as compet_act_cnt, sum(compet_act_cnt) / sum(mlbb_act_cnt) as compet_day_login_duration_avg FROM t_current_view group by app_name
```