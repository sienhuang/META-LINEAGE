# mt_ads.ads_decismart_annual_report_info  ()

> 

- 物理表: `mt_ads.ads_decismart_annual_report_info` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logyear AS year, user_nick AS user, totalusagedays AS totalUsageDays, totalpageviews AS totalPageViews, totalpagecount AS totalPageCount, firstlogindate AS firstLoginDate, firstviewappname AS firstViewAppName, firstviewpagename AS firstViewPageName, mostviewedappname AS mostViewedAppName, mostopenedpagename AS mostOpenedPageName, mostopenedpagecount AS mostOpenedPageCount, busiestday AS busiestDay, busiestdaypages AS busiestDayPages, DATE_FORMAT(latestviewfulltime, '%m-%d %H:%i') AS latestViewTime, latestviewpagename AS latestViewPageName, mostviewedtimehour AS mostViewedTimeHour, aiUsageCount FROM mt_ads.ads_decismart_annual_report_info WHERE logyear = '2025' and ${user_nick}
```