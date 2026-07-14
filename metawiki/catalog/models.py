"""catalog.models · 四层口径模型的数据类。

对应 DESIGN.md §3 的四层:
  A 展示指标 Metric        : 公式 + 人话口径 + 维度 + dataset
  B 底层指标 BaseIndicator : map key / 裸列 + D 层算法
  C/D 表     Table         : Doris/SR 宽表 + 物理源表 + 血缘

每个实体保留 `raw`(原始 dict), 渲染/透传时不丢字段; 常用字段提为带类型属性,
让 graph / 工具层以属性访问而非到处 .get()。
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any


@dataclass
class Metric:
    """A 层 · 展示指标(160 个逻辑指标)。"""
    metric: str
    name_cn: str = ""
    category: str | None = None
    formula: str | None = None              # 单条公式; 没有则取 formulas[-1]
    formulas: list[str] = field(default_factory=list)
    hint: str | None = None                 # 人话口径(42% 已有)
    base_indicators: list[str] = field(default_factory=list)
    dataset_id: str | None = None
    dataset_ids: list[str] = field(default_factory=list)
    wide_table: str | None = None
    wide_tables: list[str] = field(default_factory=list)
    dataset_sql_ref: str | None = None
    dimensions: Any = None
    filters: Any = None
    scopes: list[str] = field(default_factory=list)
    instances: list[dict] = field(default_factory=list)
    tier: str = "长尾"
    source_ref: str | None = None
    raw: dict = field(default_factory=dict)

    @property
    def best_formula(self) -> str | None:
        return self.formula or (self.formulas[-1] if self.formulas else None)

    @property
    def best_dataset(self) -> Any:
        return self.dataset_id or (self.dataset_ids or None)

    @classmethod
    def from_dict(cls, d: dict) -> "Metric":
        known = {f for f in cls.__dataclass_fields__ if f != "raw"}
        return cls(raw=d, **{k: v for k, v in d.items() if k in known})


@dataclass
class BaseIndicator:
    """B/D 层 · 底层指标字典(~355 个, 复用度最高)。"""
    key: str
    name_cn: str = ""
    source_type: str | None = None          # map_key | direct_column | metric_cal
    usage_count: int = 0
    wide_table: str | None = None           # B 层所在宽表(P5 经 dataset_id 回填)
    algo: str | None = None                 # D 层 ETL 口径(1 跳直接表达式)
    algo_candidates: list[str] = field(default_factory=list)  # 多任务产同列时的候选
    etl_tasks: list[str] = field(default_factory=list)
    defined_in: str | None = None
    status: str | None = None               # 已确认 | 草稿 | 待补
    raw: dict = field(default_factory=dict)

    @property
    def has_algo(self) -> bool:
        return bool(self.algo) and not str(self.algo).startswith("[示例]")

    @classmethod
    def from_dict(cls, d: dict) -> "BaseIndicator":
        known = {f for f in cls.__dataclass_fields__ if f != "raw"}
        return cls(raw=d, **{k: v for k, v in d.items() if k in known})


@dataclass
class Table:
    """C/D 层 · 表节点(Doris/SR 宽表 + 物理源表)。"""
    table: str
    name_cn: str = ""
    engine: str | None = None
    layer: str | None = None
    grain: str | None = None
    domain: str | None = None
    tier: str = "长尾"
    raw: dict = field(default_factory=dict)

    @classmethod
    def from_dict(cls, d: dict) -> "Table":
        known = {f for f in cls.__dataclass_fields__ if f != "raw"}
        return cls(raw=d, **{k: v for k, v in d.items() if k in known})
