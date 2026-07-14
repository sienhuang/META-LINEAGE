# value · mlcn  `value__mlcn`

> 逻辑指标 [[value]] 在产品线 **mlcn** 的实例

- **公式**: `sum(login_day_cnt)/sum(create_role_day_cnt)`
- **业务口径**: (T-1日新增、且T日登录的去重玩家数) / (T-1新增的去重玩家数) * 100%
- 宽表: ⚠️ 待P2  (dataset 200001)
- dataset SQL: `mysql://ba/data_set#200001`
- 维度: ['logymd', 'point']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnRealTime/const.ts:275