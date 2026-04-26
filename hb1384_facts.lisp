(in-package "ACL2")

(include-book "hb1384_core")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_facts.lisp  —  v2.0 (hybrid architecture)
;; Text-derived statutory facts only.
;;
;; EVERY axiom in this file must be directly traceable to source text.
;; Allowed labels: TEXT_FACT, PROCEDURAL_FACT, STRUCTURAL_FACT,
;;                 BRIDGE_RULE
;;
;; Do NOT include INTERPRETATION_*, DOCTRINAL_ASSUMPTION, or
;; POLICY_ASSUMPTION in this file.
;;
;; Architecture note:
;;   Text-derived facts use defaxiom because they constrain defstub
;;   predicates already introduced in core.lisp.  ACL2's encapsulate
;;   cannot prove ground facts about defstub functions.
;;   This is SAFE for text-derived facts because they are self-evidently
;;   consistent — they are direct translations of authoritative sources.
;;   The risk of inconsistency lies in INTERPRETIVE axioms, which are
;;   handled via encapsulate in the model files.
;;
;; Sources:
;;   Virginia Constitution, Article XII, § 1
;;   Virginia Constitution, Article IV, § 12
;;   Virginia Constitution, Article II, § 6 (proposed amendment)
;;   Code of Virginia, § 30-13 (repealed by HB 1384)
;;   HB 1384 enrolled act (2026 Session)
;;   Virginia Supreme Court order (2026)
;;   Virginia Department of Elections ballot
;;   Virginia Legislative Information System (LIS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; 1. TEXT_FACT: HB1384 is an enrolled act proposing a constitutional
;;;    amendment via Article XII.
;;; Source: LIS HB 1384, enrolled act text
;;; =========================================================================

(defaxiom text-hb1384-is-enrolled-act
  (enrolled-actp 'hb1384))

(defaxiom text-hb1384-is-amendment
  (amendmentp 'hb1384-amendment))

;;; =========================================================================
;;; 2. PROCEDURAL_FACT: First passage date — 2024-03-11 (day 70)
;;; Source: LIS HB 1384, 2024 Regular Session, House journal
;;; =========================================================================

(defaxiom text-first-passage-date
  (first-passage-datep 'hb1384-amendment 70))

;;; =========================================================================
;;; 3. PROCEDURAL_FACT: Intervening election — 2025 House of Delegates
;;; Source: Virginia Board of Elections; LIS session records
;;;
;;; Date mapping (YYYY-MM-DD → day offset from 2024-01-01):
;;;   2025-09-19 → 627  (early voting begins)
;;;   2025-11-04 → 673  (election day)
;;; =========================================================================

(defaxiom text-intervening-election-exists
  (electionp 'election-2025))

(defaxiom text-intervening-election-is-general
  (general-electionp 'election-2025))

(defaxiom text-intervening-early-voting-date
  (early-voting-start-datep 'election-2025 627))

(defaxiom text-intervening-election-day
  (election-day-datep 'election-2025 673))

;;; =========================================================================
;;; 4. PROCEDURAL_FACT: Second passage / final passage — 2026-01-16
;;;    (day 746)
;;; Source: LIS HB 1384, 2026 Regular Session, House/Senate journals
;;; =========================================================================

(defaxiom text-second-passage-date
  (second-passage-datep 'hb1384-amendment 746))

(defaxiom text-final-passage-date
  (final-passage-datep 'hb1384-amendment 746))

;;; =========================================================================
;;; 5. PROCEDURAL_FACT: Referendum dates
;;;   2026-03-06 → day 795  (early voting begins, 49 days after passage)
;;;   2026-04-21 → day 841  (election day, 95 days after passage)
;;; Source: Virginia Department of Elections, HB 1384 § 2 (ballot date)
;;; =========================================================================

(defaxiom text-referendum-early-voting-date
  (early-voting-start-datep 'referendum-2026 795))

(defaxiom text-referendum-election-day
  (election-day-datep 'referendum-2026 841))

(defaxiom text-referendum-is-ballot-question
  (ballotreferencep 'referendum-2026))

;;; =========================================================================
;;; 6. PROCEDURAL_FACT: First passage judicially challenged as void
;;; Source: Virginia Supreme Court order, p. 5, first bullet — circuit
;;;   court held the first passage was "void ab initio"
;;; =========================================================================

(defaxiom text-first-passage-challenged-as-void
  (first-passage-challenged-as-voidp 'hb1384-amendment))

;;; =========================================================================
;;; 7. PROCEDURAL_FACT: Section 30-13 publication did not occur
;;; Source: Virginia Supreme Court order, p. 5, third bullet — General
;;;   Assembly failed to comply with § 30-13
;;; =========================================================================

(defaxiom text-section-30-13-noncompliant
  (not (section-30-13-compliantp 'hb1384-amendment)))

;;; =========================================================================
;;; 8. STRUCTURAL_FACT: Amendment text properties
;;; Source: HB 1384 enrolled act, proposed Article II, § 6 text and
;;;   Schedule § 6 text (in constitutional_language.txt)
;;; =========================================================================

;; The amendment modifies Article II, § 6 (Apportionment)
(defaxiom text-amend-modifies-article-ii
  (amendment-modifies-article-iip 'hb1384-amendment))

;; The amendment adds to the Schedule (§ 6)
(defaxiom text-amend-modifies-schedule
  (amendment-modifies-schedulep 'hb1384-amendment))

;; The amendment contains a temporal window (2025-01-01 to 2030-10-31)
;; Source: Schedule § 6 — "limited to making such modifications between
;;   January 1, 2025, and October 31, 2030"
(defaxiom text-amend-contains-temporal-window
  (amendment-contains-temporal-windowp 'hb1384-amendment))

;; The amendment contains a trigger condition (another state's action)
;; Source: Article II, § 6 (proposed) — "in the event that any State of
;;   the United States of America conducts a redistricting..."
(defaxiom text-amend-contains-trigger-condition
  (amendment-contains-trigger-conditionp 'hb1384-amendment))

;;; =========================================================================
;;; 9. STRUCTURAL_FACT: Ballot language properties
;;; Source: virginia_april_21_ballot_1103976.pdf (ballot specimen)
;;;
;;; The ballot language omits both the temporal window and the
;;; trigger condition.  The ballot uses broad "restore fairness"
;;; wording without specifying the 2025-2030 limitation or the
;;; conditional trigger.
;;; =========================================================================

(defaxiom text-ballot-omits-temporal-limit
  (not (ballot-discloses-temporal-limitp 'referendum-2026)))

(defaxiom text-ballot-omits-trigger-condition
  (not (ballot-discloses-trigger-conditionp 'referendum-2026)))

;;; =========================================================================
;;; 10. STRUCTURAL_FACT: Venue provision properties
;;; Source: HB 1384 enrolled act, p. 4 — Circuit Court of the City
;;;   of Richmond is exclusive venue; pending cases shall be transferred
;;; =========================================================================

(defaxiom text-richmond-exclusive-venue
  (richmond-exclusive-venuep 'hb1384-amendment))

(defaxiom text-venue-transfers-pending-cases
  (venue-transfers-pending-casesp 'hb1384-amendment))

;;; =========================================================================
;;; 11. BRIDGE_RULE: Election occurred after first passage
;;; Source: Chronological fact — first passage day 70, election day(s)
;;;   627 (early voting) or 673 (election day); both > 70.
;;; NOTE: Whether "occurrence" means early voting or election day is
;;;   an INTERPRETIVE question resolved in model files, not here.
;;;   This bridge rule states only that the election EVENT is after
;;;   the first passage EVENT in calendar order — undisputed.
;;; =========================================================================

(defaxiom text-election-after-first-passage
  (election-after-first-passagep 'hb1384-amendment 'election-2025))
