; hb1384_challenger_model.lisp
; ACL2 book-style file for the challenger model.
; All date constants below are encoded as ordinal day counts
; measured from 2024-01-01 = day 0.

(in-package "ACL2")

;; --- Legal Interpretations (Challenger) ---

;; election-occurrence-date
;; Purpose:
;;   Select the date that counts as the legal "occurrence" of the intervening
;;   House election for the Challenger's theory.
;; Inputs:
;;   early-voting-date - integer day number for the start of early voting.
;;   election-day      - integer day number for official election day.
;; Output:
;;   Returns an integer day number. Under this theory, the relevant date is the
;;   early-voting date because the Challenger treats the election as occurring
;;   when voters first begin casting ballots.
(defun election-occurrence-date (early-voting-date election-day)
  ;; Challenger: The election functionally "occurs" when voters begin casting ballots (early voting)
  (declare (ignore election-day))
  early-voting-date)

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
;; This is a boolean function answers this question:
;; After the first passage of the amendment, did a qualifying House election occur?
;; returns nil or t (false or true)
(defun next-election-ok-p (first-passage-date election-occurrence-date election-type)
  ;; Challenger: A special or delayed election does not satisfy Article XII.
  ;; If we model *intervening-election-scheduled-year-p* as a separate fact, we would use it here.
  ;; Alternatively, they argue it wasn't a true general election.
  ;; For this model, we just show that if it's considered 'special' it fails, but the fact is 'general.
  ;; Let's assume Challenger accepts it was 'general but fails on other grounds.
  (and (< first-passage-date election-occurrence-date)
       (equal election-type 'general)))

;; submission-date
;; Purpose:
;;   Select the date that counts as the legal "submission to the voters" date
;;   for the referendum under the Challenger's theory.
;; Inputs:
;;   early-voting-date - integer day number for the start of referendum voting.
;;   election-day      - integer day number for the referendum election day.
;; Output:
;;   Returns an integer day number. Under this theory, submission occurs when
;;   voting begins, so the early-voting date is returned.
(defun submission-date (early-voting-date election-day)
  ;; Challenger: The amendment is "submitted to the voters" when voting begins
  (declare (ignore election-day))
  early-voting-date)

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
;;   satisfied under the Challenger's theory.
;; Inputs:
;;   published-30-13-p - boolean indicating whether strict Section 30-13
;;                       publication occurred.
;; Output:
;;   Returns the input boolean directly. Under this theory, strict compliance
;;   is mandatory, so notice is valid only if Section 30-13 publication occurred.
(defun notice-ok-p (published-30-13-p)
  ;; Challenger: Section 30-13 publication is strictly mandatory.
  published-30-13-p)

;; single-object-ok-p
;; Purpose:
;;   Check whether the act satisfies the single-object rule under the
;;   Challenger's theory.
;; Inputs:
;;   modifies-article-ii-p - boolean indicating whether the act modifies Article II.
;;   modifies-schedule-p   - boolean indicating whether the act modifies the Schedule.
;; Output:
;;   Returns T only when the model does not treat the combination as a forbidden
;;   multi-object package. Returns NIL when both are present together.
(defun single-object-ok-p (modifies-article-ii-p modifies-schedule-p)
  ;; Challenger: Combining permanent structural changes (Article II) with specific
  ;; temporary schedule authorizations violates the single object rule.
  (not (and modifies-article-ii-p modifies-schedule-p)))

;; material-temporal-limit-p
;; Purpose:
;;   Determine whether the amendment contains a ballot-disclosure-relevant
;;   temporal or conditional limitation under the Challenger's theory.
;; Inputs:
;;   contains-temporal-window-p  - boolean indicating whether the amendment text
;;                                 contains a time window.
;;   contains-trigger-condition-p - boolean indicating whether the amendment text
;;                                  contains an external trigger condition.
;; Output:
;;   Returns T if either kind of limitation exists; otherwise returns NIL.
(defun material-temporal-limit-p (contains-temporal-window-p contains-trigger-condition-p)
  ;; Challenger: Any change to the operative scope (like a temporal window) is material
  ;; and must be disclosed on the ballot.
  (or contains-temporal-window-p contains-trigger-condition-p))

;; material-trigger-condition-p
;; Purpose:
;;   Determine whether the amendment's trigger condition is material for ballot
;;   disclosure purposes under the Challenger's theory.
;; Inputs:
;;   contains-temporal-window-p  - boolean indicating whether the amendment text
;;                                 contains a time window.
;;   contains-trigger-condition-p - boolean indicating whether the amendment text
;;                                  contains an external trigger condition.
;; Output:
;;   Returns T if either the trigger condition or the associated limiting
;;   condition is present; otherwise returns NIL.
(defun material-trigger-condition-p (contains-temporal-window-p contains-trigger-condition-p)
  (or contains-temporal-window-p contains-trigger-condition-p))

;; void-challenge-survivable-p
;; Purpose:
;;   Determine whether the first passage survives a judicial void challenge
;;   under the Challenger's theory.
;; Output:
;;   Returns NIL. Challenger doctrine: The circuit court's finding that first
;;   passage was void ab initio is legally dispositive. A fundamentally defective
;;   first passage cannot be rescued and the amendment never validly entered
;;   the Article XII pipeline.
(defun void-challenge-survivable-p ()
  nil)

;; second-passage-validp
;; Purpose:
;;   Determine whether the second passage of the amendment occurred after the
;;   intervening House election under the Challenger's theory.
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
;;   Returns NIL when both structural changes are present, because the act already
;;   combines multiple objects and venue centralization adds yet another independent
;;   object to an already problematic package.
;;   Challenger doctrine: Mandatory Richmond-only venue is a substantive, independent
;;   object that is not germane to the core constitutional amendment referral,
;;   especially when the act already combines Article II and Schedule modifications.
(defun venue-centralization-permitted-p (modifies-article-ii-p modifies-schedule-p)
  (not (and modifies-article-ii-p modifies-schedule-p)))

;; transfer-pending-cases-permitted-p
;; Purpose:
;;   Determine whether forced transfer of pending cases is constitutionally permitted
;;   in this context.
;; Output:
;;   Returns NIL. Challenger doctrine: Forced transfer of pending suits is an
;;   independent structural defect and procedurally problematic.
(defun transfer-pending-cases-permitted-p ()
  nil)

;; --- Core Structure & Facts ---
(ld "hb1384_core.lisp")
(ld "hb1384_facts.lisp")

;; --- Theorems ---

;; hb1384-illegal-under-challenger-model
;; Purpose:
;;   State the Challenger's top-level theorem: using the shared facts and the
;;   Challenger's legal interpretations, HB1384 evaluates as illegal.
;; Inputs:
;;   None directly; this theorem is instantiated entirely from shared constants.
;; Output:
;;   A proved ACL2 theorem event.
(defthm hb1384-illegal-under-challenger-model
  (illegal-referral-p
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
