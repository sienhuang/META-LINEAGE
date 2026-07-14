# mlbb.realtime_login_test  ()

> 

- 物理表: `mlbb.realtime_login_test` · 引擎: doris/sr · 分层: None · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select m.country,m.region,active_cnt,create_role_cnt,recurring_cnt,charge_amt,pcu,acu from(select country,region,sum(active_cnt) AS active_cnt, sum(create_role_cnt) AS create_role_cnt, sum(recurring_cnt) AS recurring_cnt, sum(charge_amt) AS charge_amt from(select granularity_type,date_type,appname,logymd,point,country,network,day_cnt as active_cnt,0 as create_role_cnt,0 as recurring_cnt,0 as charge_amt,0 as pcu,0 as acu  from mlbb.realtime_login_test where point = (SELECT MAX(point) FROM mlbb.realtime_login_test WHERE ${logymd}) union all select granularity_type,date_type,appname,logymd,point,country,network,0 as active_cnt,day_cnt as create_role_cnt,0 as recurring_cnt,0 as charge_amt,0 as pcu,0 as acu  from mlbb.realtime_create_role_test  where point = (SELECT MAX(point) FROM mlbb.realtime_create_role_test WHERE ${logymd}) union all select granularity_type,date_type,appname,logymd,point, country, network,0 as active_cnt,0 as create_role_cnt,day_cnt as recurring_cnt,0 as charge_amt,0 as pcu,0 as acu from mlbb.realtime_recurring_test where point = (SELECT MAX(point) FROM mlbb.realtime_recurring_test WHERE ${logymd})  union all select granularity_type,date_type,appname,logymd,point, country,network,0 as active_cnt,0 as create_role_cnt,0 as recurring_cnt,day_amt as charge_amt,0 as pcu,0 as acu  from mlbb.realtime_charge_test where point = (SELECT MAX(point) FROM mlbb.realtime_charge_test WHERE ${logymd}))a left outer join ( select region, country_type ,definition_type , country_code from mlbb.dim_country_new where ${definition_type} ) b on a.country = b.country_code  where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country}  and ${region} group by country, region)m left outer join (select country, region, max(online_num) pcu,avg(online_num) as acu from(select country, region,point,sum(online_num) as online_num from(select granularity_type,date_type,appname,logymd,point, country,network,online_num from mlbb.realtime_online_test where online_num != 0 and dim_type = 'country') a left outer join ( select region, country_type ,definition_type , country_code from mlbb.dim_country_new where ${definition_type} ) b on a.country = b.country_code  where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country}  and ${region}  group by country, region,point)t1 group by   country, region)n on m.country=n.country and m.region=n.region
```