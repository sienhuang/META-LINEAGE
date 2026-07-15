from __future__ import annotations

import json
import re
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Dict, Optional

from .all_paths import CachingProvenanceReader, ProductionPathEnumerator
from .dependency_graph import ProvenanceReader
from .sql_reconstructor import ProductionSqlReconstructor


SAFE_NAME_RE = re.compile(r"[^A-Za-z0-9_.-]+")


@dataclass
class ProductionSqlSet:
    target_ref: str
    output_dir: str
    path_count: int
    truncated: bool
    generated_sql_count: int = 0
    skipped_incomplete_count: int = 0
    failed_sql_count: int = 0
    manifest_file: str = ""
    paths: list[dict] = field(default_factory=list)

    def as_dict(self) -> dict:
        return asdict(self)


class AllProductionSqlGenerator:
    """Generate one SQL file for every complete enumerated producer path."""

    def __init__(self, reader: ProvenanceReader) -> None:
        self.reader = CachingProvenanceReader(reader)

    def generate(
        self,
        ref: str,
        output_dir: str | Path,
        target_definition_id: Optional[str] = None,
        producer_overrides: Optional[Dict[str, str]] = None,
        max_depth: int = 30,
        max_paths: int = 100,
    ) -> ProductionSqlSet:
        output_path = Path(output_dir).expanduser().resolve()
        output_path.mkdir(parents=True, exist_ok=True)
        enumeration = ProductionPathEnumerator(self.reader).enumerate(
            ref,
            target_definition_id=target_definition_id,
            producer_overrides=producer_overrides,
            max_depth=max_depth,
            max_paths=max_paths,
            include_definitions=False,
        )
        result = ProductionSqlSet(
            target_ref=ref,
            output_dir=str(output_path),
            path_count=enumeration.path_count,
            truncated=enumeration.truncated,
        )
        reconstructor = ProductionSqlReconstructor(self.reader)

        for path in enumeration.paths:
            record = {
                "path_id": path["path_id"],
                "target_definition_id": path["target_definition_id"],
                "complete": path["complete"],
                "job_ids": path["job_ids"],
                "producer_choices": path["producer_choices"],
            }
            if not path["complete"]:
                result.skipped_incomplete_count += 1
                record.update({
                    "sql_status": "skipped_incomplete",
                    "sql_file": None,
                    "unresolved_boundaries": path["unresolved_boundaries"],
                    "warnings": path["warnings"],
                })
                result.paths.append(record)
                continue

            overrides = {
                item["source_field_id"]: item["selected_definition_id"]
                for item in path["producer_choices"]
            }
            try:
                reconstructed = reconstructor.reconstruct(
                    path["target_definition_id"],
                    producer_overrides=overrides,
                    max_depth=max_depth,
                )
                filename = self._filename(path)
                sql_file = output_path / filename
                sql_file.write_text(
                    self._path_header(path) + reconstructed.sql,
                    encoding="utf-8",
                )
            except Exception as exc:
                result.failed_sql_count += 1
                record.update({
                    "sql_status": "failed",
                    "sql_file": None,
                    "error": f"{type(exc).__name__}: {exc}",
                })
            else:
                result.generated_sql_count += 1
                record.update({
                    "sql_status": "generated",
                    "sql_file": filename,
                    "warnings": reconstructed.warnings,
                })
            result.paths.append(record)

        manifest_path = output_path / "manifest.json"
        result.manifest_file = str(manifest_path)
        manifest_path.write_text(
            json.dumps(result.as_dict(), ensure_ascii=False, indent=2, default=str)
            + "\n",
            encoding="utf-8",
        )
        return result

    @staticmethod
    def _filename(path: dict) -> str:
        target = SAFE_NAME_RE.sub("_", path["target_definition_id"])
        return f"path_{path['path_id']:04d}__{target}.sql"

    @staticmethod
    def _path_header(path: dict) -> str:
        lines = [
            f"-- all-production-sql path_id: {path['path_id']}",
            f"-- target_definition_id: {path['target_definition_id']}",
            "-- jobs: " + " -> ".join(path["job_ids"]),
        ]
        for choice in path["producer_choices"]:
            lines.append(
                "-- producer choice: "
                f"{choice['source_field_id']}={choice['selected_definition_id']}"
            )
        return "\n".join(lines) + "\n"
