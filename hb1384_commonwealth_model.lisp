; hb1384_commonwealth_model.lisp
; ACL2 book-style file for the commonwealth model.
; All date constants below are encoded as ordinal day counts
; measured from 2024-01-01 = day 0.

(in-package "ACL2")

;; --- Legal Interpretations (Commonwealth) ---

;; election-occurrence-date
;; Purpose:
;;   Select the date that counts as the legal "occurrence" of the intervening
;;   House election for the Commonwealth's theory.
;; Inputs:
;;   early-voting-date - integer day number for the start of early voting.
;;   election-day      - integer day number for official election day.
;; Output:
;;   Returns an integer day number. Under this theory, the relevant date is the
;;   official election day rather than the early-voting start date.
(defun election-occurrence-date (early-voting-date election-day)
  ;; Commonwealth: the election "occurs" on election day
  (declare (ignore early-voting-date))
  election-day)

;; next-election-ok-p
;; Purpose:
;;   Test whether the intervening House election satisfies the constitutional
;;   sequencing requirement after the amendment's first passage.
;; Inputs:
;;   first-passage-date       - integer day number for the amendment's first passage.
;;   election-occurrence-date - integer day number chosen by election-occurrence-date.
;;   election-type            - symbol describing the election, e.g. 'general.
;; Output:
;;   Returns T if the election occurs after first passage and is treated as a
;;   general election; otherwise returns NIL.
(defun next-election-ok-p (first-passage-date election-occurrence-date election-type)
  ;; Commonwealth: Any general election of the House satisfies Article XII.
  ;; The fact that it was delayed does not change its legal status as the "next general election".
  (and (< first-passage-date election-occurrence-date)
       (equal election-type 'general)))

;; submission-date
;; Purpose:
;;   Select the date that counts as the legal "submission to the voters" date
;;   for the referendum under the Commonwealth's theory.
;; Inputs:
;;   early-voting-date - integer day number for the start of referendum voting.
;;   election-day      - integer day number for the referendum election day.
;; Output:
;;   Returns an integer day number. Under this theory, submission occurs on
;;   election day rather than when early voting begins.
(defun submission-date (early-voting-date election-day)
  ;; Commonwealth: The amendment is "submitted to the voters" on election day,
  ;; not when early voting starts.
  (declare (ignore early-voting-date))
  election-day)

;; ninety-day-rule-ok-p
;; Purpose:
;;   Check whether at least 90 days elapsed between final passage and the legal
;;   submission date used by this model.
;; Inputs:
;;   final-passage-date - integer day number for final legislative passage.
;;   submission-date    - integer day number returned by submission-date.
;; Output:
;;   Returns T if submission occurs on or after day 90 following final passage;
;;   otherwise returns NIL.
(defun ninety-day-rule-ok-p (final-passage-date submission-date)
  ;; Requirement: Published at least 90 days before the election.
  (<= (+ final-passage-date 90) submission-date))

;; notice-ok-p
;; Purpose:
;;   Determine whether the statutory publication / notice requirement is
;;   satisfied under the Commonwealth's theory.
;; Inputs:
;;   published-30-13-p - boolean indicating whether strict Section 30-13
;;                       publication occurred.
;; Output:
;;   Returns T under this theory, because the Commonwealth treats Section 30-13
;;   as directory or otherwise curable rather than strictly mandatory.
(defun notice-ok-p (published-30-13-p)
  ;; Commonwealth: Section 30-13 is directory, not mandatory.
  ;; Alternatively, general notice is sufficient. Thus, failure to strictly comply
  ;; with 30-13 does not invalidate the amendment.
  (declare (ignore published-30-13-p))
  t)

;; single-object-ok-p
;; Purpose:
;;   Check whether the act satisfies the single-object rule under the
;;   Commonwealth's theory.
;; Inputs:
;;   modifies-article-ii-p - boolean indicating whether the act modifies Article II.
;;   modifies-schedule-p   - boolean indicating whether the act modifies the Schedule.
;; Output:
;;   Returns T under this theory, because the Commonwealth treats both changes as
;;   germane to one general object: redistricting.
(defun single-object-ok-p (modifies-article-ii-p modifies-schedule-p)
  ;; Commonwealth: Modifying an Article and adding to a Schedule is permissible
  ;; as long as both changes are germane to the single object of redistricting.
  (declare (ignore modifies-article-ii-p modifies-schedule-p))
  t)

;; material-temporal-limit-p
;; Purpose:
;;   Determine whether the amendment contains a material temporal limitation for
;;   ballot-disclosure purposes under the Commonwealth's theory.
;; Inputs:
;;   contains-temporal-window-p  - boolean indicating whether the amendment text
;;                                 contains a time window.
;;   contains-trigger-condition-p - boolean indicating whether the amendment text
;;                                  contains an external trigger condition.
;; Output:
;;   Returns NIL under this theory, because the Commonwealth treats these limits
;;   as non-material to the amendment's general purpose.
(defun material-temporal-limit-p (contains-temporal-window-p contains-trigger-condition-p)
  ;; Commonwealth: Specific schedule limits do not alter the core purpose (redistricting).
  ;; Therefore, they are not "material" for the purposes of the ballot question.
  (declare (ignore contains-temporal-window-p contains-trigger-condition-p))
  nil)

;; material-trigger-condition-p
;; Purpose:
;;   Determine whether the amendment's trigger condition is material for ballot
;;   disclosure purposes under the Commonwealth's theory.
;; Inputs:
;;   contains-temporal-window-p  - boolean indicating whether the amendment text
;;                                 contains a time window.
;;   contains-trigger-condition-p - boolean indicating whether the amendment text
;;                                  contains an external trigger condition.
;; Output:
;;   Returns NIL under this theory, because the Commonwealth treats the trigger
;;   condition as non-material for ballot disclosure.
(defun material-trigger-condition-p (contains-temporal-window-p contains-trigger-condition-p)
  (declare (ignore contains-temporal-window-p contains-trigger-condition-p))
  nil)

;; void-challenge-survivable-p
;; Purpose:
;;   Determine whether the first passage survives a judicial void challenge
;;   under the Commonwealth's theory.
;; Output:
;;   Returns T. Commonwealth doctrine: The circuit court's void-ab-initio finding
;;   is reversible on appeal. The first passage was conducted through regular
;;   legislative order and any procedural challenge is curable, not fatal.
(defun void-challenge-survivable-p ()
  t)

;; second-passage-validp
;; Purpose:
;;   Determine whether the second passage of the amendment occurred after the
;;   intervening House election under the Commonwealth's theory.
;; Inputs:
;;   second-passage-date      - integer day number for the amendment's second passage.
;;   election-occurrence-date - integer day number chosen by election-occurrence-date.
;; Output:
;;   Returns T if second passage occurred after the election; otherwise NIL.
(defun second-passage-validp (second-passage-date election-occurrence-date)
  (< election-occurrence-date second-passage-date))

;; venue-centralization-permitted-p
;; Purpose:
;;   Determine whether mandatory venue centralization is constitutionally permitted.
;; Inputs:
;;   modifies-article-ii-p - boolean
;;   modifies-schedule-p   - boolean
;; Output:
;;   Returns T. Commonwealth doctrine: Venue centralization is germane to the administration
;;   of amendment-related litigation. The General Assembly may channel related disputes
;;   into one forum for consistency.
(defun venue-centralization-permitted-p (modifies-article-ii-p modifies-schedule-p)
  (declare (ignore modifies-article-ii-p modifies-schedule-p))
  t)

;; transfer-pending-cases-permitted-p
;; Purpose:
;;   Determine whether forced transfer of pending cases is constitutionally permitted
;;   in this context.
;; Output:
;;   Returns T. Commonwealth doctrine: The General Assembly holds broad authority
;;   to prescribe venue and procedures, including the transfer of pending cases,
;;   without violating the constitution.
(defun transfer-pending-cases-permitted-p ()
  t)

;; --- Core Structure & Facts ---
(ld "hb1384_core.lisp")
(ld "hb1384_facts.lisp")

;; --- Theorems ---

;; hb1384-legal-under-commonwealth-model
;; Purpose:
;;   State the Commonwealth's top-level theorem: using the shared facts and the
;;   Commonwealth's legal interpretations, HB1384 evaluates as legal.
;; Inputs:
;;   None directly; this theorem is instantiated entirely from shared constants.
;; Output:
;;   A proved ACL2 theorem event.
(defthm hb1384-legal-under-commonwealth-model
  (legal-referral-p
   *first-passage-date*
   *intervening-early-voting-start-date*
   *intervening-election-day*
   *intervening-election-type*
   *final-passage-date*
   *referendum-early-voting-start-date*
   *referendum-election-day*
   *published-30-13-p*
   *amendment-modifies-article-ii-p*
   *amendment-modifies-schedule-p*
   *amendment-contains-temporal-window-p*
   *amendment-contains-trigger-condition-p*
   *ballot-mentions-temporal-window-p*
   *ballot-mentions-trigger-condition-p*
   *richmond-exclusive-venue-p*
   *venue-provision-transfers-pending-cases-p*
   *second-passage-date*
   *first-passage-challenged-as-void-p*))
