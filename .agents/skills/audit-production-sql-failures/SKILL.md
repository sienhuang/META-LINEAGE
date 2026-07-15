---
name: audit-production-sql-failures
description: Run the build_lineage production-SQL audit to completion, triage failures.jsonl by root cause, make narrowly scoped safe fixes to build-production-sql, verify each affected job and the regression suite, and record unsafe or business-dependent cases for manual review. Use for full or resumed audit-production-sql remediation runs, failure-group analysis, repeated SqlStructureError/sqlglot compatibility work, and requests to keep processing audit failures until none remain unhandled.
---

# Audit Production SQL Failures

Drive an auditable remediation loop from a full baseline scan through a clean
final scan. Treat `failures.jsonl` as the actual failure file even when a user
calls it `failure.json`.

## Start or resume a run

1. Work from the repository root. Inspect `git status` and preserve unrelated
   user changes.
2. For a new run, choose a unique immutable report directory and execute:

   ```bash
   uv run python -m build_lineage audit-production-sql \
     --all-jobs \
     --progress-every 10000 \
     --report-dir build_lineage/audit_runs/remediation_<timestamp>/baseline
   ```

3. During long commands, report concise progress at least once per minute.
4. Read `summary.json`, `failure_groups.json`, `failures.jsonl`, and relevant
   entries in `diagnostics.jsonl`. Do not infer a job from a bare sqlglot
   warning; use the diagnostic context.
5. Initialize or inspect the queue with
   `scripts/failure_queue.py`. Keep `remediation_state.jsonl` and
   `manual_review.jsonl` beside the baseline directory.
6. When resuming, use the original baseline plus the latest state log. Never
   overwrite the baseline audit.

## Process the queue

Repeat until every baseline failure is either `verified` or `manual_review`:

1. Select the next pending root-cause group, preferring higher-count groups,
   then one representative failure. Read
   [failure-taxonomy.md](references/failure-taxonomy.md) before diagnosing.
2. Reproduce with the exact stored job when possible:

   ```bash
   uv run python -m build_lineage build-production-sql \
     --job-id <exact-job-id> \
     --column <column>
   ```

   For `parse_job` failures or a missing column, use `show-job --include-sql`
   and `parse-job --include-expressions` instead.
3. Trace the failure through the shared pipeline beginning at
   `SingleJobProductionBuilder`. Confirm whether audit and the direct command
   truly use the same code path before proposing a fix.
4. Identify the root cause, affected SQL shape, invariants, and counterexamples.
   Search the whole group for at least one structurally different sample.
5. Decide between safe code repair and manual review using the gate below.

Do not skip a failure because it resembles a previously fixed case. Re-run it
and record evidence.

## Safe-change gate

Modify code only when all of these hold:

- The current result is demonstrably a tool limitation or implementation bug,
  not invalid source SQL or unknown business intent.
- The triggering AST/schema shape can be detected narrowly and deterministically.
- Existing supported shapes keep their behavior.
- Ambiguous or inconsistent inputs fail closed with a useful error.
- Trace, generation, and validation share the same normalization when required.
- A focused regression test can express both the failing case and a non-target
  case that must remain unchanged.

Prefer the smallest reusable change in the canonical builder path. Do not add a
job-ID special case, rewrite stored SQL, weaken value-source validation, silently
drop branches, or accept generated SQL merely because it parses.

If any condition fails, do not change production code. Record `manual_review`
with the original failure, diagnosis, missing authority or information, and a
concrete human action. Typical reasons include invalid/ambiguous SQL, unavailable
or contradictory schema, business-semantic choices, engine behavior requiring
runtime data, and a genuine value-source change.

## Validate a code repair

Require every gate below before marking any failure `verified`:

1. Add a focused test that fails before the repair and passes after it. Add a
   non-target or mismatch test for the safety boundary.
2. Run the focused test, then:

   ```bash
   uv run python -m unittest discover -s build_lineage/tests -v
   ```

3. Re-run `build-production-sql` for the exact failure. Require exit code zero,
   `"validated": true`, the expected target and branches, and semantically
   correct `value_sources`.
4. Audit the full business task into a new verification directory so all of its
   statements and columns are checked:

   ```bash
   uv run python -m build_lineage audit-production-sql \
     --job-id <business-job-id> \
     --report-dir <run-dir>/verification/<job-or-group>
   ```

5. For a grouped repair, verify multiple representative jobs when available.
   Compare the verification failures with the baseline group and investigate
   any new failure rather than declaring success.
6. Record each actually revalidated failure as `verified`, including test and
   command evidence. Do not mark the whole category solely from one sample.

If a repair fails a gate, continue diagnosing or revert only the repair's own
changes. Preserve pre-existing user edits.

## Close the run

1. Use `failure_queue.py summary` and require `pending = 0`; manual-review items
   count as handled but not fixed.
2. Run a new full audit into `<run-dir>/final`. If it reports failures not
   represented in the baseline state, add them to the active queue and continue.
3. Compare baseline and final counts. Do not call the run complete while a final
   failure is neither verified nor in `manual_review.jsonl`.
4. Report fixed counts by root cause, remaining manual-review counts, regression
   results, final audit directory, and changed files. Clearly distinguish static
   AST/lineage validation from execution on Hive.

## Queue helper

Run from the skill directory or use its absolute path:

```bash
python scripts/failure_queue.py \
  --failures <run-dir>/baseline/failures.jsonl \
  --state <run-dir>/remediation_state.jsonl \
  summary

python scripts/failure_queue.py ... next

python scripts/failure_queue.py ... record \
  --job-id job.123_1 --column metric --phase build_production_sql \
  --status verified --reason "narrow UNION star expansion" \
  --evidence "47 unit tests passed" --evidence "exact build validated"
```

Use `--status manual_review` to also append a self-contained record to
`manual_review.jsonl`. State logs are append-only so the latest event for one
failure identity is authoritative.
