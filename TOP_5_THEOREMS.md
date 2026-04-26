# Top 5 Theorems

These five theorems have **zero defaxiom dependencies** — they are proved entirely from `defstub`, `defun`, and `defconst` definitions.  An ACL2 reviewer can verify them without accepting any trusted assumptions.

---

## 1. `happy-path-always-effective`

**File**: `hb1384_process_invariants.lisp`

**What it proves**: The complete Article XII pipeline (propose → first passage → election → second passage → publication → submission → voter approval → effective) always reaches the `effective` state, **regardless of any additional events appended to the trace**.

```lisp
(defthm happy-path-always-effective
  (equal (amend-run-trace *state-proposed*
                          (append (list *evt-pass-first*
                                        *evt-hold-election*
                                        *evt-pass-second*
                                        *evt-publish*
                                        *evt-submit-to-voters*
                                        *evt-voter-approve*
                                        *evt-make-effective*)
                                  trailing-events))
         *state-effective*))
```

**Why it matters**: This proves the state machine is structurally sound — once the full pipeline completes, the outcome is locked in.  The quantification over `trailing-events` (an arbitrary list) makes this a genuine universally quantified theorem, not a ground-truth evaluation.

---

## 2. `effective-implies-path-contains-make-effective`

**File**: `hb1384_process_invariants.lisp`

**What it proves**: If any trace from a non-effective starting state reaches the `effective` state, the trace **must contain** the `make-effective` event.  Proved by **induction on the event trace**.

```lisp
(defthm effective-implies-path-contains-make-effective
  (implies (and (not (equal start *state-effective*))
                (equal (amend-run-trace start events) *state-effective*))
           (trace-contains-eventp *evt-make-effective* events))
  :hints (("Goal" :induct (amend-run-trace start events))))
```

**Why it matters**: This is a genuine inductive proof over arbitrary event traces — the hallmark of serious ACL2 theorem proving.  It proves that the `effective` outcome cannot be reached through any shortcut or skip.

---

## 3. `neutrality-legal-referral-reduces-to-stubs`

**File**: `hb1384_consistency_check.lisp`

**What it proves**: The `legal-referral-conditionp` predicate is **structurally equivalent** (`iff`) to the conjunction of its 12 constituent `defstub` predicates.  Since defstubs are unconstrained, neither `legal-referral-conditionp` nor its negation is provable from the core alone.

```lisp
(defthm neutrality-legal-referral-reduces-to-stubs
  (iff (legal-referral-conditionp amend elec ballot)
       (and (implies (first-passage-challenged-as-voidp amend)
                     (void-challenge-survivablep amend))
            (general-electionp elec)
            (election-after-first-passagep amend elec)
            (intervening-election-qualifiesp amend elec)
            (second-passage-after-electionp amend elec)
            (ninety-day-rule-satisfiedp amend)
            (notice-satisfiedp amend)
            (implies (temporal-window-materialp amend)
                     (ballot-discloses-temporal-limitp ballot))
            (implies (trigger-condition-materialp amend)
                     (ballot-discloses-trigger-conditionp ballot))
            (single-object-satisfiedp amend)
            (implies (richmond-exclusive-venuep amend)
                     (venue-centralization-permittedp amend))
            (implies (venue-transfers-pending-casesp amend)
                     (transfer-pending-cases-permittedp amend)))))
```

**Why it matters**: This is the formal neutrality proof — it demonstrates that the model is genuinely undetermined until interpretive assumptions are imported.

---

## 4. `terminal-state-exclusive`

**File**: `hb1384_process_invariants.lisp`

**What it proves**: The three terminal states (`effective`, `invalid`, `voter-rejected`) are mutually exclusive — a state is exactly one of the three, never two simultaneously.

```lisp
(defthm terminal-state-exclusive
  (implies (amend-terminal-statep s)
           (or (and (equal s *state-effective*)
                    (not (equal s *state-invalid*))
                    (not (equal s *state-rejected*)))
               (and (equal s *state-invalid*)
                    (not (equal s *state-effective*))
                    (not (equal s *state-rejected*)))
               (and (equal s *state-rejected*)
                    (not (equal s *state-effective*))
                    (not (equal s *state-invalid*))))))
```

**Why it matters**: Mutual exclusivity of outcomes is a fundamental correctness property of any legal process model.

---

## 5. `invalid-implies-path-contains-invalidate`

**File**: `hb1384_process_invariants.lisp`

**What it proves**: If any trace from a non-invalid starting state reaches the `invalid` state, the trace **must contain** the `invalidate` event.  Proved by **induction on the event trace**.

```lisp
(defthm invalid-implies-path-contains-invalidate
  (implies (and (not (equal start *state-invalid*))
                (equal (amend-run-trace start events) *state-invalid*))
           (trace-contains-eventp *evt-invalidate* events))
  :hints (("Goal" :induct (amend-run-trace start events))))
```

**Why it matters**: This proves that invalidation is always **traceable** — it cannot occur silently or through an unexpected path.  Combined with theorem #2, it shows that both outcomes (effective and invalid) have mandatory causal events in every reaching trace.
