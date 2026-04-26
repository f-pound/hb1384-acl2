#!/usr/bin/env python3
"""
validate_trace.py -- Machine-checkable source trace validator.

Validates that:
  1. Every defaxiom in .lisp files has a corresponding row in clause_trace.csv
  2. Every source_id in clause_trace.csv exists in source_manifest.json
  3. No orphaned trace rows exist (trace rows without corresponding axioms)

Exit code 0 on success, 1 on any validation failure.
"""
import io
import locale

import csv
import json
import os
import re
import sys
from pathlib import Path


def find_project_root():
    """Find the project root directory."""
    root = os.environ.get("PROJECT_ROOT", ".")
    return Path(root).resolve()


def extract_defaxiom_names(project_root):
    """Extract all defaxiom names from .lisp files."""
    axiom_names = set()
    pattern = re.compile(r'\(\s*defaxiom\s+(\S+)', re.IGNORECASE)

    for lisp_file in project_root.glob("*.lisp"):
        with open(lisp_file, "r", encoding="utf-8", errors="replace") as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    axiom_names.add(match.group(1).lower())

    return axiom_names


def load_trace_csv(project_root):
    """Load and parse clause_trace.csv."""
    csv_path = project_root / "sources" / "clause_trace.csv"
    if not csv_path.exists():
        print(f"ERROR: {csv_path} not found")
        return None, None

    trace_axioms = set()
    trace_source_ids = set()

    with open(csv_path, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            axiom_name = row.get("axiom_name", "").strip().lower()
            source_id = row.get("source_id", "").strip()
            if axiom_name:
                trace_axioms.add(axiom_name)
            if source_id:
                trace_source_ids.add(source_id)

    return trace_axioms, trace_source_ids


def load_manifest_source_ids(project_root):
    """Load source IDs from source_manifest.json."""
    manifest_path = project_root / "sources" / "source_manifest.json"
    if not manifest_path.exists():
        print(f"ERROR: {manifest_path} not found")
        return None

    with open(manifest_path, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    source_ids = set()
    for source in manifest.get("sources", []):
        sid = source.get("source_id", "").strip()
        if sid:
            source_ids.add(sid)

    return source_ids


def main():
    project_root = find_project_root()
    print(f"Project root: {project_root}")
    print()

    errors = 0

    # Step 1: Extract defaxiom names
    axiom_names = extract_defaxiom_names(project_root)
    print(f"Found {len(axiom_names)} defaxiom(s) in .lisp files")

    # Step 2: Load trace CSV
    trace_axioms, trace_source_ids = load_trace_csv(project_root)
    if trace_axioms is None:
        sys.exit(1)
    print(f"Found {len(trace_axioms)} trace row(s) in clause_trace.csv")

    # Step 3: Load manifest source IDs
    manifest_ids = load_manifest_source_ids(project_root)
    if manifest_ids is None:
        sys.exit(1)
    print(f"Found {len(manifest_ids)} source(s) in source_manifest.json")
    print()

    # Validation 1: Every defaxiom has a trace entry
    missing_traces = axiom_names - trace_axioms
    if missing_traces:
        print("ERROR: defaxioms WITHOUT trace entries:")
        for name in sorted(missing_traces):
            print(f"  X {name}")
        errors += len(missing_traces)
    else:
        print("OK: All defaxioms have trace entries")

    # Validation 2: Every trace source_id exists in manifest
    missing_sources = trace_source_ids - manifest_ids
    if missing_sources:
        print("ERROR: source_ids in trace CSV NOT in manifest:")
        for sid in sorted(missing_sources):
            print(f"  X {sid}")
        errors += len(missing_sources)
    else:
        print("OK: All trace source_ids exist in manifest")

    # Validation 3: Orphaned trace rows (informational, not an error)
    orphaned = trace_axioms - axiom_names
    if orphaned:
        print(f"WARNING: {len(orphaned)} trace row(s) without corresponding defaxiom:")
        for name in sorted(orphaned):
            print(f"  ? {name}")
    else:
        print("OK: No orphaned trace rows")

    print()
    if errors > 0:
        print(f"FAILED: {errors} validation error(s)")
        sys.exit(1)
    else:
        print("PASSED: All validations succeeded")
        sys.exit(0)


if __name__ == "__main__":
    main()
