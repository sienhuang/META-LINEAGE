# test.ads_gamebi_competitor_gamemarket_mi  ()

> 

- 物理表: `test.ads_gamebi_competitor_gamemarket_mi` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[st_downloads]], [[st_income]], [[st_mau]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[MLBB月均MAU(ST)]], [[MLBB月均下载量(ST)]], [[MLBB月均收入(ST)]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, app_name, sum(st_mau) as st_mau, sum(st_downloads) as st_downloads, sum(st_income) as st_income from test.ads_gamebi_competitor_gamemarket_mi a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${app_name} and ${country} and ${region} group by logymd, app_name
```