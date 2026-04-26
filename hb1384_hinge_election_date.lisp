(in-package "ACL2")

(include-book "hb1384_facts")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_hinge_election_date.lisp  —  v2.0
;; Split hinge: election "occurrence" date interpretation.
;;
;; Article XII requires referral after "the next general election of
;; members of the House of Delegates."  When does the election "occur"?
;;
;; Semantic A (Challenger): The election functionally "occurs" when
;;   voters begin casting ballots (early voting start: day 627).
;;   Under the challenger's 90-day calculation, submission at day 795
;;   is only 49 days after final passage (day 746), violating the
;;   90-day rule.
;;
;; Semantic B (Commonwealth): The election "occurs" on official
;;   election day (day 673).  The submission date is election day
;;   (day 841), which is 95 days after final passage (day 746),
;;   satisfying the 90-day rule.
;;
;; Source: Virginia Supreme Court order, pp. 5-6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; Shared date-arithmetic helper
;;; =========================================================================

;; day-difference: returns (d2 - d1)
;; Used for the 90-day rule check.
(defun day-difference (d1 d2)
  (- d2 d1))

;;; =========================================================================
;;; SEMANTIC A: Election occurs at early voting (Challenger theory)
;;; =========================================================================

(encapsulate
  ((challenger-election-occurrence-is-early-votingp (elec) t)
   (challenger-submission-is-early-votingp (ballot) t))

  ;; ---- Witness model ----
  (local (defun challenger-election-occurrence-is-early-votingp (elec)
    (declare (ignore elec)) t))
  (local (defun challenger-submission-is-early-votingp (ballot)
    (declare (ignore ballot)) t))

  ;; ---- Exported constraints ----
  ;; INTERPRETATION_CHALLENGER: The election "occurs" for Article XII
  ;; purposes when early voting begins — when voters first have the
  ;; opportunity to cast ballots, the electoral event has commenced.
  (defthm challenger-election-date-rule
    (implies (electionp elec)
             (challenger-election-occurrence-is-early-votingp elec)))

  ;; INTERPRETATION_CHALLENGER: The amendment is "submitted to voters"
  ;; when the referendum voting period opens (early voting start),
  ;; not on official election day.
  (defthm challenger-submission-date-rule
    (implies (ballotreferencep ballot)
             (challenger-submission-is-early-votingp ballot))))

;; Under Semantic A: The 90-day rule FAILS.
;; Final passage: day 746.  Submission (early voting): day 795.
;; Difference: 795 - 746 = 49 days.  49 < 90.
(defthm hinge-election-date-challenger-90-day-fails
  (< (day-difference 746 795) 90))

;;; =========================================================================
;;; SEMANTIC B: Election occurs on election day (Commonwealth theory)
;;; =========================================================================

(encapsulate
  ((commonwealth-election-occurrence-is-election-dayp (elec) t)
   (commonwealth-submission-is-election-dayp (ballot) t))

  ;; ---- Witness model ----
  (local (defun commonwealth-election-occurrence-is-election-dayp (elec)
    (declare (ignore elec)) t))
  (local (defun commonwealth-submission-is-election-dayp (ballot)
    (declare (ignore ballot)) t))

  ;; ---- Exported constraints ----
  ;; INTERPRETATION_COMMONWEALTH: The election "occurs" on the official
  ;; election day — early voting is merely a convenience mechanism,
  ;; not the constitutional event.
  (defthm commonwealth-election-date-rule
    (implies (electionp elec)
             (commonwealth-election-occurrence-is-election-dayp elec)))

  ;; INTERPRETATION_COMMONWEALTH: The amendment is "submitted to voters"
  ;; on the official referendum election day.
  (defthm commonwealth-submission-date-rule
    (implies (ballotreferencep ballot)
             (commonwealth-submission-is-election-dayp ballot))))

;; Under Semantic B: The 90-day rule PASSES.
;; Final passage: day 746.  Submission (election day): day 841.
;; Difference: 841 - 746 = 95 days.  95 >= 90.
(defthm hinge-election-date-commonwealth-90-day-passes
  (>= (day-difference 746 841) 90))
