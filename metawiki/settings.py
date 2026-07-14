"""metawiki 全局配置 —— 路径 / 可插拔后端开关 / logger。

仿 chatdoc/rag 的 settings.py: 把路径、后端选择、日志集中一处。
运行时模块只从这里取配置, 不各自硬编码路径。环境变量可覆盖, 便于换知识库目录 /
切检索后端而不改代码。
"""
from __future__ import annotations

import logging
import os
import pathlib

# ---- 路径: metawiki(代码) 与 knowledge_base(数据) 解耦 ----------------------
METAWIKI_ROOT = pathlib.Path(__file__).resolve().parent
PROJECT_ROOT = METAWIKI_ROOT.parent


def _load_dotenv(path: pathlib.Path) -> None:
    """把 .env 载入 os.environ(已存在的真实环境变量优先, 不覆盖)。

    优先用 python-dotenv; 没装则走零依赖兜底解析, 保证 settings 永不因缺包而崩。
    """
    try:
        from dotenv import load_dotenv
        load_dotenv(path, override=False)
        return
    except ModuleNotFoundError:
        pass
    if not path.exists():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line[len("export "):]
        key, sep, val = line.partition("=")
        if not sep:
            continue
        key, val = key.strip(), val.strip()
        if len(val) >= 2 and val[0] in "\"'" and val[-1] == val[0]:
            val = val[1:-1]
        os.environ.setdefault(key, val)   # 真实环境变量优先


# 项目根的 .env(可用 BIRAG_ENV_FILE 指到别处); 必须在读取任何配置之前加载。
ENV_FILE = pathlib.Path(os.environ.get("BIRAG_ENV_FILE", PROJECT_ROOT / ".env"))
_load_dotenv(ENV_FILE)

# 知识库(纯数据)就在本项目内; 用 BIRAG_KB_ROOT 覆盖到别处。
KB_ROOT = pathlib.Path(
    os.environ.get("BIRAG_KB_ROOT", PROJECT_ROOT / "knowledge_base")
).resolve()

CATALOG_DIR = KB_ROOT / "catalog"        # 事实源 YAML + generated/*.json
WIKI_DIR = KB_ROOT / "wiki"              # 派生的自包含知识页(给 Agent 喂)
INDEX_DIR = KB_ROOT / "index"            # 检索索引: kb.sqlite(FTS5) + chunks.json(可读副本)
INDEX_DB = INDEX_DIR / "kb.sqlite"       # SQLite FTS5 倒排索引(检索的真正后端)
EXAMPLES_DIR = KB_ROOT / "examples"      # 黄金 SQL 样例

# 前端扫描产物(随包发布的只读数据); 用 BIRAG_CHART_INDEX 覆盖到别处。
DATA_DIR = METAWIKI_ROOT / "data"
CHART_INDEX = pathlib.Path(
    os.environ.get("BIRAG_CHART_INDEX", DATA_DIR / "chart-index.generated.json")
).resolve()   # P1 解析的前端扫描产物

# ---- Postgres: 指标元数据库 metadata_kb (P1 写入目标) ----------------------
# 整串 BIRAG_PG_DSN 优先; 否则用下面分量拼。口令别硬编码, 走环境变量。
PG_DSN = os.environ.get("BIRAG_PG_DSN") or (
    "host={host} port={port} dbname={db} user={user} password={pwd}".format(
        host=os.environ.get("BIRAG_PG_HOST", "localhost"),
        port=os.environ.get("BIRAG_PG_PORT", "5432"),
        db=os.environ.get("BIRAG_PG_DB", "metadata_kb"),
        user=os.environ.get("BIRAG_PG_USER", "postgres"),
        pwd=os.environ.get("BIRAG_PG_PASSWORD", ""),
    )
)
PG_METRICS_TABLE = os.environ.get("BIRAG_PG_METRICS_TABLE", "metrics")
PG_DATASETS_TABLE = os.environ.get("BIRAG_PG_DATASETS_TABLE", "datasets")
PG_ETL_TASKS_TABLE = os.environ.get("BIRAG_PG_ETL_TASKS_TABLE", "etl_tasks")
PG_COLUMN_LINEAGE_TABLE = os.environ.get("BIRAG_PG_COLUMN_LINEAGE_TABLE", "column_lineage")
# P4 · ETL 任务实例所在 schema(dorado_instance)
MYSQL_DORADO_SCHEMA = os.environ.get("BIRAG_MYSQL_DORADO_SCHEMA", "leap_metadata")
# P4 · 完整 JobModel(列级血缘 ER 模型)落库的 Postgres schema
LINEAGE_SCHEMA = os.environ.get("BIRAG_LINEAGE_SCHEMA", "lineage")

# ---- MySQL: BI 元数据库 (P2 · C 层数据集 SQL 来源: ba.data_set) -------------
# 数据集 SQL 与变量都在这里; 只用 ba schema, 不要 ba_cn。口令走 .env。
MYSQL_HOST = os.environ.get("BIRAG_MYSQL_HOST", "10.20.103.20")
MYSQL_PORT = int(os.environ.get("BIRAG_MYSQL_PORT", "3307"))
MYSQL_DB = os.environ.get("BIRAG_MYSQL_DB", "open_api")
MYSQL_USER = os.environ.get("BIRAG_MYSQL_USER", "root")
MYSQL_PASSWORD = os.environ.get("BIRAG_MYSQL_PASSWORD", "")
MYSQL_DATASET_SCHEMA = os.environ.get("BIRAG_MYSQL_DATASET_SCHEMA", "ba")  # 只取 ba

# ---- 可插拔后端选择 (对应 llm/__init__.py 的 provider 工厂) ----------------
# local: 零依赖 token 召回(默认, 立刻能跑); baai/openai: 真实 embedding 向量召回
EMBEDDING_BACKEND = os.environ.get("BIRAG_EMBEDDING", "local")
RERANK_BACKEND = os.environ.get("BIRAG_RERANK", "")        # 空 = 不重排
RETRIEVAL_TOP_K = int(os.environ.get("BIRAG_TOP_K", "3"))

# ---- MCP 服务 --------------------------------------------------------------
MCP_SERVER_NAME = os.environ.get("BIRAG_MCP_NAME", "bi-knowledge")

# ---- logger ----------------------------------------------------------------
# 日志目录(默认项目根 logs/); 用 BIRAG_LOG_DIR 覆盖。
LOG_DIR = pathlib.Path(os.environ.get("BIRAG_LOG_DIR", PROJECT_ROOT / "logs"))
LOG_LEVEL = os.environ.get("BIRAG_LOG_LEVEL", "INFO")
_LOG_FORMAT = "%(asctime)s %(name)s %(levelname)s %(message)s"

logging.basicConfig(level=LOG_LEVEL, format=_LOG_FORMAT)


def getLogger(name: str, filename: str | None = None) -> logging.Logger:
    """metawiki.<name> 的 logger; 传 filename 则同时把日志落到 LOG_DIR/<filename>。

    控制台输出由根 logger(basicConfig)负责; filename 只追加一个 FileHandler,
    重复调用 / 多次 import 不会叠加同一个文件 handler。
    """
    logger = logging.getLogger(f"metawiki.{name}")
    logger.setLevel(LOG_LEVEL)
    if filename:
        LOG_DIR.mkdir(parents=True, exist_ok=True)
        fpath = LOG_DIR / filename
        already = any(
            isinstance(h, logging.FileHandler)
            and getattr(h, "_metawiki_path", None) == str(fpath)
            for h in logger.handlers
        )
        if not already:
            fh = logging.FileHandler(fpath, encoding="utf-8")
            fh.setFormatter(logging.Formatter(_LOG_FORMAT))
            fh._metawiki_path = str(fpath)           # 去重标记
            logger.addHandler(fh)
    return logger


# P1 解析图表指标专用 logger —— 落 logs/parse_chart_metrics.log
PARSE_CHART_LOGGER = getLogger("parse_chart.metrics", "parse_chart_metrics.log")
# P2 解析数据集 SQL 专用 logger —— 落 logs/parse_dataset_sql.log
PARSE_DATASET_LOGGER = getLogger("parse_dataset.sql", "parse_dataset_sql.log")
# P4 解析 ETL 任务 / 列级血缘专用 logger —— 落 logs/parse_etl_lineage.log
PARSE_ETL_LOGGER = getLogger("parse_etl.lineage", "parse_etl_lineage.log")

