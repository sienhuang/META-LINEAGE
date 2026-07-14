# online_num  `online_num`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `online_num`

依赖的底层指标:
- [[online_num]] (?) — `⚠️待D层` [待补] · 取数 `online_num`

## 数据来源
- 宽表: ⚠️ 待P2
- dataset: ['200013']  · 产品线 scope: ['mlcn']

## 字段生成逻辑(D 层)
- **online_num** @ `mt_ads_realtime.realtime_online_cube_view`
  - 口径指针: `etl://mt_ads_realtime.realtime_online_cube_view:online_num`(D 层未自动解析,待补)

## 元信息
- 分类: core-dau · tier: 长尾