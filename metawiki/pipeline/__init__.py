"""pipeline · 数据构建工具链 —— 把事实源烤成可服务的派生产物。

(对应 chatdoc/rag 的 svr/task_executor: 离线把原料处理成可检索产物。)
全部读写 settings 指定的 KB_ROOT, 复用 metawiki 的领域模型/检索模块, 不另造一套。

  p1_parse_charts.py   chart-index.json → catalog/generated/{metrics,base_indicators}.json
  p2_parse_datasets.py MySQL ba.data_set → catalog/generated/datasets.json(C 层 SQL/宽表血缘)
  p4_extract_tasks.py  MySQL dorado_instance → etl_tasks.json(D 层 ETL 任务的 SQL 抽取)
  p4_build_lineage.py  ETL SQL → column_lineage(D 层列级血缘 + 跨任务多跳追溯)
  extract_metadata.py  数据源 → catalog/tables/*.yaml 初稿(stub)
  build_wiki.py        catalog(四层口径图) → wiki/*.md 自包含知识页
  build_index.py       wiki → index/chunks.json (RAG 检索块)

典型重建顺序: p1 → p2 → p4(extract→lineage) → (extract_metadata) → build_wiki → build_index
"""
