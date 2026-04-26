# Proof Tour

This document provides a structured walkthrough of the proof architecture for ACL2 and legal reviewers.  Reading time: approximately 10–15 minutes.

## Positioning

ACL2 does not decide whether HB 1384's referendum is legal or illegal.

ACL2 proves conditional consequences of explicitly formalized legal models.  The value is **assumption exposure**, **process verification**, **source traceability**, and **mechanically checked derivation**.

This project is an example of **A Computational Amicus Brief**: a machine-checkable, source-traced formal argument structure that exposes the assumptions and proof obligations behind competing legal theories.

## Pipeline

```
Public legal sources (Va. Const., HB 1384, Supreme Court order, ballot)
  ↓
source_manifest.json + clause_trace.csv
  ↓
classified ACL2 assumptions (defaxiom with labels)
  ↓
executable process model (defun state machine)
  ↓
trace induction proofs (defthm with induction)
  ↓
challenger/commonwealth conditional conclusions (defthm)
  ↓
computational amicus-style proof report
```

---

## 1. What the Project Proves

- **~50+ theorems** across 9 ACL2 books (all Q.E.D.)
- Under the **challenger's** interpretive model, HB 1384 is an illegal referral — the first passage is void, the 90-day rule is violated, notice failed, the single-object rule is violated, and venue centralization is impermissible.
- Under the **Commonwealth's** interpretive model, HB 1384 is a legal referral — the void finding is reversible, the 90-day rule passes under election-day submission, notice is directory, ballot omissions are immaterial, the modifications are germane to redistricting, and venue centralization is permissible.
- The constitutional outcome **pivots on** 8 interpretive predicates (P1–P8) — each is a `defstub` in the neutral core that neither model constrains from the core alone.
- The Article XII pipeline structurally enforces sequential compliance: effective requires election, election requires first passage, and terminal states are absorbing.
- The process model is genuinely neutral — neither legality nor illegality is derivable from the core vocabulary alone.

## 2. What the Project Does Not Prove

- Whether HB 1384 **is** legal or illegal as a matter of law.
- Whether the circuit court's void-ab-initio finding is correct.
- Whether early voting or election day is the proper "occurrence" date.
- Whether § 30-13 was mandatory or directory.
- Whether the ballot omissions are material.
- Whether venue centralization is germane to redistricting.

## 3. Trusted Base

The project rests on **43 defaxioms** (see `sources/clause_trace.csv`):

| Category | Count | Risk Level |
|---|---|---|
| Text / procedural / structural facts | 23 | Low |
| Scenario facts | 4 | Low |
| Bridge rules | 1 | Low |
| Challenger interpretive assumptions | 8 | Medium |
| Commonwealth interpretive assumptions | 8 | Medium |

Everything else — all defthm theorems, defstub declarations, defun helpers, encapsulate blocks with local witnesses — is proved or consistency-checked by ACL2.

## 4. Source Traceability

Every defaxiom maps to a public legal source:
- **43 trace rows** in `sources/clause_trace.csv`
- **10 authoritative sources** in `sources/source_manifest.json`
- Each row records: axiom name → classification → source_id → section → quoted clause text
- Machine-checkable via `python tools/validate_trace.py`

## 5. Executable Process Model

**File**: `hb1384_process.lisp`

A 10-state, 10-event Article XII amendment pipeline modeled as recursive ACL2 functions:
- States: proposed → first-passed → election-held → second-passed → published → submitted-to-voters → voter-approved / voter-rejected → effective / invalid
- `amend-next-state`: single-step transition function
- `amend-run-trace`: recursive trace executor over arbitrary event lists
- Judicial invalidation modeled as an event that can fire from any non-terminal state

This is genuine executable ACL2 — the state machine runs on any event trace.

## 6. General Process Invariants

**File**: `hb1384_process_invariants.lisp`

Key theorems proved by **induction over event traces**:
- `effective-stays-effective` — once effective, no events change the outcome
- `invalid-stays-invalid` — once invalid, no events change the outcome
- `effective-implies-path-contains-make-effective` — effectiveness requires the make-effective event (induction)
- `invalid-implies-path-contains-invalidate` — invalidity requires the invalidate event (induction)
- `happy-path-always-effective` — the valid path always reaches effective, regardless of trailing events

## 7. Neutrality Proofs

**File**: `hb1384_consistency_check.lisp`

Key theorems:
- `neutrality-all-conditions-yield-legal` — if all 8 stubs are true, legal follows
- `neutrality-failed-notice-yields-illegal` — if any stub fails, illegal follows
- `neutrality-legal-referral-reduces-to-stubs` — the full `iff` expansion showing the outcome depends entirely on uninterpreted stubs

These prove the core model is **genuinely neutral** — the outcome is formally indeterminate until an interpretive model constrains the stubs.

## 8. Hinge Interpretation Models

**Files**: `hb1384_hinge_void_challenge.lisp`, `hb1384_hinge_election_date.lisp`

Two split hinge books isolate the most contested interpretive questions:

### Void Challenge Hinge (P1)
- Semantic A (Challenger): void ab initio is dispositive → first passage fails → illegal
- Semantic B (Commonwealth): void finding is reversible → first passage survives

### Election Date Hinge (P4)
- Semantic A (Challenger): election occurs at early voting (day 627); submission at early voting (day 795); 795 − 746 = 49 < 90 → 90-day rule fails
- Semantic B (Commonwealth): election occurs on election day (day 673); submission at election day (day 841); 841 − 746 = 95 ≥ 90 → 90-day rule passes

## 9. Challenger Conditional Theorem

**File**: `hb1384_challenger_model.lisp`

`challenger-illegality-hb1384`: Under the challenger's 8 interpretive assumptions plus scenario facts, HB 1384 is an illegal referral.  The encapsulate proves that the interpretive rules are jointly consistent.

General theorem `challenger-illegality-general`: For ANY amendment with a void-challenged first passage, the referral is illegal under this model.

## 10. Commonwealth Conditional Theorem

**File**: `hb1384_commonwealth_model.lisp`

`commonwealth-legality-hb1384`: Under the Commonwealth's 8 interpretive assumptions plus scenario facts, HB 1384 is a legal referral.  The encapsulate proves that the interpretive rules are jointly consistent.

General theorem `commonwealth-legality-general`: For ANY amendment satisfying all 8 conditions under this theory, the referral is legal.

## 11. How to Certify Locally

See [CERTIFICATION.md](CERTIFICATION.md) for full instructions.  Quick start:

```bash
git clone https://github.com/f-pound/hb1384-acl2.git
cd hb1384-acl2
./scripts/certify_all.sh    # Linux/macOS
.\scripts\certify_all.ps1   # Windows PowerShell
```
