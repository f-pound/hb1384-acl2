(in-package "ACL2")

(include-book "hb1384_facts")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_challenger_model.lisp  —  v2.0 (hybrid encapsulate architecture)
;; Interpretive model favoring constitutional challenge to HB1384.
;;
;; Architecture:
;;   • Interpretive predicates introduced via encapsulate with local
;;     witness functions — this proves their constraints are consistent
;;   • Scenario ground facts use defaxiom (constraining existing defstubs)
;;   • Proof obligations use defthm with intermediate lemmas
;;
;; Theory of the case: The challenger argues that HB1384 is an illegal
;; referral because:
;;   (a) The first passage is void ab initio (P1 fails)
;;   (b) The 90-day rule is violated under early-voting submission (P4 fails)
;;   (c) Section 30-13 notice is strictly mandatory (P5 fails)
;;   (d) The ballot omits material temporal/trigger limitations (P6 fails)
;;   (e) Combining Article II + Schedule violates single object (P7 fails)
;;   (f) Venue centralization is an independent constitutional defect (P8 fails)
;;
;; Source: Virginia Supreme Court order, pp. 5-6 (plaintiff's arguments)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; Interpretive predicates — introduced via encapsulate
;;;
;;; These are the predicates whose consistency we want to guarantee.
;;; The encapsulate introduces them with a concrete witness model
;;; that demonstrates all exported constraints are jointly satisfiable.
;;; =========================================================================

(encapsulate
  ;; Constrained function signatures (new to this model)
  ((challenger-void-dispositivep (amend) t)
   (challenger-notice-mandatoryp (amend) t)
   (challenger-temporal-materialp (amend) t)
   (challenger-trigger-materialp (amend) t)
   (challenger-multi-objectp (amend) t)
   (challenger-venue-impermissiblep (amend) t)
   (challenger-transfer-impermissiblep (amend) t)
   (challenger-90-day-violatedp (amend) t))

  ;; ---- Witness model ----
  ;; A toy world where all challenger conditions hold.
  (local (defun challenger-void-dispositivep (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-notice-mandatoryp (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-temporal-materialp (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-trigger-materialp (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-multi-objectp (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-venue-impermissiblep (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-transfer-impermissiblep (amend)
    (declare (ignore amend)) t))
  (local (defun challenger-90-day-violatedp (amend)
    (declare (ignore amend)) t))

  ;; ---- Exported constraints (interpretive rules) ----

  ;; INTERPRETATION_CHALLENGER (P1): Void ab initio is dispositive.
  ;; Doctrinal basis: A legislative act conducted in violation of
  ;; mandatory procedural requirements is void ab initio — it has
  ;; no legal effect and cannot be ratified or cured.
  (defthm challenger-void-rule
    (implies (first-passage-challenged-as-voidp amend)
             (challenger-void-dispositivep amend)))

  ;; INTERPRETATION_CHALLENGER (P4): 90-day rule violated.
  ;; Under the challenger's early-voting submission theory,
  ;; the amendment was submitted only 49 days after final passage.
  (defthm challenger-90-day-rule
    (implies (amendmentp amend)
             (challenger-90-day-violatedp amend)))

  ;; INTERPRETATION_CHALLENGER (P5): Section 30-13 is mandatory.
  ;; The statute required publication; failure to publish is not
  ;; curable and is not merely "directory."
  (defthm challenger-notice-rule
    (implies (not (section-30-13-compliantp amend))
             (challenger-notice-mandatoryp amend)))

  ;; INTERPRETATION_CHALLENGER (P6): Temporal and trigger limitations
  ;; are material for ballot disclosure.
  ;; Any limitation that changes the operative scope of the amendment
  ;; must be disclosed on the ballot.
  (defthm challenger-temporal-material-rule
    (implies (amendment-contains-temporal-windowp amend)
             (challenger-temporal-materialp amend)))

  (defthm challenger-trigger-material-rule
    (implies (amendment-contains-trigger-conditionp amend)
             (challenger-trigger-materialp amend)))

  ;; INTERPRETATION_CHALLENGER (P7): Multi-object violation.
  ;; Combining permanent structural changes (Article II) with specific
  ;; temporary schedule authorizations constitutes multiple objects.
  (defthm challenger-multi-object-rule
    (implies (and (amendment-modifies-article-iip amend)
                  (amendment-modifies-schedulep amend))
             (challenger-multi-objectp amend)))

  ;; INTERPRETATION_CHALLENGER (P8): Venue centralization is
  ;; impermissible — an independent structural defect.
  (defthm challenger-venue-rule
    (implies (richmond-exclusive-venuep amend)
             (challenger-venue-impermissiblep amend)))

  (defthm challenger-transfer-rule
    (implies (venue-transfers-pending-casesp amend)
             (challenger-transfer-impermissiblep amend))))

;;; =========================================================================
;;; Bridge axioms: Connect encapsulate-constrained interpretive
;;; predicates to the core defstub predicates.
;;;
;;; These are defaxiom because they constrain existing defstub functions.
;;; They are safe because they only fire when the encapsulate-constrained
;;; predicates (which ARE consistency-checked) are satisfied.
;;; =========================================================================

;; P1 bridge: void dispositive → void challenge not survivable
(defaxiom challenger-bridge-void
  (implies (challenger-void-dispositivep amend)
           (not (void-challenge-survivablep amend))))

;; P4 bridge: 90-day violated → 90-day rule not satisfied
(defaxiom challenger-bridge-90-day
  (implies (challenger-90-day-violatedp amend)
           (not (ninety-day-rule-satisfiedp amend))))

;; P5 bridge: notice mandatory + non-compliant → notice not satisfied
(defaxiom challenger-bridge-notice
  (implies (challenger-notice-mandatoryp amend)
           (not (notice-satisfiedp amend))))

;; P6 bridges: material → must disclose (via core stub)
(defaxiom challenger-bridge-temporal-material
  (implies (challenger-temporal-materialp amend)
           (temporal-window-materialp amend)))

(defaxiom challenger-bridge-trigger-material
  (implies (challenger-trigger-materialp amend)
           (trigger-condition-materialp amend)))

;; P7 bridge: multi-object → single-object not satisfied
(defaxiom challenger-bridge-single-object
  (implies (challenger-multi-objectp amend)
           (not (single-object-satisfiedp amend))))

;; P8 bridges: impermissible venue/transfer
(defaxiom challenger-bridge-venue
  (implies (challenger-venue-impermissiblep amend)
           (not (venue-centralization-permittedp amend))))

(defaxiom challenger-bridge-transfer
  (implies (challenger-transfer-impermissiblep amend)
           (not (transfer-pending-cases-permittedp amend))))

;;; =========================================================================
;;; Scenario constants — HB1384 referendum
;;;
;;; These use defaxiom because they constrain existing defstub functions.
;;; They are self-evidently consistent stipulations about the specific
;;; scenario facts already established in hb1384_facts.lisp.
;;; =========================================================================

;; SCENARIO_FACT: The intervening election qualifies (challenger concedes
;; sequencing but fails on other grounds)
(defaxiom challenger-scenario-election-qualifies
  (intervening-election-qualifiesp 'hb1384-amendment 'election-2025))

;; SCENARIO_FACT: Second passage occurred after election
(defaxiom challenger-scenario-second-passage-after-election
  (second-passage-after-electionp 'hb1384-amendment 'election-2025))

;;; =========================================================================
;;; Intermediate lemmas — factored proof chain
;;;
;;; These help ACL2's rewriter chain through the encapsulate constraints
;;; and bridge rules to reach the final illegality conclusion.
;;; =========================================================================

;; Step 1: Challenger establishes void is dispositive
(defthm challenger-lemma-void-dispositive
  (challenger-void-dispositivep 'hb1384-amendment))

;; Step 2: First passage is not survivable (P1 fails)
(defthm challenger-lemma-void-not-survivable
  (not (void-challenge-survivablep 'hb1384-amendment)))

;; Step 3: First passage check fails
(defthm challenger-lemma-first-passage-fails
  (not (first-passage-ok-p 'hb1384-amendment)))

;; Step 4: 90-day rule violated (P4 fails)
(defthm challenger-lemma-90-day-violated
  (challenger-90-day-violatedp 'hb1384-amendment))

(defthm challenger-lemma-90-day-not-satisfied
  (not (ninety-day-rule-satisfiedp 'hb1384-amendment)))

;; Step 5: Notice not satisfied (P5 fails)
(defthm challenger-lemma-notice-mandatory
  (challenger-notice-mandatoryp 'hb1384-amendment))

(defthm challenger-lemma-notice-not-satisfied
  (not (notice-satisfiedp 'hb1384-amendment)))

;; Step 6: Single object violated (P7 fails)
(defthm challenger-lemma-multi-object
  (challenger-multi-objectp 'hb1384-amendment))

(defthm challenger-lemma-single-object-fails
  (not (single-object-satisfiedp 'hb1384-amendment)))

;;; =========================================================================
;;; PROOF OBLIGATION 1: General theorem
;;;
;;; Under the challenger's interpretive model, ANY amendment that has
;;; a void-challenged first passage is an illegal referral, regardless
;;; of all other conditions.
;;; =========================================================================

(defthm challenger-illegality-general
  (implies (and (amendmentp amend)
                (first-passage-challenged-as-voidp amend))
           (illegal-referral-conditionp amend elec ballot))
  :hints (("Goal" :in-theory (enable legal-referral-conditionp
                               illegal-referral-conditionp
                               first-passage-ok-p)))
  :rule-classes nil)

;;; =========================================================================
;;; PROOF OBLIGATION 2: Concrete HB1384 corollary
;;;
;;; Under the challenger's model, HB1384 is an illegal referral.
;;; This is the ground-truth instantiation of the general theorem.
;;; =========================================================================

(defthm challenger-illegality-hb1384
  (illegal-referral-conditionp 'hb1384-amendment 'election-2025 'referendum-2026)
  :hints (("Goal" :in-theory (enable legal-referral-conditionp
                               illegal-referral-conditionp
                               first-passage-ok-p
                               ninety-day-rule-ok-p
                               notice-ok-p
                               single-object-ok-p)))
  :rule-classes nil)
