from __future__ import annotations

from dataclasses import asdict, dataclass, field
from enum import Enum
from typing import Any


class DependencyKind(str, Enum):
    VALUE = "value"
    CONTEXT = "context"
    ROWSET = "rowset"
    CONSTANT_BRANCH = "constant_branch"


class BoundaryKind(str, Enum):
    EXTERNAL = "external"
    RECOVERED = "recovered_from_raw_sql"
    UNRESOLVED = "unresolved"


@dataclass(frozen=True)
class TargetColumn:
    job_id: str
    dataset: str
    field: str

    def __post_init__(self) -> None:
        if not self.job_id.strip():
            raise ValueError("job_id must not be empty")
        if "." not in self.dataset:
            raise ValueError("dataset must be schema.table")
        if not self.field.strip() or "." in self.field:
            raise ValueError("field must be one column name")

    @property
    def ref(self) -> str:
        return f"{self.dataset}.{self.field}"

    @classmethod
    def from_ref(cls, job_id: str, ref: str) -> "TargetColumn":
        parts = ref.rsplit(".", 1)
        if len(parts) != 2:
            raise ValueError("target ref must be schema.table.column")
        return cls(job_id=job_id, dataset=parts[0], field=parts[1])


@dataclass(frozen=True)
class SourceDependency:
    dataset: str
    field: str
    kind: DependencyKind
    usage: str = ""


@dataclass(frozen=True)
class Transformation:
    order: int
    output_field: str
    expression_sql: str

    def __post_init__(self) -> None:
        if self.order < 1:
            raise ValueError("transformation order must be >= 1")
        if not self.expression_sql.strip():
            raise ValueError("expression_sql must not be empty")


@dataclass(frozen=True)
class Branch:
    order: int
    expression_sql: str
    kind: DependencyKind
    source_datasets: tuple[str, ...] = ()
    filters: tuple[str, ...] = ()

    def __post_init__(self) -> None:
        if self.order < 1:
            raise ValueError("branch order must be >= 1")
        if self.kind not in {
            DependencyKind.VALUE,
            DependencyKind.ROWSET,
            DependencyKind.CONSTANT_BRANCH,
        }:
            raise ValueError("branch kind must describe value or rowset contribution")


@dataclass
class RelationalContext:
    joins: list[str] = field(default_factory=list)
    filters: list[str] = field(default_factory=list)
    group_by: list[str] = field(default_factory=list)
    windows: list[str] = field(default_factory=list)


@dataclass(frozen=True)
class Boundary:
    kind: BoundaryKind
    dataset: str
    field: str
    reason: str = ""


@dataclass
class ColumnLogic:
    target: TargetColumn
    value_sources: list[SourceDependency] = field(default_factory=list)
    context_sources: list[SourceDependency] = field(default_factory=list)
    rowset_sources: list[SourceDependency] = field(default_factory=list)
    transformations: list[Transformation] = field(default_factory=list)
    branches: list[Branch] = field(default_factory=list)
    relational_context: RelationalContext = field(default_factory=RelationalContext)
    boundaries: list[Boundary] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)

    @property
    def complete(self) -> bool:
        return not any(
            boundary.kind == BoundaryKind.UNRESOLVED
            for boundary in self.boundaries
        )

    def to_dict(self) -> dict[str, Any]:
        value = asdict(self)
        value["target"]["ref"] = self.target.ref
        value["complete"] = self.complete
        return _enum_values(value)


def _enum_values(value: Any) -> Any:
    if isinstance(value, Enum):
        return value.value
    if isinstance(value, dict):
        return {key: _enum_values(item) for key, item in value.items()}
    if isinstance(value, (list, tuple)):
        return [_enum_values(item) for item in value]
    return value

