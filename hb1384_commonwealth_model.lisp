(in-package "ACL2")

(include-book "hb1384_facts")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_commonwealth_model.lisp  —  v2.0 (hybrid encapsulate architecture)
;; Interpretive model favoring constitutional validity of HB1384.
;;
;; Architecture:
;;   • Interpretive predicates introduced via encapsulate with local
;;     witness functions — this proves their constraints are consistent
;;   • Scenario ground facts use defaxiom (constraining existing defstubs)
;;   • Proof obligations use defthm with intermediate lemmas
;;
;; Theory of the case: The Commonwealth argues that HB1384 is a legal
;; referral because:
;;   (a) The void-ab-initio finding is reversible on appeal (P1 holds)
;;   (b) The election "occurred" on election day, satisfying the
;;       90-day rule with 95 days (P4 holds)
;;   (c) Section 30-13 is directory, not mandatory (P5 holds)
;;   (d) Temporal/trigger limitations are not material for ballot (P6 holds)
;;   (e) Article II + Schedule modifications are germane to one object
;;       (redistricting) (P7 holds)
;;   (f) Venue centralization is germane to amendment administration (P8 holds)
;;
;; Source: Virginia Supreme Court order (Commonwealth's position)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; Interpretive predicates — introduced via encapsulate
;;;
;;; The Commonwealth introduces defense predicates that, when all
;;; satisfied, establish that every P1–P8 condition holds.
;;; The encapsulate guarantees these constraints are jointly consistent.
;;; =========================================================================

(encapsulate
  ;; Constrained function signatures (new to this model)
  ((commonwealth-void-survivablep (amend) t)
   (commonwealth-notice-directoryp (amend) t)
   (commonwealth-temporal-nonmaterialp (amend) t)
   (commonwealth-trigger-nonmaterialp (amend) t)
   (commonwealth-single-object-satisfiedp (amend) t)
   (commonwealth-venue-permissiblep (amend) t)
   (commonwealth-transfer-permissiblep (amend) t)
   (commonwealth-90-day-satisfiedp (amend) t))

  ;; ---- Witness model ----
  ;; A toy world where all commonwealth conditions hold.
  (local (defun commonwealth-void-survivablep (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-notice-directoryp (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-temporal-nonmaterialp (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-trigger-nonmaterialp (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-single-object-satisfiedp (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-venue-permissiblep (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-transfer-permissiblep (amend)
    (declare (ignore amend)) t))
  (local (defun commonwealth-90-day-satisfiedp (amend)
    (declare (ignore amend)) t))

  ;; ---- Exported constraints (interpretive rules) ----

  ;; INTERPRETATION_COMMONWEALTH (P1): Void finding is reversible.
  ;; Doctrinal basis: The circuit court's void-ab-initio finding is a
  ;; legal conclusion subject to appellate review. The first passage was
  ;; conducted through regular legislative order; procedural challenges
  ;; are curable, not fatal.
  (defthm commonwealth-void-survivable-rule
    (implies (first-passage-challenged-as-voidp amend)
             (commonwealth-void-survivablep amend)))

  ;; INTERPRETATION_COMMONWEALTH (P4): 90-day rule satisfied.
  ;; Under the Commonwealth's election-day submission theory,
  ;; the amendment was submitted 95 days after final passage.
  (defthm commonwealth-90-day-rule
    (implies (amendmentp amend)
             (commonwealth-90-day-satisfiedp amend)))

  ;; INTERPRETATION_COMMONWEALTH (P5): Section 30-13 is directory.
  ;; HB 1384 retroactively repealed § 30-13. Even if still applicable,
  ;; general notice (e.g., through LIS, press coverage) is sufficient.
  (defthm commonwealth-notice-directory-rule
    (implies (amendmentp amend)
             (commonwealth-notice-directoryp amend)))

  ;; INTERPRETATION_COMMONWEALTH (P6): Temporal/trigger limitations
  ;; are NOT material for ballot disclosure.
  ;; These are implementation details of the redistricting authorization;
  ;; they do not alter the core purpose disclosed on the ballot.
  (defthm commonwealth-temporal-nonmaterial-rule
    (implies (amendmentp amend)
             (commonwealth-temporal-nonmaterialp amend)))

  (defthm commonwealth-trigger-nonmaterial-rule
    (implies (amendmentp amend)
             (commonwealth-trigger-nonmaterialp amend)))

  ;; INTERPRETATION_COMMONWEALTH (P7): Single object satisfied.
  ;; Both Article II and Schedule modifications are germane to the single
  ;; object of redistricting.
  (defthm commonwealth-single-object-rule
    (implies (amendmentp amend)
             (commonwealth-single-object-satisfiedp amend)))

  ;; INTERPRETATION_COMMONWEALTH (P8): Venue centralization permitted.
  ;; The General Assembly holds broad authority to prescribe venue and
  ;; procedures, including channeling related disputes into one forum.
  (defthm commonwealth-venue-permissible-rule
    (implies (amendmentp amend)
             (commonwealth-venue-permissiblep amend)))

  (defthm commonwealth-transfer-permissible-rule
    (implies (amendmentp amend)
             (commonwealth-transfer-permissiblep amend))))

;;; =========================================================================
;;; Bridge axioms: Connect encapsulate-constrained interpretive
;;; predicates to the core defstub predicates.
;;; =========================================================================

;; P1 bridge: void survivable → void challenge survivable in core
(defaxiom commonwealth-bridge-void-survivable
  (implies (commonwealth-void-survivablep amend)
           (void-challenge-survivablep amend)))

;; P4 bridge: 90-day satisfied
(defaxiom commonwealth-bridge-90-day
  (implies (commonwealth-90-day-satisfiedp amend)
           (ninety-day-rule-satisfiedp amend)))

;; P5 bridge: notice directory → notice satisfied regardless of § 30-13
(defaxiom commonwealth-bridge-notice
  (implies (commonwealth-notice-directoryp amend)
           (notice-satisfiedp amend)))

;; P6 bridges: nonmaterial → temporal/trigger windows are NOT material
(defaxiom commonwealth-bridge-temporal-nonmaterial
  (implies (commonwealth-temporal-nonmaterialp amend)
           (not (temporal-window-materialp amend))))

(defaxiom commonwealth-bridge-trigger-nonmaterial
  (implies (commonwealth-trigger-nonmaterialp amend)
           (not (trigger-condition-materialp amend))))

;; P7 bridge: single object satisfied
(defaxiom commonwealth-bridge-single-object
  (implies (commonwealth-single-object-satisfiedp amend)
           (single-object-satisfiedp amend)))

;; P8 bridges: venue and transfer permitted
(defaxiom commonwealth-bridge-venue
  (implies (commonwealth-venue-permissiblep amend)
           (venue-centralization-permittedp amend)))

(defaxiom commonwealth-bridge-transfer
  (implies (commonwealth-transfer-permissiblep amend)
           (transfer-pending-cases-permittedp amend)))

;;; =========================================================================
;;; Scenario constants — HB1384 referendum
;;;
;;; The Commonwealth concedes the factual scenario but reaches a
;;; different conclusion because every interpretive predicate resolves
;;; favorably.
;;; =========================================================================

;; SCENARIO_FACT: The intervening election qualifies
(defaxiom commonwealth-scenario-election-qualifies
  (intervening-election-qualifiesp 'hb1384-amendment 'election-2025))

;; SCENARIO_FACT: Second passage occurred after election
(defaxiom commonwealth-scenario-second-passage-after-election
  (second-passage-after-electionp 'hb1384-amendment 'election-2025))

;;; =========================================================================
;;; Intermediate lemmas — factored proof chain
;;; =========================================================================

;; Step 1: Void challenge is survivable (P1 holds)
(defthm commonwealth-lemma-void-survivable
  (commonwealth-void-survivablep 'hb1384-amendment))

(defthm commonwealth-lemma-first-passage-ok
  (void-challenge-survivablep 'hb1384-amendment))

;; Step 2: 90-day rule satisfied (P4 holds)
(defthm commonwealth-lemma-90-day-satisfied
  (commonwealth-90-day-satisfiedp 'hb1384-amendment))

(defthm commonwealth-lemma-90-day-ok
  (ninety-day-rule-satisfiedp 'hb1384-amendment))

;; Step 3: Notice satisfied (P5 holds)
(defthm commonwealth-lemma-notice-directory
  (commonwealth-notice-directoryp 'hb1384-amendment))

(defthm commonwealth-lemma-notice-ok
  (notice-satisfiedp 'hb1384-amendment))

;; Step 4: Temporal/trigger not material (P6 holds)
(defthm commonwealth-lemma-temporal-nonmaterial
  (commonwealth-temporal-nonmaterialp 'hb1384-amendment))

(defthm commonwealth-lemma-trigger-nonmaterial
  (commonwealth-trigger-nonmaterialp 'hb1384-amendment))

;; Step 5: Single object satisfied (P7 holds)
(defthm commonwealth-lemma-single-object-ok
  (commonwealth-single-object-satisfiedp 'hb1384-amendment))

(defthm commonwealth-lemma-single-object-core
  (single-object-satisfiedp 'hb1384-amendment))

;; Step 6: Venue permitted (P8 holds)
(defthm commonwealth-lemma-venue-ok
  (commonwealth-venue-permissiblep 'hb1384-amendment))

(defthm commonwealth-lemma-transfer-ok
  (commonwealth-transfer-permissiblep 'hb1384-amendment))

;;; =========================================================================
;;; PROOF OBLIGATION 1: General theorem
;;;
;;; Under the Commonwealth's interpretive model, ANY amendment that
;;; satisfies all 8 conditions under this theory is a legal referral.
;;; This is a stronger theorem than the concrete corollary because it
;;; quantifies over arbitrary amendments/elections/ballots.
;;; =========================================================================

(defthm commonwealth-legality-general
  (implies (and (amendmentp amend)
                (first-passage-ok-p amend)
                (next-election-ok-p amend elec)
                (second-passage-ok-p amend elec)
                (ninety-day-rule-ok-p amend)
                (notice-ok-p amend)
                (submission-clause-ok-p amend ballot)
                (single-object-ok-p amend)
                (venue-ok-p amend))
           (legal-referral-conditionp amend elec ballot))
  :hints (("Goal" :in-theory (enable legal-referral-conditionp)))
  :rule-classes nil)

;;; =========================================================================
;;; PROOF OBLIGATION 2: Concrete HB1384 corollary
;;;
;;; Under the Commonwealth's model, HB1384 is a legal referral.
;;; This is the ground-truth instantiation.
;;; =========================================================================

(defthm commonwealth-legality-hb1384
  (legal-referral-conditionp 'hb1384-amendment 'election-2025 'referendum-2026)
  :hints (("Goal" :in-theory (enable legal-referral-conditionp
                               first-passage-ok-p
                               next-election-ok-p
                               second-passage-ok-p
                               ninety-day-rule-ok-p
                               notice-ok-p
                               submission-clause-ok-p
                               single-object-ok-p
                               venue-ok-p)))
  :rule-classes nil)
