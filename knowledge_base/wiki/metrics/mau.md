# MAU  `MAU`

**业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，月均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)

## 怎么算
**公式**: `cast(sum(indicator_map['mau']) as decimal(38,0))`

依赖的底层指标:
- [[mau]] (月活跃用户数(去重)) — `[示例] count(distinct uid)  -- 自然月内去重` [草稿] · 取数 `indicator_map['mau']`
- [[active_cnt_period]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_period`

## 数据来源
- 宽表: [[ads_gamebi_roger_secondary_di]], [[ads_gamebi_roger_primary_di]], [[ads_gamebi_roger_primary_di]], [[ads_gamebi_roger_secondary_di]], [[realtime_recurring]]
- dataset: ['300016', '300198', '300088', '300202', '300256', '300363']  · 产品线 scope: ['mlbb', 'mcgg', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **active_cnt_period** @ `test.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://test.ads_gamebi_roger_primary_di:active_cnt_period`(D 层未自动解析,待补)

## 各产品线实例
- [[MAU__mcgg__300198]] (scope=mcgg, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[MAU__mlbb__300016]] (scope=mlbb, dataset=300016, 宽表=mt_ads_pre.ads_gamebi_roger_secondary_di)
- [[MAU__mlbb__300088]] (scope=mlbb, dataset=300088, 宽表=test.ads_gamebi_roger_primary_di)
- [[MAU__wefly_cn__300202]] (scope=wefly_cn, dataset=300202, 宽表=mt_ads.ads_gamebi_roger_secondary_di)
- [[MAU__wegame__300256]] (scope=wegame, dataset=300256, 宽表=mt_ads.ads_gamebi_roger_secondary_di)
- [[MAU__zgame_cn__300363]] (scope=zgame_cn, dataset=300363, 宽表=mt_ads_realtime.realtime_recurring)

## 元信息
- 分类: core-dau · tier: 长尾