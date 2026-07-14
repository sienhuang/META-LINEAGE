"""serve · 服务层 —— 把口径图 + 检索暴露为 AI Agent 可调的工具。

工具架构对齐 mock-manus(domain/services/tools): @tool 声明 OpenAI schema + BaseTool 统一
get_tools()/has_tool()/invoke() + ToolResult 统一返回。故同一套 KnowledgeTools 既能被本仓库
FastMCP server 包装, 也能被 manus 风格 Agent 直接绑定给 LLM 调用。

  base.py         @tool 装饰器 + BaseTool 基类(同步; 收集 schema / 过滤参数后调用)
  tool_result.py  ToolResult[T]: 工具统一返回(success/message/data)
  tools.py        KnowledgeTools: 五个工具的纯实现(不依赖 mcp 库, 可单测/直调)
  mcp_server.py   FastMCP 接线: 把 KnowledgeTools 注册成 MCP 工具并起服务
"""

from .base import BaseTool, tool
from .tool_result import ToolResult
from .tools import KnowledgeTools

__all__ = ["KnowledgeTools", "BaseTool", "tool", "ToolResult"]
