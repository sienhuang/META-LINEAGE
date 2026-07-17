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
5. Initialize or inspect the queue with `scripts/failure_queue.py`. Keep these
   append-only records beside the baseline directory:
   - `remediation_state.jsonl`: authoritative latest state of every failure;
   - `verified_cases.jsonl`: self-contained cases successfully revalidated;
   - `unresolved_cases.jsonl`: self-contained cases that could not be repaired
     safely at the minimum reusable scope;
   - `manual_review.jsonl`: backward-compatible subset requiring human review.
6. When resuming, use the original baseline plus the latest state log. Never
   overwrite the baseline audit.

## Process the queue

Repeat until every baseline failure is either `verified`, `unresolved`, or
`manual_review`:

1. Select the next pending root-cause group, preferring higher-count groups,
   then one representative failure. Read
   [failure-taxonomy.md](references/failure-taxonomy.md) before diagnosing.
2. Before any diagnosis, run this mandatory freshness check with the exact
   stored job and column:

   ```bash
   uv run python -m build_lineage build-production-sql \
     --job-id <exact-job-id> \
     --column <column>
   ```

   - If it succeeds with `"validated": true` and the expected target, do not
     analyze the stale baseline error. Record it as `verified` with reason
     `resolved_by_prior_change` and preserve the command output as evidence,
     then select the next pending failure.
   - If it still fails, diagnose the current error, which may differ from the
     baseline error. Preserve both errors as evidence.
   - For `parse_job` failures or a missing column, run the analogous freshness
     check with `show-job --include-sql` and `parse-job
     --include-expressions`. If parsing now succeeds, verify the business job
     with a targeted audit before recording it as resolved.
3. Only after the freshness check confirms a current failure, trace it through
   the shared pipeline beginning at
   `SingleJobProductionBuilder`. Confirm whether audit and the direct command
   truly use the same code path before proposing a fix.
4. Identify the root cause, affected SQL shape, invariants, and counterexamples.
   Search the whole group for at least one structurally different sample.
5. Decide between safe code repair and an unresolved outcome using the gate
   below.

## Continuous-processing invariant

A single unrepairable failure must never end, pause, or return from the overall
remediation task. If the safe-change gate cannot be satisfied after reasonable
diagnosis:

1. Record the exact case immediately as `unresolved`, including the baseline
   error, current reproduced error, diagnosis, evidence, why no minimum-scope
   safe change exists, and a concrete human follow-up when applicable.
2. Confirm that it is excluded from the pending queue.
3. Invoke `next` and continue with the next pending failure without asking the
   user to restart the task.

Do not repeatedly retry or widen a change merely to make one case pass. Continue
until the whole queue has a terminal recorded outcome. Only a queue-wide
infrastructure failure that prevents all remaining freshness checks may block
the run; an individual SQL shape, missing schema, ambiguous intent, or failed
repair attempt is not a queue-wide blocker.

Never start analysis from a baseline error without reproducing it against the
current code. This check prevents failures already covered by an earlier repair
from being diagnosed and fixed twice.

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

If any condition fails, do not change production code. Record `unresolved` with
the original failure, current failure, diagnosis, missing authority or
information, and a concrete human action, then immediately continue to the next
queue item. Use `manual_review` only when the case specifically needs a human
business or data decision; it is also written to `unresolved_cases.jsonl` for a
complete unsuccessful-case ledger. Typical reasons include invalid/ambiguous
SQL, unavailable or contradictory schema, business-semantic choices, engine
behavior requiring runtime data, and a genuine value-source change.

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
   command evidence. This appends the full case to `verified_cases.jsonl`. Do
   not mark the whole category solely from one sample.

If a repair fails a gate, continue diagnosing or revert only the repair's own
changes. Preserve pre-existing user edits.

## Close the run

1. Use `failure_queue.py summary` and require `pending = 0`; `unresolved` and
   manual-review items count as handled but not fixed. Report them separately
   from verified successes.
2. Run a post-baseline full audit into `<run-dir>/final_1`. If it reports new or
   still-current failures, add them to the active queue and process them with
   the same mandatory freshness check and validation gates.
3. After that queue returns to zero, one more full audit may be run into
   `<run-dir>/final_2`. The hard upper limit is **two post-baseline full audit
   rounds total**. Stop early when a round has no failures; never run
   `final_3`.
4. If `final_2` still contains failures, do not start another full scan. Record
   every remaining item in `manual_review.jsonl` with reason
   `full_reaudit_limit_reached`, the latest error, and both audit directories so
   a human can continue deliberately.
5. Compare baseline and latest-final counts. Do not call unresolved items fixed;
   distinguish `verified`, `manual_review`, and failures deferred because the
   two-round cap was reached.
6. Report fixed counts by root cause, remaining manual-review counts, regression
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

python scripts/failure_queue.py ... sync-cases

python scripts/failure_queue.py ... record \
  --job-id job.123_1 --column metric --phase build_production_sql \
  --status verified --reason "narrow UNION star expansion" \
  --evidence "47 unit tests passed" --evidence "exact build validated"

python scripts/failure_queue.py ... record \
  --job-id job.456_0 --column metric --phase build_production_sql \
  --status unresolved --reason "ambiguous business source; no safe minimum-scope repair" \
  --evidence "freshness check still fails" --evidence "two sources provide metric"
```

`verified` appends a self-contained record to `verified_cases.jsonl`.
`unresolved` appends one to `unresolved_cases.jsonl`. Use `manual_review` when
human input is specifically required; it appends to both
`unresolved_cases.jsonl` and `manual_review.jsonl`. State and case logs are
append-only, and the latest `remediation_state.jsonl` event for one failure
identity is authoritative. After recording any unsuccessful case, always run
`next` and keep processing; do not end the task because that case was not fixed.
Run `sync-cases` when resuming an older run to backfill terminal events recorded
before the separate case ledgers existed; it is idempotent and preserves the
append-only logs.
