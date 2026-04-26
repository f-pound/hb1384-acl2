#!/usr/bin/env bash
# certify_all.sh — Batch certification for all HB1384 ACL2 books.
# Usage: ./scripts/certify_all.sh
# Requires: Docker with atwalter/acl2:latest image.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

ACL2_CMD="docker run --rm -i -v ${PROJECT_DIR}:/work -w /work atwalter/acl2:latest acl2"

echo "=== HB1384 ACL2 Book Certification ==="
echo "Project: ${PROJECT_DIR}"
echo ""

mkdir -p "${PROJECT_DIR}/logs/certify"

# Layer 0: Clean books (no defaxiom)
CLEAN_BOOKS=(
  hb1384_core
  hb1384_process
  hb1384_process_invariants
  hb1384_consistency_check
)

# Layer 1+: Books with defaxiom
AXIOM_BOOKS=(
  hb1384_facts
  hb1384_hinge_void_challenge
  hb1384_hinge_election_date
  hb1384_challenger_model
  hb1384_commonwealth_model
)

total=0
passed=0
failed=0

for book in "${CLEAN_BOOKS[@]}"; do
  total=$((total + 1))
  echo "--- Certifying: ${book} (clean) ---"
  if echo "(certify-book \"${book}\" ?)" | ${ACL2_CMD} 2>&1 | tee "${PROJECT_DIR}/logs/certify/${book}.log" | tail -5; then
    if [ -f "${PROJECT_DIR}/${book}.cert" ]; then
      echo "✅ ${book}.cert"
      passed=$((passed + 1))
    else
      echo "❌ ${book}.cert MISSING"
      failed=$((failed + 1))
    fi
  else
    echo "❌ ${book} FAILED"
    failed=$((failed + 1))
  fi
  echo ""
done

for book in "${AXIOM_BOOKS[@]}"; do
  total=$((total + 1))
  echo "--- Certifying: ${book} (defaxioms-okp) ---"
  if echo "(certify-book \"${book}\" ? nil :defaxioms-okp t)" | ${ACL2_CMD} 2>&1 | tee "${PROJECT_DIR}/logs/certify/${book}.log" | tail -5; then
    if [ -f "${PROJECT_DIR}/${book}.cert" ]; then
      echo "✅ ${book}.cert"
      passed=$((passed + 1))
    else
      echo "❌ ${book}.cert MISSING"
      failed=$((failed + 1))
    fi
  else
    echo "❌ ${book} FAILED"
    failed=$((failed + 1))
  fi
  echo ""
done

echo "=== SUMMARY ==="
echo "Total: ${total}  Passed: ${passed}  Failed: ${failed}"
[ "${failed}" -eq 0 ] || exit 1
