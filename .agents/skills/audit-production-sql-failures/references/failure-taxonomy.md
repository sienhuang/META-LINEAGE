# Failure taxonomy and investigation guide

Use the audit category only as an initial index. Confirm the actual root cause
from raw SQL, AST scopes, metadata, trace, and diagnostics.

| Category or symptom | First checks | Safe repair shape | Manual-review signal |
|---|---|---|---|
| `column_trace_failed` | Projection ordinal, UNION branches, stars, repeated aliases, scope owner | Narrow AST normalization with schema/count checks | Ambiguous source or missing schema |
| `derived_output_missing` | Which parent expression consumes the missing output; star passthrough and pruning requirements | Preserve the proven required projection in its owning scope | SQL truly references a nonexistent output |
| `value_source_mismatch` | Compare expected and generated lineage trees before comparing strings | Fix pruning/alias normalization without weakening equality | Business meaning or source genuinely changes |
| `union_resolution` | Branch count, output count/order, aliases, partitions, constants | Apply one positional contract to every compatible branch | Branches are semantically incompatible |
| `star_resolution` | Qualified vs unqualified star, source count, CTE/join boundaries | Expand only a uniquely resolvable star | Multiple possible sources |
| `static_partition` | Static/dynamic partition split and every top-level UNION branch | Append the same validated static output per branch | Partition intent is inconsistent |
| `sql_parse_failed` / `not_insert` | Engine dialect, stored statement boundaries, comments, unsupported syntax | Parser compatibility only when semantics are unambiguous | Invalid SQL or non-INSERT record |
| sqlglot warning only | Match `diagnostics.jsonl` job/phase/column; see whether an exception followed | Improve scoped handling or diagnostics if behavior is wrong | Harmless warning with successful validation |
| metadata error | Endpoint response, database/table identity, data then partition order, duplicate positions | Cache/error handling or deterministic schema mapping | Service unavailable or schema contradicts SQL |

## Diagnosis checklist

1. Confirm exact job ID versus business job ID and multi-INSERT statement index.
2. Confirm target table, target column ordinal, and static/dynamic partitions.
3. Reduce the SQL shape mentally or in a focused test without losing the failing
   scope relationship.
4. Locate the first wrong internal assumption, not merely the final exception.
5. Check whether the same helper is used by direct build and audit.
6. Search baseline failures for the same category/error fragment and inspect a
   structurally different sample.
7. State invariants the repair must preserve: output names/order, branch count,
   filters/joins/grouping, partitions, and physical value sources.
8. Define a fail-closed boundary for shapes the repair cannot prove safe.

## Required manual-review record

Include:

- exact `job_id`, `column`, `phase`, target table, category, and original error;
- concise diagnosis and why a generic code change is unsafe;
- evidence already collected;
- requested human decision or external action;
- suggested owner when known;
- timestamp and status `manual_review`.
