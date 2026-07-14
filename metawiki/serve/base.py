"""serve.base · 工具基类 + @tool 装饰器(对齐 mock-manus domain/services/tools/base.py)。

把「方法 → 工具」收口成一套声明式约定, 让知识库工具(KnowledgeTools)既能被本仓库的
FastMCP server 包装, 也能被 manus 风格的 Agent 直接 get_tools()(绑定给 LLM)+ invoke() 调用。

与 mock-manus 的唯一区别: 这里的工具是【同步】的(读本地 wiki 页 / 内存图, 无 IO 等待),
故 BaseTool.invoke 为同步; @tool 装饰器与 schema 约定完全一致(OpenAI function calling)。
"""
from __future__ import annotations

import inspect
from typing import Any, Callable, Dict, List

from .tool_result import ToolResult


def tool(
    name: str,
    description: str,
    parameters: Dict[str, Dict[str, Any]],
    required: List[str],
) -> Callable:
    """OpenAI 工具装饰器: 把 name/description/parameters/required 绑成方法上的 schema。"""

    def decorator(func: Callable) -> Callable:
        tool_schema = {
            "type": "function",
            "function": {
                "name": name,
                "description": description,
                "parameters": {
                    "type": "object",
                    "properties": parameters,
                    "required": required,
                },
            },
        }
        func._tool_name = name
        func._tool_description = description
        func._tool_schema = tool_schema
        return func

    return decorator


class BaseTool:
    """基础工具类: 统一管理一个工具集(收集 schema / 判断存在 / 过滤参数后调用)。"""

    name: str = ""

    def __init__(self) -> None:
        self._tools_cache: List[Dict[str, Any]] | None = None

    @classmethod
    def _filter_parameters(cls, method: Callable, kwargs: Dict[str, Any]) -> Dict[str, Any]:
        """剔除 method 签名里没有的参数 —— LLM 产出的入参可能有幻觉字段。"""
        sign = inspect.signature(method)
        return {k: v for k, v in kwargs.items() if k in sign.parameters}

    def get_tools(self) -> List[Dict[str, Any]]:
        """收集本工具集所有已注册工具的 schema(供 LLM 绑定工具), 带缓存。"""
        if self._tools_cache is not None:
            return self._tools_cache
        tools = [
            method._tool_schema
            for _, method in inspect.getmembers(self, inspect.ismethod)
            if hasattr(method, "_tool_schema")
        ]
        self._tools_cache = tools
        return tools

    def has_tool(self, tool_name: str) -> bool:
        """判断工具集下是否存在指定工具。"""
        for _, method in inspect.getmembers(self, inspect.ismethod):
            if getattr(method, "_tool_name", None) == tool_name:
                return True
        return False

    def invoke(self, tool_name: str, **kwargs) -> ToolResult:
        """按工具名 + kwargs 调用工具; 自动过滤多余参数, 统一返回 ToolResult。"""
        for _, method in inspect.getmembers(self, inspect.ismethod):
            if getattr(method, "_tool_name", None) == tool_name:
                filtered = self._filter_parameters(method, kwargs)
                return method(**filtered)
        return ToolResult.fail(f"工具[{tool_name}]未找到")
