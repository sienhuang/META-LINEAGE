create schema if not exists metadata;

-- 约定: 凡是由 SQL 表达式"派生"出来的标识/名称(*_id / *_name / object_name /
-- 表达式列名)一律用 text —— 匿名表达式列(如 AVG(...) /* ... */)派生出的
-- field_name/field_id/expression_id 可达数百字符, varchar(128/255) 装不下。
-- 仅枚举/类型这类天然有界的列保留 varchar。文件末尾的 migration 负责把已存在的
-- 旧表(varchar)就地扩成 text(varchar→text 二进制兼容, 不重写表、不破坏 PK/FK)。

create table if not exists metadata.job (
  job_id varchar(128) primary key,
  job_name text not null,
  engine varchar(64) not null,
  write_mode varchar(64) not null,
  schedule varchar(64),
  owner varchar(128),
  raw_sql text not null,
  description text,
  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp
);

create table if not exists metadata.stage (
  stage_id varchar(128) primary key,
  job_id varchar(128) not null references metadata.job(job_id) on delete cascade,
  stage_name text not null,
  stage_type varchar(32) not null,
  ordinal_no int not null,
  description text,
  is_distinct boolean not null default false,
  unique (job_id, ordinal_no)
);

create table if not exists metadata.dataset (
  dataset_id text primary key,
  job_id varchar(128),
  dataset_name text not null,
  dataset_type varchar(32) not null,
  database_name text,
  object_name text,
  producer_stage_id varchar(128),
  is_materialized boolean not null default false,
  description text,
  foreign key (job_id) references metadata.job(job_id) on delete cascade
);

create table if not exists metadata.field (
  field_id text primary key,
  dataset_id text not null references metadata.dataset(dataset_id) on delete cascade,
  field_name text not null,
  field_role varchar(32) not null,
  expression_id text,
  data_type varchar(64),
  description text,
  unique (dataset_id, field_name)
);

create table if not exists metadata.stage_input (
  id bigint generated always as identity primary key,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  dataset_id text not null references metadata.dataset(dataset_id) on delete cascade,
  input_order int,
  alias text,
  unique (stage_id, dataset_id)
);

create table if not exists metadata.stage_predicate (
  predicate_id text primary key,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  predicate_type varchar(32) not null,
  predicate_sql text not null,
  ordinal_no int not null,
  description text
);

create table if not exists metadata.stage_join (
  join_id text primary key,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  join_type varchar(32) not null,
  left_dataset_id text not null,
  right_dataset_id text not null,
  condition_sql text not null,
  description text
);

create table if not exists metadata.stage_group_by (
  id bigint generated always as identity primary key,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  expression_id text not null,
  ordinal_no int not null,
  unique (stage_id, ordinal_no)
);

create table if not exists metadata.field_expression (
  expression_id text primary key,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  expression_type varchar(32) not null,
  expression_sql text not null,
  source_field_ids text,
  depends_on_expression_ids text,
  description text
);

create table if not exists metadata.field_lineage (
  id bigint generated always as identity primary key,
  target_field_id text not null,
  source_field_id text not null,
  lineage_type varchar(32) not null,
  unique (target_field_id, source_field_id, lineage_type)
);

-- V2 provenance model.  The legacy dataset.producer_stage_id and
-- field.expression_id columns are intentionally kept for compatibility, but
-- they can only represent one producer.  These tables preserve every job's
-- definition when multiple jobs write the same physical table/column.
create table if not exists metadata.dataset_production (
  production_id text primary key,
  dataset_id text not null references metadata.dataset(dataset_id) on delete cascade,
  job_id varchar(128) not null references metadata.job(job_id) on delete cascade,
  stage_id varchar(128) not null references metadata.stage(stage_id) on delete cascade,
  write_mode varchar(64) not null,
  is_materialized boolean not null default false,
  is_current boolean not null default true,
  source_instance_id text,
  created_at timestamp not null default current_timestamp,
  unique (dataset_id, job_id, stage_id)
);

create table if not exists metadata.field_definition (
  definition_id text primary key,
  production_id text not null references metadata.dataset_production(production_id) on delete cascade,
  field_id text not null references metadata.field(field_id) on delete cascade,
  expression_id text references metadata.field_expression(expression_id) on delete cascade,
  expression_sql text,
  expression_type varchar(32),
  ordinal_no int not null,
  unique (production_id, field_id)
);

create table if not exists metadata.field_dependency (
  edge_id text primary key,
  target_definition_id text not null references metadata.field_definition(definition_id) on delete cascade,
  source_field_id text not null references metadata.field(field_id) on delete cascade,
  dependency_type varchar(32) not null,
  lineage_type varchar(32) not null,
  source_ordinal int not null,
  unique (target_definition_id, source_field_id, dependency_type, lineage_type)
);

create table if not exists metadata.semantic_document (
  doc_id varchar(255) primary key,
  doc_type varchar(32) not null,
  title text not null,
  content text not null,
  ref_type varchar(32) not null,
  ref_id text not null,
  keywords text
);

create index if not exists idx_stage_job_id on metadata.stage(job_id);
create index if not exists idx_dataset_job_id on metadata.dataset(job_id);
create index if not exists idx_field_dataset_id on metadata.field(dataset_id);
create index if not exists idx_stage_input_stage_id on metadata.stage_input(stage_id);
create index if not exists idx_stage_predicate_stage_id on metadata.stage_predicate(stage_id);
create index if not exists idx_stage_join_stage_id on metadata.stage_join(stage_id);
create index if not exists idx_field_expression_stage_id on metadata.field_expression(stage_id);
create index if not exists idx_field_lineage_target on metadata.field_lineage(target_field_id);
create index if not exists idx_dataset_production_dataset on metadata.dataset_production(dataset_id);
create index if not exists idx_dataset_production_job on metadata.dataset_production(job_id);
create index if not exists idx_field_definition_field on metadata.field_definition(field_id);
create index if not exists idx_field_dependency_target on metadata.field_dependency(target_definition_id);
create index if not exists idx_field_dependency_source on metadata.field_dependency(source_field_id);

-- ---- migration: 把旧库里仍是 varchar 的派生列就地扩成 text。
-- 用无条件 ALTER(varchar→text 二进制兼容: 不重写表、不破坏 PK/FK/unique; text→text 为空操作),
-- 所以幂等、可重复执行。schema 前缀 metadata. 会被 repository.ensure_schema 替换成真实 schema。
alter table metadata.job             alter column job_name         type text;
alter table metadata.stage           alter column stage_name       type text;
alter table metadata.dataset         alter column dataset_id       type text;
alter table metadata.dataset         alter column dataset_name     type text;
alter table metadata.dataset         alter column database_name    type text;
alter table metadata.dataset         alter column object_name      type text;
alter table metadata.field           alter column field_id         type text;
alter table metadata.field           alter column dataset_id       type text;
alter table metadata.field           alter column field_name       type text;
alter table metadata.field           alter column expression_id    type text;
alter table metadata.stage_input     alter column dataset_id       type text;
alter table metadata.stage_predicate alter column predicate_id     type text;
alter table metadata.stage_join      alter column join_id          type text;
alter table metadata.stage_join      alter column left_dataset_id  type text;
alter table metadata.stage_join      alter column right_dataset_id type text;
alter table metadata.stage_group_by  alter column expression_id    type text;
alter table metadata.field_expression alter column expression_id   type text;
alter table metadata.field_lineage   alter column target_field_id  type text;
alter table metadata.field_lineage   alter column source_field_id  type text;
alter table metadata.semantic_document alter column title          type text;
alter table metadata.semantic_document alter column ref_id         type text;

-- ---- migration: 整条链路 SQL 重建所需的新列(幂等)。
alter table metadata.stage       add column if not exists is_distinct boolean not null default false;
alter table metadata.stage_input add column if not exists alias       text;
