"""serve.tool_result · 工具结果统一模型(对齐 mock-manus 的 ToolResult)。

所有知识库工具(get_metric / search_kb / search_examples …)统一返回 ToolResult,
让上层(MCP server / manus 风格 Agent 的 BaseTool.invoke)拿到一致的成功标识 + 数据,
不必每个工具各自约定返回形态。data 为泛型: 可是自包含 wiki 页(str)、命中列表(list)等。
"""
from __future__ import annotations

from typing import Generic, Optional, TypeVar

from pydantic import BaseModel

T = TypeVar("T")


class ToolResult(BaseModel, Generic[T]):
    """工具结果 Domain 模型(参照 mock-manus domain/models/tool_result.py)。"""

    success: bool = True            # 是否成功调用
    message: Optional[str] = ""     # 额外的信息提示(失败原因 / 空命中说明)
    data: Optional[T] = None        # 工具的执行结果/数据

    @classmethod
    def ok(cls, data: T, message: str = "") -> "ToolResult[T]":
        """成功结果的便捷构造。"""
        return cls(success=True, data=data, message=message)

    @classmethod
    def fail(cls, message: str) -> "ToolResult[T]":
        """失败结果的便捷构造。"""
        return cls(success=False, message=message, data=None)
