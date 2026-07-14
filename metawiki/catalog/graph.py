"""catalog.graph · 四层口径图 —— 连接 / 校验断链 / trace_lineage 回溯。

(承接 pipeline/p5_stitch.py 的缝合逻辑, 提为运行时可复用的类。)
不产生新事实, 只做三件事:
  ① 连接: 指标 ↔ 底层指标 ↔ 宽表 ↔ ETL 的交叉引用 → 可走通的图
  ② 校验: 找断链(缺口径 / 缺 dataset / 引用了不存在的底层指标 / algo 待补)
  ③ 服务: trace_lineage(指标) 沿四层链回溯, 一次返回完整口径
"""
from __future__ import annotations

from .. import settings
from . import loader
from .models import BaseIndicator, Metric, Table

logger = settings.getLogger("catalog.graph")


class KnowledgeGraph:
    """承载四层口径的节点图。一次构建, 供 MCP 工具反复查询。"""

    def __init__(self, metrics: dict[str, Metric], bases: dict[str, BaseIndicator],
                 tables: dict[str, Table]):
        self.metrics = metrics
        self.bases = bases
        self.tables = tables

    # ---- ① 连接 ------------------------------------------------------------
    @classmethod
    def load(cls) -> "KnowledgeGraph":
        """从 catalog 事实源载入并建图。"""
        metrics = {k: Metric.from_dict(v) for k, v in loader.load_metrics_raw().items()}
        bases = {k: BaseIndicator.from_dict(v)
                 for k, v in loader.load_base_indicators_raw().items()}
        tables = {k: Table.from_dict(v) for k, v in loader.load_tables_raw().items()}
        logger.info("建图: 指标 %d · 底层指标 %d · 表 %d",
                    len(metrics), len(bases), len(tables))
        return cls(metrics, bases, tables)

    # ---- ② 校验 ------------------------------------------------------------
    def validate(self) -> list[str]:
        """返回断链/缺口清单 —— 本身即数据治理价值。"""
        issues: list[str] = []
        for k, m in self.metrics.items():
            if not m.hint:
                issues.append(f"[缺口径] 指标 {k} 没有 hint(人话口径)")
            if not m.best_dataset:
                issues.append(f"[断链] 指标 {k} 没有 dataset_id")
            for b in m.base_indicators:
                bi = self.bases.get(b)
                if bi is None:
                    issues.append(f"[断链] 指标 {k} 引用的底层指标 {b} 未建字典")
                elif not bi.has_algo:
                    issues.append(f"[待补] 底层指标 {b} 的 algo 还没填真值(D 层)")
        return issues

    # ---- ③ 服务 ------------------------------------------------------------
    def trace_lineage(self, metric_key: str) -> str:
        """沿四层链回溯, 一次返回完整口径 —— 知识库存在的全部意义。"""
        m = self.metrics.get(metric_key)
        if not m:
            return f"未找到指标: {metric_key}"
        L = [
            f"指标: {m.name_cn} ({metric_key})",
            f"  公式(A): {m.best_formula or '—'}",
            f"  口径(A): {m.hint or '⚠️ 缺人话口径'}",
            f"  数据来源(C): {m.wide_table or '⚠️ 待P2'}  (dataset {m.best_dataset})",
            "  底层指标(B→D):",
        ]
        for b in m.base_indicators:
            bi = self.bases.get(b)
            if bi:
                L.append(f"    • {b} ({bi.name_cn or '?'}) [{bi.source_type}]")
                L.append(f"        算法(D): {bi.algo or '⚠️ 待P4'}  [{bi.status or '?'}]")
            else:
                L.append(f"    • {b}  ⚠️ 未建字典")
        L.append(f"  维度: {m.dimensions or '—'}")
        return "\n".join(L)
