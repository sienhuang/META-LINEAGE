from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import List, Optional


class DocumentType(str, Enum):
    SQL_SUMMARY = "sql_summary"
    METRIC_CARD = "metric_card"
    DIMENSION_CARD = "dimension_card"
    SCHEMA_CARD = "schema_card"
    FILTER_CARD = "filter_card"


class DatasetType(str, Enum):
    TABLE = "table"
    VIEW = "view"
    CTE = "cte"
    SUBQUERY = "subquery"
    TEMP = "temp"


class StageType(str, Enum):
    SOURCE = "source"
    TRANSFORM = "transform"
    AGGREGATE = "aggregate"
    JOIN = "join"
    FINAL = "final"


class WriteMode(str, Enum):
    INSERT_OVERWRITE = "insert_overwrite"
    INSERT_INTO = "insert_into"
    CREATE_TABLE_AS = "create_table_as"
    CREATE_VIEW_AS = "create_view_as"
    SELECT_ONLY = "select_only"


class FieldRole(str, Enum):
    METRIC = "metric"
    DIMENSION = "dimension"
    PARTITION = "partition"
    ATTRIBUTE = "attribute"
    JOIN_KEY = "join_key"


class ExpressionType(str, Enum):
    SOURCE_COLUMN = "source_column"
    ALIAS = "alias"
    CASE_WHEN = "case_when"
    FUNCTION = "function"
    AGGREGATION = "aggregation"
    BINARY_OP = "binary_op"
    LITERAL = "literal"
    UNKNOWN = "unknown"


class PredicateType(str, Enum):
    WHERE = "where"
    PARTITION = "partition"
    HAVING = "having"


class LineageType(str, Enum):
    DIRECT = "direct"
    DERIVED = "derived"
    AGGREGATED = "aggregated"


@dataclass
class SemanticDocument:
    doc_id: str
    doc_type: DocumentType
    title: str
    content: str
    ref_type: str
    ref_id: str
    keywords: List[str] = field(default_factory=list)


@dataclass
class Job:
    job_id: str
    job_name: str
    engine: str
    write_mode: WriteMode
    raw_sql: str
    schedule: str = ""
    owner: str = ""
    description: str = ""


@dataclass
class Stage:
    stage_id: str
    job_id: str
    stage_name: str
    stage_type: StageType
    ordinal_no: int
    description: str = ""
    is_distinct: bool = False  # SELECT DISTINCT / UNION(非 ALL) 去重语义; 渲染时还原


@dataclass
class Dataset:
    dataset_id: str
    dataset_name: str
    dataset_type: DatasetType
    producer_stage_id: Optional[str] = None
    job_id: str = ""
    database_name: Optional[str] = None
    object_name: Optional[str] = None
    is_materialized: bool = False
    description: str = ""


@dataclass
class Field:
    field_id: str
    dataset_id: str
    field_name: str
    field_role: FieldRole
    expression_id: Optional[str] = None
    data_type: str = ""
    description: str = ""


@dataclass
class StageInput:
    stage_id: str
    dataset_id: str
    input_order: int
    alias: Optional[str] = None  # 原 SQL 中该关系的别名(FROM/JOIN <ds> AS <alias>); 渲染整条链路 SQL 时用


@dataclass
class StagePredicate:
    predicate_id: str
    stage_id: str
    predicate_type: PredicateType
    predicate_sql: str
    ordinal_no: int
    description: str = ""


@dataclass
class StageJoin:
    join_id: str
    stage_id: str
    join_type: str
    left_dataset_id: str
    right_dataset_id: str
    condition_sql: str
    description: str = ""


@dataclass
class StageGroupBy:
    stage_id: str
    expression_id: str
    ordinal_no: int


@dataclass
class FieldRef:
    field_id: str


@dataclass
class FieldExpression:
    expression_id: str
    stage_id: str
    expression_type: ExpressionType
    expression_sql: str
    source_field_ids: List[str] = field(default_factory=list)
    depends_on_expression_ids: List[str] = field(default_factory=list)
    description: str = ""


@dataclass
class FieldLineage:
    target_field_id: str
    source_field_id: str
    lineage_type: LineageType


@dataclass
class JobModel:
    job: Job
    stages: List[Stage]
    datasets: List[Dataset]
    fields: List[Field]
    stage_inputs: List[StageInput] = field(default_factory=list)
    stage_predicates: List[StagePredicate] = field(default_factory=list)
    stage_joins: List[StageJoin] = field(default_factory=list)
    stage_group_bys: List[StageGroupBy] = field(default_factory=list)
    field_expressions: List[FieldExpression] = field(default_factory=list)
    field_lineage: List[FieldLineage] = field(default_factory=list)
    semantic_documents: List[SemanticDocument] = field(default_factory=list)
    notes: List[str] = field(default_factory=list)

    def dataset(self, dataset_id: str) -> Dataset:
        return next(item for item in self.datasets if item.dataset_id == dataset_id)

    def stage(self, stage_id: str) -> Stage:
        return next(item for item in self.stages if item.stage_id == stage_id)

    def fields_for_dataset(self, dataset_id: str) -> List[Field]:
        return [item for item in self.fields if item.dataset_id == dataset_id]
