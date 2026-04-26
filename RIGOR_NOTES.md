# Rigor Notes — Architecture Rationale

## Why This Architecture

The HB1384 project uses a **hybrid architecture** combining three ACL2 mechanisms, each chosen for a specific reason:

### 1. `defstub` — Uninterpreted Predicates (core.lisp)

**What**: Declares a function signature without any implementation.  ACL2 knows nothing about the function's behavior — it could return `t` or `nil` for any input.

**Why**: This is the mathematically correct way to represent the **interpretive predicates** (P1–P8) that the challenger and Commonwealth disagree about.  Since we don't know which interpretation a court would adopt, we leave these predicates unconstrained.  This guarantees **genuine neutrality** — ACL2 cannot derive either outcome from the core alone.

**ACL2 reviewer significance**: `defstub` is the standard ACL2 idiom for introducing partially specified functions.  It is used in major ACL2 projects (e.g., processor verification) for components whose behavior is constrained only by downstream axioms or encapsulate blocks.

### 2. `encapsulate` with Local Witnesses — Interpretive Assumptions (model files)

**What**: Introduces new constrained functions.  The `local` block provides a concrete "witness" implementation that proves the constraints are **jointly satisfiable**.  The witness is then erased — only the exported constraints survive.

**Why**: Interpretive predicates (e.g., "void-ab-initio is dispositive," "§ 30-13 is directory") are the primary inconsistency risk.  If we used `defaxiom` for these, there would be no mechanical guarantee that the constraints don't contradict each other.  `encapsulate` with local witnesses provides exactly that guarantee: ACL2 verifies that there exists at least one concrete model satisfying all constraints simultaneously.

**ACL2 reviewer significance**: This is the canonical ACL2 pattern for introducing constrained function theories.  It is used extensively in the ACL2 community books and in industrial verification projects.

### 3. `defaxiom` — Ground Facts and Bridge Rules (facts.lisp, model files)

**What**: Introduces an axiom that ACL2 assumes to be true without proof.  This can potentially introduce inconsistency.

**Why**: Some propositions cannot be proved from defstubs — they are **constraints on** defstubs.  For example, "HB 1384 is an enrolled act" constrains the `enrolled-actp` defstub for the specific input `'hb1384`.  ACL2's `encapsulate` mechanism cannot do this for existing defstubs (only for newly introduced functions).

**Safety argument**: `defaxiom` is safe when used for:
- **Text-derived facts** (self-evidently consistent translations of authoritative source text)
- **Scenario stipulations** (self-evidently consistent descriptions of the specific case)
- **Bridge rules** (one-way implications connecting encapsulate-constrained functions to core defstubs — safe because they only fire when the consistency-checked encapsulate functions are satisfied)

**Where defaxiom is NOT used**: Interpretive predicates.  These are the primary inconsistency risk and are handled exclusively through `encapsulate`.

### Summary

| Mechanism | Used For | Inconsistency Risk | Protection |
|-----------|----------|-------------------|------------|
| `defstub` | Uninterpreted legal predicates | None | Unconstrained by definition |
| `encapsulate` | Interpretive assumptions | Low | Local witness proves consistency |
| `defaxiom` | Text facts, scenarios, bridges | Low (controlled) | Source-traced; only constrains stubs |

## Proof Technique: Induction over Event Traces

The process invariant theorems use ACL2's built-in induction mechanism.  When we write:

```lisp
(defthm effective-implies-path-contains-make-effective
  (implies (and (not (equal start *state-effective*))
                (equal (amend-run-trace start events) *state-effective*))
           (trace-contains-eventp *evt-make-effective* events))
  :hints (("Goal" :induct (amend-run-trace start events))))
```

ACL2 automatically generates an induction scheme from the recursive structure of `amend-run-trace`:
- **Base case**: `events` is empty — the trace stays at `start`, which is not `*state-effective*`, so the hypothesis is false and the theorem holds vacuously.
- **Inductive step**: assume the theorem holds for `(cdr events)` and prove it for `events`.

This is the same induction technique used in major ACL2 projects for verifying properties of recursive processors, protocol state machines, and hardware designs.

## Source Traceability

Every `defaxiom` in the project is traced to an authoritative source via `sources/clause_trace.csv`.  The trace is machine-checkable via `tools/validate_trace.py`, which runs automatically in CI.

This addresses the primary legitimate concern about `defaxiom` usage: **are the assumed facts actually true?**  By linking every axiom to a specific clause in a public legal document, reviewers can verify the factual basis independently.
