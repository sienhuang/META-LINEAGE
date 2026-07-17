#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from collections import Counter
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


HANDLED_STATUSES = {"verified", "unresolved", "manual_review"}


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Track remediation state for build_lineage failures.jsonl",
    )
    parser.add_argument("--failures", required=True, type=Path)
    parser.add_argument("--state", required=True, type=Path)
    parser.add_argument("--manual-review-file", type=Path)
    parser.add_argument("--verified-file", type=Path)
    parser.add_argument("--unresolved-file", type=Path)
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("summary")
    subparsers.add_parser("next")
    subparsers.add_parser(
        "sync-cases",
        help="backfill terminal state events into the success/unresolved ledgers",
    )
    record = subparsers.add_parser("record")
    record.add_argument("--job-id", required=True)
    record.add_argument("--column", required=True)
    record.add_argument("--phase", required=True)
    record.add_argument(
        "--status",
        required=True,
        choices=("verified", "unresolved", "manual_review", "pending"),
    )
    record.add_argument("--reason", required=True)
    record.add_argument("--evidence", action="append", default=[])
    record.add_argument("--owner")
    return parser


def _read_jsonl(path: Path, *, missing_ok: bool = False) -> list[dict[str, Any]]:
    if missing_ok and not path.exists():
        return []
    rows: list[dict[str, Any]] = []
    with path.open(encoding="utf-8") as source:
        for line_number, line in enumerate(source, start=1):
            if not line.strip():
                continue
            value = json.loads(line)
            if not isinstance(value, dict):
                raise ValueError(f"{path}:{line_number} is not a JSON object")
            rows.append(value)
    return rows


def _identity(row: dict[str, Any]) -> tuple[str, str | None, str]:
    return str(row["job_id"]), row.get("column"), str(row["phase"])


def _display_identity(row: dict[str, Any]) -> dict[str, Any]:
    job_id, column, phase = _identity(row)
    return {"job_id": job_id, "column": column, "phase": phase}


def _latest_state(rows: list[dict[str, Any]]) -> dict[tuple[str, str | None, str], dict[str, Any]]:
    result: dict[tuple[str, str | None, str], dict[str, Any]] = {}
    for row in rows:
        result[_identity(row)] = row
    return result


def _pending(
    failures: list[dict[str, Any]],
    states: dict[tuple[str, str | None, str], dict[str, Any]],
) -> list[dict[str, Any]]:
    return [
        row for row in failures
        if states.get(_identity(row), {}).get("status") not in HANDLED_STATUSES
    ]


def _group_key(row: dict[str, Any]) -> str:
    return ":".join(str(row.get(key) or "unknown") for key in (
        "phase",
        "category",
        "error_type",
    ))


def _summary(
    failures: list[dict[str, Any]],
    state_rows: list[dict[str, Any]],
) -> dict[str, Any]:
    states = _latest_state(state_rows)
    pending = _pending(failures, states)
    statuses = Counter(
        states.get(_identity(row), {}).get("status", "pending")
        for row in failures
    )
    groups = Counter(_group_key(row) for row in pending)
    verified = statuses.get("verified", 0)
    unsuccessful = statuses.get("unresolved", 0) + statuses.get("manual_review", 0)
    return {
        "failures": len(failures),
        "pending": len(pending),
        "handled": verified + unsuccessful,
        "verified": verified,
        "unsuccessful": unsuccessful,
        "statuses": dict(sorted(statuses.items())),
        "pending_groups": [
            {"signature": signature, "count": count}
            for signature, count in sorted(
                groups.items(),
                key=lambda item: (-item[1], item[0]),
            )
        ],
    }


def _next(
    failures: list[dict[str, Any]],
    state_rows: list[dict[str, Any]],
) -> dict[str, Any]:
    pending = _pending(failures, _latest_state(state_rows))
    if not pending:
        return {"pending": 0, "next": None}
    counts = Counter(_group_key(row) for row in pending)
    signature = min(counts, key=lambda item: (-counts[item], item))
    group = [row for row in pending if _group_key(row) == signature]
    return {
        "pending": len(pending),
        "group": {"signature": signature, "count": len(group)},
        "next": group[0],
    }


def _append(path: Path, row: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as output:
        output.write(json.dumps(row, ensure_ascii=False) + "\n")


def _event_identity(row: dict[str, Any]) -> tuple[Any, ...]:
    return (*_identity(row), row.get("status"), row.get("recorded_at"))


def _sync_case_file(path: Path, events: list[dict[str, Any]]) -> int:
    existing = {
        _event_identity(row)
        for row in _read_jsonl(path, missing_ok=True)
    }
    appended = 0
    for event in events:
        key = _event_identity(event)
        if key in existing:
            continue
        _append(path, event)
        existing.add(key)
        appended += 1
    return appended


def main() -> int:
    args = _parser().parse_args()
    failures = _read_jsonl(args.failures)
    state_rows = _read_jsonl(args.state, missing_ok=True)
    if args.command == "summary":
        result = _summary(failures, state_rows)
    elif args.command == "next":
        result = _next(failures, state_rows)
    elif args.command == "sync-cases":
        verified_path = args.verified_file or (
            args.state.parent / "verified_cases.jsonl"
        )
        unresolved_path = args.unresolved_file or (
            args.state.parent / "unresolved_cases.jsonl"
        )
        result = {
            "verified_file": str(verified_path),
            "verified_appended": _sync_case_file(
                verified_path,
                [row for row in state_rows if row.get("status") == "verified"],
            ),
            "unresolved_file": str(unresolved_path),
            "unresolved_appended": _sync_case_file(
                unresolved_path,
                [
                    row for row in state_rows
                    if row.get("status") in {"unresolved", "manual_review"}
                ],
            ),
        }
    else:
        column = None if args.column in {"-", "null", "None"} else args.column
        wanted = (args.job_id, column, args.phase)
        matches = [row for row in failures if _identity(row) == wanted]
        if len(matches) != 1:
            raise ValueError(
                f"expected one baseline failure for {wanted}, found {len(matches)}"
            )
        event = {
            **matches[0],
            "status": args.status,
            "reason": args.reason,
            "evidence": args.evidence,
            "owner": args.owner,
            "recorded_at": datetime.now(UTC).isoformat(),
        }
        _append(args.state, event)
        case_path = None
        if args.status == "verified":
            case_path = args.verified_file or (
                args.state.parent / "verified_cases.jsonl"
            )
            _append(case_path, event)
        elif args.status in {"unresolved", "manual_review"}:
            case_path = args.unresolved_file or (
                args.state.parent / "unresolved_cases.jsonl"
            )
            _append(case_path, event)
        if args.status == "manual_review":
            manual_path = args.manual_review_file or (
                args.state.parent / "manual_review.jsonl"
            )
            _append(manual_path, event)
        result = {
            "recorded": _display_identity(event),
            "status": args.status,
            "case_file": str(case_path) if case_path else None,
        }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
