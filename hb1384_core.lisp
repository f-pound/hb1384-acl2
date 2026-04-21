; hb1384_core.lisp
; Core structural skeleton for proving legality / illegality of HB1384.
;
; This file defines the SHARED logical framework that both the Challenger
; and the Commonwealth models agree on.  It uses 'implies'-based rules so
; that the legal outcome is determined entirely by the interpretive
; functions defined in each model file, not by any assumption hard-coded
; here.
;
; Loaded by both model files via (ld "hb1384_core.lisp") AFTER the
; model-specific interpretive functions have been defined.
;
; All date constants below are encoded as ordinal day counts
; measured from 2024-01-01 = day 0.

(in-package "ACL2")

;; --- Submission Clause Core Logic ---
;; Derived from the amendment's Schedule Section 6 temporal window.
;; Both sides agree on this structural rule for the submission clause:
;; if a feature is material, then the ballot must disclose it.
;; Parameter names deliberately avoid the "-p" suffix used by the
;; interpretive functions that compute these values, preventing
;; accidental name-shadowing.
(defun submission-clause-ok-p
  (material-temporal-flag
   material-trigger-flag
   ballot-temporal-discloses?
   ballot-trigger-discloses?)
  (and (implies material-temporal-flag
               ballot-temporal-discloses?)
       (implies material-trigger-flag
                ballot-trigger-discloses?)))

;; --- Venue Provision Core Logic ---
;; Both sides agree on this structural rule for venue validity:
;; if the act centralises venue or transfers pending cases, the
;; corresponding permission predicate must hold.
(defun venue-ok-p
  (richmond-exclusive-venue-p
   venue-provision-transfers-pending-cases-p
   venue-centralization-permitted-p
   transfer-pending-cases-permitted-p)
  (and (implies richmond-exclusive-venue-p
                venue-centralization-permitted-p)
       (implies venue-provision-transfers-pending-cases-p
                transfer-pending-cases-permitted-p)))

;; --- First Passage Core Logic (P1) ---
;; Both sides agree on this structural rule:
;; If first passage has been judicially challenged as void, it survives
;; only if the applicable legal doctrine treats that challenge as survivable.
(defun first-passage-ok-p
  (first-passage-challenged-as-void-p
   void-challenge-survivable-p)
  (implies first-passage-challenged-as-void-p
           void-challenge-survivable-p))

;; --- Main Legality Predicate ---

(defun legal-referral-p
  (first-passage-date
   intervening-early-voting-start-date
   intervening-election-day
   intervening-election-type
   final-passage-date
   referendum-early-voting-start-date
   referendum-election-day
   published-30-13-p
   modifies-article-ii-p
   modifies-schedule-p
   contains-temporal-window-p
   contains-trigger-condition-p
   ballot-discloses-temporal-limit-p
   ballot-discloses-trigger-condition-p
   richmond-exclusive-venue-p
   venue-provision-transfers-pending-cases-p
   second-passage-date
   first-passage-challenged-as-void-p)
  (let* ((intervening-occurrence (election-occurrence-date intervening-early-voting-start-date intervening-election-day))
         (sub-date (submission-date referendum-early-voting-start-date referendum-election-day))
         (material-temporal-p (material-temporal-limit-p contains-temporal-window-p contains-trigger-condition-p))
         (material-trigger-p (material-trigger-condition-p contains-temporal-window-p contains-trigger-condition-p))
         (centralization-permitted-p (venue-centralization-permitted-p modifies-article-ii-p modifies-schedule-p))
         (transfer-permitted-p (transfer-pending-cases-permitted-p))
         (void-survivable-p (void-challenge-survivable-p)))
    (and (first-passage-ok-p first-passage-challenged-as-void-p void-survivable-p)
         (next-election-ok-p first-passage-date intervening-occurrence intervening-election-type)
         (second-passage-validp second-passage-date intervening-occurrence)
         (ninety-day-rule-ok-p final-passage-date sub-date)
         (notice-ok-p published-30-13-p)
         (single-object-ok-p modifies-article-ii-p modifies-schedule-p)
         (submission-clause-ok-p
          material-temporal-p
          material-trigger-p
          ballot-discloses-temporal-limit-p
          ballot-discloses-trigger-condition-p)
         (venue-ok-p
          richmond-exclusive-venue-p
          venue-provision-transfers-pending-cases-p
          centralization-permitted-p
          transfer-permitted-p))))

(defun illegal-referral-p
  (first-passage-date
   intervening-early-voting-start-date
   intervening-election-day
   intervening-election-type
   final-passage-date
   referendum-early-voting-start-date
   referendum-election-day
   published-30-13-p
   modifies-article-ii-p
   modifies-schedule-p
   contains-temporal-window-p
   contains-trigger-condition-p
   ballot-discloses-temporal-limit-p
   ballot-discloses-trigger-condition-p
   richmond-exclusive-venue-p
   venue-provision-transfers-pending-cases-p
   second-passage-date
   first-passage-challenged-as-void-p)
  (not (legal-referral-p
        first-passage-date
        intervening-early-voting-start-date
        intervening-election-day
        intervening-election-type
        final-passage-date
        referendum-early-voting-start-date
        referendum-election-day
        published-30-13-p
        modifies-article-ii-p
        modifies-schedule-p
        contains-temporal-window-p
        contains-trigger-condition-p
        ballot-discloses-temporal-limit-p
        ballot-discloses-trigger-condition-p
        richmond-exclusive-venue-p
        venue-provision-transfers-pending-cases-p
        second-passage-date
        first-passage-challenged-as-void-p)))
