# mt_ads.ads_decismart_pay_channel_di  ()

> 

- 物理表: `mt_ads.ads_decismart_pay_channel_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `channel` | direct | cor.channel |
| `country` | direct | cor.country |
| `install_label` | direct | cor.install_label |
| `network_group` | direct | cor.network_group |
| `new_type` | direct | cor.new_type |
| `os` | direct | cor.os |
| `pay_amt` | aggregated | COALESCE(SUM(chg.pay_amt), 0) AS pay_amt |
| `pay_channel` | direct | chg.pay_channel |

## 包含的底层指标
- 直接列: [[pay_amt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100035618
- 被这些指标使用: [[付费渠道]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, a.pay_channel as pay_channel, sum(pay_amt) as pay_amt from mt_ads.ads_decismart_pay_channel_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and pay_channel is not null and ${appname} and ${granularity_type} and ${date_type} and ${region} and ${country} and ${network_group} and ${new_type} and ${install_label} and ${os} and ${channel} and ${arcade_label} group by date_range, pay_channel
```