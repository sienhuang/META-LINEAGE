
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
@Time     : 2026/6/5 13:20
@File     : note.py.py
@Auth     : irishuang
"""

"""
定时调度，怎么搞。本来打算说是使用celery的，这个可以直接在agent的里面添加，需要agent不断的进行循环就行。需要提供接口查看目前agent的执行情况就行了，要注意agent也是要在sandbox里面进行执行的。 启动celery需要另外的操作，不能混在代码里面，作为一谈。

 mysqldump -h 172.31.46.168 -P 9930 -u leap_metadata  -p \
    --no-tablespaces --single-transaction --set-gtid-purged=OFF \
    --where="start_time >= '2026-06-01 00:00:00' AND start_time < '2026-06-02 00:00:00'" \
    SRC_DB dorado_instance > dorado_instance_20260601.sql


  mysql -h 172.31.46.168 -P 9030 -u leap_metadata -p --batch --quick \
    --default-character-set=utf8mb4 leap_metadata \
    -e "SELECT * FROM dorado_instance WHERE start_time >= '2026-06-01 00:00:00' AND start_time < '2026-06-02 00:00:00';" \
    > dorado_instance_20260601.tsv
    

  mysql -h 10.20.103.20 -u root -p -P3307 --local-infile=1 leap_metadata -e "
  LOAD DATA LOCAL INFILE 'dorado_instance_20260601.tsv'
  INTO TABLE dorado_instance
  CHARACTER SET utf8mb4
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;"
  
  
  /Users/huangsien/PycharmProjects/RAG_LINEAGE
  
  
  python -m metawiki.pipeline.p4_build_lineage --trace-table  mt_dwm.dwm_active_role_zone_di  --down


/Users/huangsien/PycharmProjects/MetaWIKI/metawiki/pipeline/extract_metadata.py
"""

"""
https://www.cnblogs.com/OBCE666/articles/19978575
1. 知识的实效性和动态维护
2. 组织结果的复杂性

ebrain -- 直接使用cli的方式获取知识。
https://mp.weixin.qq.com/s?__biz=Mzk3NTE2NzU5NQ==&mid=2247490707&idx=1&sn=19009fcc160aa3f72d280817f980b1d9&scene=21&poc_token=HC-6J2qjWZLSlGJXq5bmFMmCzJvPNQc37u_excJd


Milvus,好选择(你已经在跑了)。M6 内容较多,我拆成两步:M6a(本次)=
 Embedding + 文本分块 + 向量库抽象(Milvus + 内存实现)+ 连通性验证;
 
 M6b(下次)= RRF 混合检索 + 搜索 API + ingest 时自动向量化。

下一步 M6b:RRF 混合检索 + 搜索 API + ingest 自动向量化

todo ；
M8-2 深度研究(Web搜索→综合→自动ingest) （）
MCP能力的支持，需要进行操作。
resovle , auto-resolved 这件事情是怎么操作的。

任务。

✅ M10-1 认证 + 多租户隔离
⬜ M10-1b 前端 moa 登录流程(复刻 mtbi useUserAuth + 请求带 X-MOA-Token)— 切 moa 模式前需要
⬜ M10-2 入库自动向量去重(高相似自动合并 / 中相似进审阅)
⬜ M10-3 并发安全(乐观锁 version → 409 + 修改历史)
⬜ M10-4 配额(按用户计量 token/存储)

search的逻辑

rank 从0开始，
1-bases

如何自动触发。。
1. 文件upload出发
2. source-watch配置触发 。。如果是aws的话其实是可以的，因为有个aws watch 
3. 定时导入。。

用法

- 新建项目时勾「上传后自动生成」,或在项目卡片上随时切换「自动生成」开关。
- 开了之后:上传文件 → 自动排 ingest → 「任务」页看进度 → 知识库出现新页。不用再点「生成」。
- 没开:维持手动(上传 → 点「生成」)。

还有一种:定时导入(原项目的 Scheduled Import)

原项目还有「定时扫外部文件夹自动导入」。服务端要做的话是:一个后台定时任务,周期扫某个目录/对象存储前缀,新文件自动 upload+ingest。这个我没做(需要确定数据源在哪、是否需要)。要的话告诉我数据来源(本地目录?MinIO?),我加上。
是否能够按照不同的文件类型选择不同的llm


todo
1. search 需要处理, （ok了）
2. review之后如何反哺回去的
   比如说review里面的人工重复的，应该如何操作？
   
   直接写wiki页面，
   
    ┌───────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    │     动作      │                                                                   反哺做了什么                                                                   │
    ├───────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
    │ Create Page   │ 用 review 的 title+description 直接写一个新 wiki 页(类型按 review.type 推断:missing-page→concept、contradiction/suggestion→query),更新 index/log │
    ├───────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
    │ Deep Research │ queueResearch(topic, searchQueries) → Web 搜索 → LLM 综合 → 写页 → autoIngest 再抽实体/概念                                                      │
    ├───────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
    │ Save          │ 把 base64 编码的内容写进 wiki/queries/                                                                                                           │
    ├───────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
    │ Delete        │ 删文件                                                                                                                                           │
    ├───────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
    │ Skip          │ 仅标记 resolved
   
   
   
10. query来源的信息要进行测试一下。
10. chat的东西如何保存为wiki也是要看的，除了手动之外。
    问答的东西没有地方保存呢。。
3. scan ？？信息整理？？？(初步OK了)
4. 用户隔离需要进行处理。（初步搞了，和项目绑定。。）
5. linter 的逻辑需要处理。
6. 知识图谱，其实应该是可以被搜索的才对，要不信息太多太乱了。
7. frontmatter 是用来干啥的？
8. 需要把milvus的信息弄到系统上来。要不到时候进行编辑的时候，需要走到milvus也很无语。
9. 文件大小，分析数据大小的准入和准出规则是要有的。
   如果文件太多怎么搞。
11. chat需要可以长期执行的。
12. 感觉token的计算还没处理好的，是不对的。是整体统计的？导入
13. 建表 + 轻量 schema 补丁。生产环境应改用 Alembic 迁移。
15. mcp能力补全。
16. scan任务的并发数量要有控制。要不的话，直接任务就崩掉了。直接要控制任务的并发，如果可以的话，直接操作一个生产和消费。这样是比较合理的。
    要不到时候整体的逻辑会有问题。甚至会出现任务的阻塞。
    而且任务直接操作
    14. 同时导入的压力测试。。
rrf这个东西怎么理解。
17. log需要整体添加。（这是日志log已经搞了）
18。 changlog要添加上来。

还能继续打磨的(可选,非必须)
- 去重质量增强(你标注过的 TODO):按实体名 embedding、LLM 智能合并、按 type 分阈值
- 长文档分块分析(现在超 6 万字符粗暴截断)
- RBAC(你说外部系统接入)
- bundle 代码分割 / 部署(docker-compose)/ 可观测性
- 深度研究 M8-2(接 Web 搜索)

###应该是自进化的知识库


落地分四阶段（都挂在现有代码上）
Phase 1 — 把反馈接回库（补齐 apply 动作）
- 扩 review_apply.py：除 Create Page 外加 合并去重确认 / 更新已有页 / 删除 / 改类型(reroute) / 确认口径/血缘。每个 review 类型的 options 映射到真实变更。
- 新增反馈日志表：每次 resolve + 每次手动 PageRevision(reason=manual) 的 diff 都记下来——这是学习信号的原料。

Phase 2 — 治理记忆（自进化内核）
- 新表 memory：type(glossary|metric-def|entity-rule|lineage|naming) + text + embedding + 来源 + 置信度 + 状态。
- 从反馈日志提炼填充（review 裁决、手动改页、矛盾仲裁）。
- 动态 prompt 注入：build_analysis_prompt_b / 生成 prompt 按源文件 embedding 取 top-K 相关记忆 + 常驻规则拼进去。这是"变聪明"的机关。

Phase 3 — 协调与自清扫
- 每次 ingest 后（+定时）：规则 + LLM 清扫陈旧 review（缺页已建/重复页已删/矛盾已被新证据推翻），重建图谱、重嵌入改动页。
- 血缘升级：把 extract_wikilinks 换成带类型的边（表→任务→表），用分析阶段已抽出的血缘填充——正好治 review_apply.py:66 那个 TODO。

Phase 4 — 度量（让"聪明"可验证）
- 建一组黄金 NL2SQL 问题集 + 指标口径测试集；跟踪 review 解决率、矛盾复发率、entity 精确率。prompt/记忆的变更必须过这关才合入。

顺手的小赢
projects.py 的 PATCH 现在连 schema_md/purpose_md 都不让改——加上就能让 schema/purpose 随项目演进，这是 Phase 2 的前置。
---
我建议从 Phase 1 + Phase 2 的最小切片做起，因为它直接闭合"改库→变聪明"的核心回路：反馈日志表 + 治理记忆表 + 动态 prompt 注入 + 2~3 个新 review apply 动作（合并/更新/确认口径）。
要我把这个最小切片落成代码吗？还是你想先看某一阶段（比如 Phase 2 记忆表的 schema 设计 + prompt 注入的具体实现）的详细方案？
"""

"""
准备初步的测试数据。
1.  metrics 
    fukun的信息，直接获取理解，然后拆分数据，直接入库。
2.  dataset 
3.  etl-task
4.  血缘信息怎么给。
    也是直接数据库获取吧，同时生成数据图谱
5.  表格信息也要准备
    直接从数据库获取吧。。
6. 建一组黄金 NL2SQL 问题集 + 指标口径测试集
   entity 精确率
   prompt的变更

####切换prompt重新生成看一下是什么情况。

文件的解析。。
1. 


使用：mt_ads/ads_gamebi_roger_primary_di_us
     mt_ads/ads_gamebi_roger_primary_di 
  进行测试。

  好的，接下来，看一下其他任务的情况。

  感觉需要执行一个整体的任务情况信息。然后把所有的情况都列出来，然后一个个修复。

  多insert情况。

  todo: 需要做的事
  1. 也需要解析QUERY的情况。
  2. 重点还是需要解析，最后生成SQL？ 还是只是依赖就可以。
  3. owner信息，后面再看吧。
  4. 跨任务的逻辑。一步步追溯。
  5. 其实最后是要追踪血缘的，看这个列用到了来源了哪些，一层层的依赖是什么。 
  

  6.。最终的目的就是为了联动指标，获取sql信息，获取最后指标信息。
     然后可以实现，一层一层的追溯。

  1。不对啊。怎么感觉postgres没有用上。代码解析到哪里了。 
  还有循环select 的情况的sql也要看一下。


"""