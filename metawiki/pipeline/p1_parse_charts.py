"""P1 · 解析 chart-index.generated.json → 指标目录 + 底层指标频次工单。

整条流水线的锚点, 零依赖(只读那个 json), 纯增益。

数据模型(关键):
  每个 entry 是一张【指标卡】, 一张卡里可能承载多个指标 —— 指标都在 measures 里。
  我们以 measures 为准统计【所有指标】, 卡上的其余字段是这些指标的【附带信息】:
    · category   指标的业务归类 (core-dau/register/money/retention/pay-cnt/other)
    · hint       指标卡的口径说明
    · scope      项目 (mlbb/wefly_cn/...)
    · dataSetId  指标卡所用的宽表 (整卡共享)
    · rows/columns  聚合维度 —— 可动态增减
    · filters    过滤条件 —— 可动态增减
    · senior     对数据的二次处理: 代表需要二次统计或有衍生指标。
                 这部分前端扫描拿不全, 需从 Java 后端代码补充 —— 此处【先记录, 后补充】。

卡内指标的拆分口径:
  measures 按公式去重后, 若只剩 1 条公式 → 整卡就是 1 个指标, 名取卡 title
    (此时 alias 多是 value/num/bar_value 之类的图序列标签, 无业务含义);
  若 >1 条公式 → 卡内每条公式各是一个独立指标, 名取 measure.alias
    (如「月均活跃度」卡内的 MAU 与 月均活跃度)。

产出(打平, 不跨卡合并):
  catalog/generated/metrics.json          —— 指标行: 一张卡里的一个指标 = 一行,
                                             每行只带自己那张卡的附带信息(单项目/
                                             单宽表/单公式), 同名指标在不同项目里各占一行。
  catalog/generated/base_indicators.json  —— 底层指标 + 引用频次(D 层工单, 频次降序)
  metadata_kb.metrics (Postgres)          —— 同一批指标行整表重灌进库(列见 _PG_COLUMNS)。
用法: python -m metawiki.pipeline.p1_parse_charts          # 写 JSON + 库
      python -m metawiki.pipeline.p1_parse_charts --no-db   # 只写 JSON, 跳过库
连接: settings.PG_DSN; 可用 BIRAG_PG_DSN 或 BIRAG_PG_HOST/PORT/DB/USER/PASSWORD 覆盖。
"""
from __future__ import annotations

import collections
import json
import re
import sys

from .. import settings

log = settings.PARSE_CHART_LOGGER          # 落 logs/parse_chart_metrics.log + 控制台

# 落 metadata_kb 的表结构: 列名 ←→ metric dict 的 key 一一对应。
# list/dict 用 jsonb, 其余文本。每跑一次 P1 整表重灌(TRUNCATE + 批量插)。
_PG_COLUMNS = [
    "metric", "name_cn", "formula", "base_indicators", "value_type", "agg_func",
    "category", "scope", "scopes", "dataset_id", "dimensions", "filters", "hint",
    "senior", "card_key", "card_title", "chart_id", "source", "source_ref",
]
_PG_JSONB = {"base_indicators", "scopes", "dimensions", "filters", "senior"}
_PG_DDL = """
CREATE TABLE IF NOT EXISTS {table} (
    id              bigserial PRIMARY KEY,
    metric          text,
    name_cn         text,
    formula         text,
    base_indicators jsonb,
    value_type      text,
    agg_func        text,
    category        text,
    scope           text,
    scopes          jsonb,
    dataset_id      text,
    dimensions      jsonb,
    filters         jsonb,
    hint            text,
    senior          jsonb,
    card_key        text,
    card_title      text,
    chart_id        text,
    source          text,
    source_ref      text
)
"""

# 解析公式时要剔除的 SQL 关键字/函数, 剩下的才是底层指标名
SQLKW = {
    "cast", "as", "decimal", "sum", "avg", "max", "min", "trim", "count", "int", "case",
    "when", "then", "else", "end", "null", "and", "or", "distinct", "over", "partition",
    "by", "if", "order", "desc", "asc", "double", "bigint", "string", "coalesce", "round",
    "abs", "nvl", "ifnull", "rows", "preceding", "unbounded", "current", "row",
}


def formula_text(col) -> str:
    """把 measure.col 归一成可读公式字符串。

    新版 chart-index 里 col 可能是函数式对象, 如
    {"__call__": "metric_cal", "args": ["active_cnt"]} → "metric_cal(active_cnt)"。
    """
    if isinstance(col, dict):
        fn = col.get("__call__") or "?"
        args = ", ".join(str(a) for a in (col.get("args") or [])
                         if isinstance(a, (str, int, float)))
        return f"{fn}({args})"
    return col


def base_indicators_of(col) -> dict[str, str]:
    """从一条公式抽底层指标名 → source_type(map_key|metric_cal|direct_column)。

    底层(基础)指标有三种出现形态, 都要抽到:
      · indicator_map['dau']            → map_key      (dau 即基础指标 dau,
                                           只是业务归类里落在二类指标范围)
      · metric_cal(['active_cnt'])      → metric_cal   (函数式取数, args 即基础指标)
      · 裸 SQL 列名(剔除关键字后)        → direct_column
    """
    out: dict[str, str] = {}

    # 形态一: 函数式 col, 基础指标在 args 里
    if isinstance(col, dict):
        for a in col.get("args") or []:
            if isinstance(a, str) and a:
                out[a] = "metric_cal"
        return out

    if not isinstance(col, str):
        return out

    # 形态二: indicator_map['x']
    for k in re.findall(r"indicator_map\['([^']+)'\]", col):
        out[k] = "map_key"
    # 形态三: 剔除 indicator_map 与 SQL 关键字后剩下的裸列名
    stripped = re.sub(r"indicator_map\['[^']+'\]", "", col)
    for tok in re.findall(r"[a-zA-Z_][a-zA-Z0-9_]+", stripped):
        if tok.lower() in SQLKW:
            continue
        out.setdefault(tok, "direct_column")  # 不覆盖已标 map_key 的
    return out


def _cols(spec) -> list[str]:
    """从 rows/columns/filters 抽 col 名。

    正常是 [{col, alias, function}, ...]; 但也可能是函数式动态生成器
    (如 {"__call__": "rows.map", ...}) —— 这种维度/过滤是运行时动态拼的,
    静态抽不出列名, 标记为 "<dynamic>"。
    """
    if isinstance(spec, dict):
        return ["<dynamic>"]
    if not isinstance(spec, list):
        return []
    out = []
    for d in spec:
        if isinstance(d, dict) and d.get("col"):
            out.append(d["col"])
    return out


def dims_of(entry: dict) -> list[str]:
    """聚合维度列: rows + columns 的 col(可动态增减)。"""
    return _cols(entry.get("rows")) + _cols(entry.get("columns"))


def filter_cols_of(entry: dict) -> list[str]:
    """过滤列: filters 的 col(可动态增减)。"""
    return _cols(entry.get("filters"))


def indicators_of_card(entry: dict):
    """一张指标卡 → 它承载的若干指标。

    yield (name, formula, base_dict, measure)。拆分口径见模块 docstring。
    """
    ms = [m for m in (entry.get("measures") or [])
          if isinstance(m, dict) and m.get("col")]
    by_formula: dict[str, dict] = {}        # 公式 → 首个 measure(卡内按公式去重)
    for m in ms:
        by_formula.setdefault(formula_text(m["col"]), m)

    title = (entry.get("title") or entry.get("key") or "?").strip()
    single = len(by_formula) <= 1            # 单公式卡: 整卡即一个指标, 名取 title
    for formula, m in by_formula.items():
        name = title if single else ((m.get("alias") or "").strip() or title)
        yield name, formula, base_indicators_of(m["col"]), m


def write_to_pg(metrics: list[dict], table: str | None = None) -> int:
    """把打平后的指标行整表写入 metadata_kb。

    建表(IF NOT EXISTS) → TRUNCATE → execute_values 批量插。整库重灌,
    所以 P1 是这张表的唯一事实源, 每次跑都跟 chart-index 对齐。
    连接走 settings.PG_DSN(可用 BIRAG_PG_DSN / BIRAG_PG_* 环境变量覆盖)。
    """
    import psycopg2
    from psycopg2.extras import Json, execute_values

    table = table or settings.PG_METRICS_TABLE
    rows = [
        tuple(Json(m.get(c)) if c in _PG_JSONB else m.get(c) for c in _PG_COLUMNS)
        for m in metrics
    ]
    cols = ", ".join(_PG_COLUMNS)
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(_PG_DDL.format(table=table))
            cur.execute(f"TRUNCATE {table} RESTART IDENTITY")
            execute_values(cur, f"INSERT INTO {table} ({cols}) VALUES %s", rows)
        conn.commit()
    return len(rows)


def main(write_db: bool = True) -> None:
    entries = json.loads(settings.CHART_INDEX.read_text(encoding="utf-8"))["entries"]

    # 打平: 一张卡里的一个指标 = 一行, 不跨卡合并。
    # 每行只带它自己那张卡的附带信息(单项目/单宽表/单公式), 不并集。
    metrics = []
    # 底层指标按 (名字, dataset_id) 区分: 同名但来自不同宽表 = 不同底层指标,
    # 各自一行、各自一个 algo 槽(同名不同表很可能口径不同, 不能混)。
    base_agg: dict[tuple[str, str | None], dict] = {}
    for e in entries:
        cat = e.get("category")
        scope = e.get("scope")
        ds = e.get("dataSetId")
        hint = e.get("hint")
        dims = dims_of(e)
        fcols = filter_cols_of(e)
        sref = f"{e.get('file')}:{e.get('startLine')}"
        senior = e.get("senior")
        for name, formula, base, m in indicators_of_card(e):
            for b, st in base.items():
                rec = base_agg.get((b, ds))
                if rec is None:
                    rec = base_agg[(b, ds)] = {"source_type": st, "usage_count": 0}
                rec["usage_count"] += 1
            metrics.append({
                "metric": name,
                "name_cn": name,
                "formula": formula,
                "base_indicators": sorted(base),
                "value_type": m.get("type") or None,        # 如 "%"
                "agg_func": m.get("function") or None,       # 聚合: sum/avg/trim...
                "category": cat,                             # 业务归类
                "scope": scope,                              # 项目
                "scopes": [scope] if scope else [],          # (兼容下游模型)
                "dataset_id": ds,                            # 指标卡宽表
                "dimensions": dims,                          # 聚合维度(可动态)
                "filters": fcols,                            # 过滤列(可动态)
                "hint": hint or None,                        # 指标卡口径
                "senior": {                                  # 二次处理/衍生: 先记录, 待补
                    "present": bool(senior),
                    "raw": senior or None,
                    "status": "待补: 二次统计/衍生指标逻辑需从 Java 后端补充" if senior else None,
                },
                "card_key": e.get("key"),                    # 这指标属于哪张卡
                "card_title": e.get("title"),
                "chart_id": e.get("chartId"),
                "source": e.get("source"),
                "source_ref": sref,                          # 文件:行
            })

    base_list = [
        {"key": b, "dataset_id": ds, "source_type": rec["source_type"],
         "usage_count": rec["usage_count"], "algo": None, "status": "待补"}
        for (b, ds), rec in sorted(
            base_agg.items(), key=lambda kv: (-kv[1]["usage_count"], kv[0][0], kv[0][1] or ""))
    ]

    out = settings.CATALOG_DIR / "generated"
    out.mkdir(parents=True, exist_ok=True)
    (out / "metrics.json").write_text(
        json.dumps(metrics, ensure_ascii=False, indent=2), encoding="utf-8")
    (out / "base_indicators.json").write_text(
        json.dumps(base_list, ensure_ascii=False, indent=2), encoding="utf-8")

    with_hint = sum(1 for m in metrics if m["hint"])
    with_senior = sum(1 for m in metrics if m["senior"]["present"])
    distinct = len({m["metric"] for m in metrics})
    log.info("指标行(打平): %d  (去重指标名: %d)", len(metrics), distinct)
    log.info("  ├ 有 hint: %d  缺口: %d", with_hint, len(metrics) - with_hint)
    log.info("  └ 涉及 senior 二次处理(待 Java 后端补充): %d", with_senior)
    base_names = len({b["key"] for b in base_list})
    log.info("底层指标: %d 行 (名字×宽表; 去重名字 %d)  → catalog/generated/base_indicators.json",
             len(base_list), base_names)

    if write_db:
        try:
            n = write_to_pg(metrics)
            log.info("写入 metadata_kb.%s: %d 行 (整表重灌)", settings.PG_METRICS_TABLE, n)
        except Exception as exc:                     # 连不上/缺驱动: 不阻断 JSON 产出
            log.warning("写库失败(%s): %s", type(exc).__name__, exc)
            log.warning("JSON 已落盘; 配好连接后重跑即可。连接走 settings.PG_DSN "
                        "(可用 BIRAG_PG_DSN 或 BIRAG_PG_HOST/PORT/DB/USER/PASSWORD 覆盖)。")

    log.info("D 层工单 · 底层指标频次 Top10 (优先攻这些):")
    for b in base_list[:10]:
        log.info("   %4d 次  %-24s @ds=%-8s [%s]",
                 b["usage_count"], b["key"], b["dataset_id"] or "-", b["source_type"])


if __name__ == "__main__":
    main(write_db="--no-db" not in sys.argv)
