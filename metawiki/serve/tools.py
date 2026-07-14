"""serve.tools · 知识库工具集(BaseTool 实现, 与 MCP 协议解耦)。

为什么用工具而非把全部知识塞 prompt: 上千指标/表全塞不现实且贵; Agent 按需调,
只取相关的自包含 wiki 页, 精准又省 token。

工具集对齐 mock-manus 的工具架构: 继承 BaseTool, 用 @tool 声明 OpenAI schema, 统一返回
ToolResult。这样同一套 KnowledgeTools 既能被本仓库 FastMCP server 包装, 也能被 manus 风格
Agent 直接 get_tools()(绑定给 LLM)+ invoke() 调用。

暴露五个工具(两类):
  确定性(口径不能模糊):  get_metric / get_table / trace_lineage  —— 按名精确返回
  RAG(长尾/语义):       search_kb / search_examples             —— 语义召回相关页 / 黄金 SQL
本类不 import mcp, 可被 mcp_server 包装, 也可被测试/脚本直接调用。
"""
from __future__ import annotations

from ..catalog import KnowledgeGraph, loader
from ..nlp import Dealer
from ..utils import read_wiki_page
from .base import BaseTool, tool
from .tool_result import ToolResult


class KnowledgeTools(BaseTool):
    """一次构建(载图 + 载检索块 + 载样例), 复用给所有工具调用。"""

    name: str = "knowledge"

    def __init__(self, graph: KnowledgeGraph | None = None, dealer: Dealer | None = None):
        super().__init__()
        self.graph = graph or KnowledgeGraph.load()
        self.dealer = dealer or Dealer()
        self._examples: list[dict] | None = None   # 懒加载黄金 SQL 样例

    # ---- 确定性工具 --------------------------------------------------------
    @tool(
        name="get_metric",
        description="按指标名精确返回该指标的完整四层口径链(自包含 wiki 页: 业务口径+公式+依赖底层指标+宽表+元信息)。口径问答/写 SQL 时用, 口径不能模糊。",
        parameters={
            "name": {"type": "string", "description": "指标的英文 key, 如 month_avg_activation。先用 search_kb 召回拿到 id。"},
        },
        required=["name"],
    )
    def get_metric(self, name: str) -> ToolResult[str]:
        """确定性: 返回某指标的完整四层口径链(自包含 wiki 页)。"""
        return ToolResult.ok(read_wiki_page("metrics", name))

    @tool(
        name="get_table",
        description="按表名精确返回该表的字段/含哪些底层指标/血缘(自包含 wiki 页)。Text-to-SQL / 数据资产发现时用。",
        parameters={
            "name": {"type": "string", "description": "表名(不带库前缀), 如 dws_mlbb_indicator_wide_1d。"},
        },
        required=["name"],
    )
    def get_table(self, name: str) -> ToolResult[str]:
        """确定性: 返回某表的字段/含哪些指标/血缘。"""
        return ToolResult.ok(read_wiki_page("tables", name))

    @tool(
        name="trace_lineage",
        description="沿四层链回溯, 紧凑返回某指标的完整口径链(公式 A → 底层指标 B → 宽表 C → ETL 算法 D)。需要逐层核对口径来源时用。",
        parameters={
            "metric": {"type": "string", "description": "指标的英文 key, 如 month_avg_activation。"},
        },
        required=["metric"],
    )
    def trace_lineage(self, metric: str) -> ToolResult[str]:
        """确定性: 沿四层链回溯, 紧凑返回口径链。"""
        return ToolResult.ok(self.graph.trace_lineage(metric))

    # ---- RAG 工具 ----------------------------------------------------------
    @tool(
        name="search_kb",
        description="语义召回相关的自包含 wiki 页(指标/表)。不知道确切名字、找表、长尾问题时用; 召回后再用 get_metric/get_table 取完整页。",
        parameters={
            "query": {"type": "string", "description": "自然语言查询, 如 '月均活跃度 怎么算'。"},
            "type_": {"type": "string", "enum": ["metric", "table"], "description": "(可选)只在某类页里召回: metric 指标 | table 表。不传则全召回。"},
            "top_k": {"type": "integer", "description": "(可选)返回条数, 默认 3。"},
        },
        required=["query"],
    )
    def search_kb(self, query: str, type_: str | None = None,
                  top_k: int = 3) -> ToolResult[list[dict]]:
        """RAG: 语义召回相关 wiki 页(可按 type 过滤: metric|table)。返回 id+片段。"""
        hits = self.dealer.search(query, type_=type_, top_k=top_k)
        data = [{"id": h.id, "ref": h.ref, "score": h.score, "preview": h.preview()}
                for h in hits]
        msg = "" if data else "无命中: 换个说法, 或先跑 pipeline 建 index/chunks.json。"
        return ToolResult.ok(data, message=msg)

    @tool(
        name="search_examples",
        description="语义召回黄金 SQL 样例(few-shot)。写 Text-to-SQL 前用: 样例示范了宽表路径 indicator_map['x'] 非标取数, 以及口径由 ETL 保证不必重算。",
        parameters={
            "query": {"type": "string", "description": "自然语言查询, 如 '上个月的月均活跃度 SQL'。"},
            "metric": {"type": "string", "description": "(可选)只召回用到某指标的样例, 传指标英文 key。"},
            "top_k": {"type": "integer", "description": "(可选)返回条数, 默认 3。"},
        },
        required=["query"],
    )
    def search_examples(self, query: str, metric: str | None = None,
                        top_k: int = 3) -> ToolResult[list[dict]]:
        """RAG: 语义召回黄金 SQL 样例。可按 metric 过滤(只取用到该指标的样例)。"""
        pool = self._load_examples()
        if metric:
            pool = [e for e in pool if (e.get("uses") or {}).get("metric") == metric]
        if not pool:
            return ToolResult.ok([], message="无匹配样例(检查 metric 过滤, 或 examples/golden_queries.yaml 为空)。")
        # 复用配置好的 embedding 后端打分(local token 重合 / baai / openai), 与 search_kb 一致。
        texts = [self._example_text(e) for e in pool]
        scores = self.dealer.embedding.similarity(query, texts)
        ranked = sorted(zip(scores, pool), key=lambda x: -x[0])
        data = [self._example_preview(e, round(s, 2)) for s, e in ranked if s > 0][:top_k]
        msg = "" if data else "无命中: 换个说法试试。"
        return ToolResult.ok(data, message=msg)

    # ---- 样例检索的内部实现 ------------------------------------------------
    def _load_examples(self) -> list[dict]:
        """懒加载黄金 SQL 样例(已过滤模板骨架)。"""
        if self._examples is None:
            self._examples = loader.load_examples_raw()
        return self._examples

    @staticmethod
    def _example_text(e: dict) -> str:
        """拼出一个样例的可检索文本: 问题 + 备注 + SQL + 用到的指标/底层指标。"""
        uses = e.get("uses") or {}
        bases = " ".join(uses.get("base_indicators") or [])
        return "\n".join(str(x) for x in [
            e.get("question", ""), e.get("notes", ""), e.get("sql", ""),
            uses.get("metric", ""), bases,
        ])

    @staticmethod
    def _example_preview(e: dict, score: float) -> dict:
        """样例命中的对外结构: 含完整 SQL, 直接作 few-shot 喂 LLM。"""
        return {
            "id": e.get("id"),
            "score": score,
            "question": e.get("question"),
            "path": e.get("path"),
            "dialect": e.get("dialect"),
            "uses": e.get("uses"),
            "sql": e.get("sql"),
            "notes": e.get("notes"),
        }
