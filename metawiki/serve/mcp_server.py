"""serve.mcp_server · FastMCP 接线 —— 把 KnowledgeTools 注册成 MCP 工具并起服务。

运行(stdio, 供 MCP 客户端接入):
    python -m metawiki.serve.mcp_server

无 mcp 库 / 直接想看效果时:
    python -m metawiki.serve.mcp_server --demo
会模拟一次 Agent 问答(search_kb → trace_lineage), 验证四层口径链能取通。
"""
from __future__ import annotations

import sys

from .. import settings
from .tools import KnowledgeTools

logger = settings.getLogger("serve.mcp_server")


def _unwrap(result):
    """把 KnowledgeTools 的 ToolResult 拆成 MCP 客户端要的纯内容(成功→data, 失败→message)。"""
    return result.data if result.success else result.message


def build_server(tools: KnowledgeTools | None = None):
    """构建 FastMCP 实例并注册五个工具。需要 `pip install mcp`。"""
    from mcp.server.fastmcp import FastMCP

    tools = tools or KnowledgeTools()
    mcp = FastMCP(settings.MCP_SERVER_NAME)

    @mcp.tool()
    def get_metric(name: str) -> str:
        """返回某指标的完整四层口径链(自包含)。口径问答/写 SQL 用。"""
        return _unwrap(tools.get_metric(name))

    @mcp.tool()
    def get_table(name: str) -> str:
        """返回某表的字段/含哪些指标/血缘。Text-to-SQL / 资产发现 用。"""
        return _unwrap(tools.get_table(name))

    @mcp.tool()
    def trace_lineage(metric: str) -> str:
        """沿四层链回溯, 紧凑返回口径链(公式→底层指标→宽表→ETL 算法)。"""
        return _unwrap(tools.trace_lineage(metric))

    @mcp.tool()
    def search_kb(query: str, type_: str | None = None, top_k: int = 3) -> list[dict]:
        """语义召回相关 wiki 页(type 可选 metric|table)。返回 id+片段。"""
        return _unwrap(tools.search_kb(query, type_=type_, top_k=top_k))

    @mcp.tool()
    def search_examples(query: str, metric: str | None = None, top_k: int = 3) -> list[dict]:
        """语义召回黄金 SQL 样例(few-shot)。写 Text-to-SQL 前用。可按 metric 过滤。"""
        return _unwrap(tools.search_examples(query, metric=metric, top_k=top_k))

    return mcp


def demo(tools: KnowledgeTools | None = None) -> None:
    """模拟 Agent 收到用户问题后的一次调用链(无需 mcp 库)。"""
    tools = tools or KnowledgeTools()
    print("用户问: 「mlbb 上个月的月均活跃度怎么算？给我能跑的 SQL」\n")

    print("Agent → search_kb('月均活跃度 怎么算', type_='metric'):")
    hits = tools.search_kb("月均活跃度 怎么算", type_="metric").data
    for h in hits:
        print(f"   [{h['score']}] {h['id']}  {h['preview']}…")
    if not hits:
        print("   (无命中: 先跑 pipeline 建 index/chunks.json)")
        return
    top = hits[0]["id"].split("::")[-1]

    print(f"\nAgent → trace_lineage('{top}'):")
    print("─" * 60)
    print(tools.trace_lineage(top).data)
    print("─" * 60)

    print(f"\nAgent → search_examples('上个月 月均活跃度 SQL', metric='{top}'):")
    examples = tools.search_examples("上个月 月均活跃度 SQL", metric=top).data
    if not examples:
        examples = tools.search_examples("月均活跃度 SQL").data   # 退而求其次, 不按 metric 过滤
    for e in examples:
        print(f"   [{e['score']}] {e['id']} ({e['path']}/{e['dialect']})  {e['question']}")
    if examples:
        print("─" * 60)
        print(examples[0]["sql"].rstrip())
        print("─" * 60)

    print("\n↑ Agent 拿自包含口径页 + 黄金 SQL 样例即可作答, 无需再跳 4 个系统。")


def main() -> None:
    if "--demo" in sys.argv:
        demo()
        return
    tools = KnowledgeTools()
    try:
        server = build_server(tools)
    except ImportError:
        print("未安装 mcp 库, 改跑 --demo。真实接入请: uv pip install mcp", file=sys.stderr)
        demo(tools)
        return
    logger.info("启动 MCP server '%s' (stdio)", settings.MCP_SERVER_NAME)
    logger.info("已注册工具: %s", [t["function"]["name"] for t in tools.get_tools()])
    server.run()


if __name__ == "__main__":
    main()
