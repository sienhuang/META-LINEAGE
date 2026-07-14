# mt_ads.ads_gamebi_roger_primary_cube_di  ()

> 

- 物理表: `mt_ads.ads_gamebi_roger_primary_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `acu` | derived | COALESCE(acu, 0) AS acu |
| `appname` | direct | appname |
| `country` | derived | COALESCE(country, 'all') AS country |
| `definition_type` | direct | region_type AS definition_type |
| `grouping_name` | derived | CONCAT('(', CONCAT_WS(',', IF(NOT country IS NULL, 'country', NULL), IF(NOT region IS NULL, 'region', NULL)), ')') AS gr |
| `pcu` | derived | COALESCE(pcu, 0) AS pcu |
| `region` | derived | COALESCE(region, 'all') AS region |

## 包含的底层指标
- 直接列: [[acu]], [[pcu]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100021369, 100022737, 100030075, 100031163, 100031394, 100033079, 100037249, 100037278, 100048777, 100051061, 100052169, 100052839
- 被这些指标使用: [[ACU]], [[PCU]], [[acu]], [[pcu]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, region, country, pcu, acu from mt_ads.ads_gamebi_roger_primary_cube_di  where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${definition_type} and ${grouping_name} and ${channel}
```