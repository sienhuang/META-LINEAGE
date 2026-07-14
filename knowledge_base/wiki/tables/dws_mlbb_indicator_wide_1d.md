# dws_mlbb_indicator_wide_1d  (MLBB 指标宽表(日))

> [示例] MLBB 产品线的指标宽表，一行一天，核心指标装在 indicator_map(MAP) 列里， 另有部分高频指标拍平成直接列。datasetId=300016 等多个 dataset 直接 select 它。

- 物理表: `dws_mlbb_indicator_wide_1d` · 引擎: doris · 分层: DWS · 粒度: 天 (logymd 唯一) · 类型: —

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `logymd` | — |  |
| `indicator_map` | — |  |
| `pcu` | — |  |
| `acu` | — |  |

## 包含的底层指标
- MAP 列里: [[mau]], [[avg_active_cnt]]  (取数 `indicator_map['x']`)
- 直接列: [[pcu]], [[acu]]  (直接取列)

## 血缘
- 上游源表: [示例] dwd.dwd_mlbb_user_active_di, [示例] dwd.dwd_mlbb_pay_di
- 由 ETL 构建(task): s, p, a, r, k, _, s, q, l, :, /, /, e, t, l, /, d, w, s, _, m, l, b, b, _, i, n, d, i, c, a, t, o, r, _, w, i, d, e, _, 1, d
- 被这些指标使用: [[month_avg_activation]]
