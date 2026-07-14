# mt_ads.ads_gamebi_roger_resource_cube_di  ()

> 

- 物理表: `mt_ads.ads_gamebi_roger_resource_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[active_cnt]], [[resource_array]], [[resource_num]], [[resoure_active_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[人均拥有数]], [[活跃拥有率]], [[皮肤拥有情况]], [[英雄拥有情况]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select t1.skinid as skinid, t1.active_cnt / active_cnt_dau * 100 as active_cnt from( select sum(active_cnt) as active_cnt_dau, ${qffm_skin_hero_order} from mt_ads.ads_gamebi_roger_resource_cube_di where ${definition_type} AND ${grouping_name} AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND resource_type = 'skin' AND ${country} AND ${region} AND ${register_dur} AND ${pay_grade} AND ${skin_quality}) res , unnest(skinid, skin_active_cnt) as t1(skinid, active_cnt) where t1.active_cnt > 0
```