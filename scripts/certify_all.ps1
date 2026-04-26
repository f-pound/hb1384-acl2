# certify_all.ps1 — Batch certification for all HB1384 ACL2 books.
# Usage: .\scripts\certify_all.ps1
# Requires: Docker with atwalter/acl2:latest image.

$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$LogDir = Join-Path $ProjectDir "logs\certify"

if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

Write-Host "=== HB1384 ACL2 Book Certification ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectDir"
Write-Host ""

# Layer 0: Clean books (no defaxiom)
$CleanBooks = @(
    "hb1384_core",
    "hb1384_process",
    "hb1384_process_invariants",
    "hb1384_consistency_check"
)

# Layer 1+: Books with defaxiom
$AxiomBooks = @(
    "hb1384_facts",
    "hb1384_hinge_void_challenge",
    "hb1384_hinge_election_date",
    "hb1384_challenger_model",
    "hb1384_commonwealth_model"
)

$total = 0
$passed = 0
$failed = 0

foreach ($book in $CleanBooks) {
    $total++
    Write-Host "--- Certifying: $book (clean) ---" -ForegroundColor Yellow
    $cmd = "(certify-book `"$book`" ?)"
    $logFile = Join-Path $LogDir "$book.log"
    $cmd | docker run --rm -i -v "${ProjectDir}:/work" -w /work atwalter/acl2:latest acl2 2>&1 | Tee-Object -FilePath $logFile
    $certFile = Join-Path $ProjectDir "$book.cert"
    if (Test-Path $certFile) {
        Write-Host "  PASS: $book.cert" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "  FAIL: $book.cert MISSING" -ForegroundColor Red
        $failed++
    }
    Write-Host ""
}

foreach ($book in $AxiomBooks) {
    $total++
    Write-Host "--- Certifying: $book (defaxioms-okp) ---" -ForegroundColor Yellow
    $cmd = "(certify-book `"$book`" ? nil :defaxioms-okp t)"
    $logFile = Join-Path $LogDir "$book.log"
    $cmd | docker run --rm -i -v "${ProjectDir}:/work" -w /work atwalter/acl2:latest acl2 2>&1 | Tee-Object -FilePath $logFile
    $certFile = Join-Path $ProjectDir "$book.cert"
    if (Test-Path $certFile) {
        Write-Host "  PASS: $book.cert" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "  FAIL: $book.cert MISSING" -ForegroundColor Red
        $failed++
    }
    Write-Host ""
}

Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total: $total  Passed: $passed  Failed: $failed"
if ($failed -gt 0) { exit 1 }
