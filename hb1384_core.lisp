; hb1384_core.lisp
; Core structure for proving legality of HB1384
; This file assumes that interpretive functions and facts have already been defined.

(in-package "ACL2")

;; --- Submission Clause Core Logic ---
;; Both sides agree on this structural rule for the submission clause
(defun submission-clause-ok-p
  (material-temporal-limit-p
   material-trigger-condition-p
   ballot-discloses-temporal-limit-p
   ballot-discloses-trigger-condition-p)
  (and (implies material-temporal-limit-p
                ballot-discloses-temporal-limit-p)
       (implies material-trigger-condition-p
                ballot-discloses-trigger-condition-p)))

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
   ballot-discloses-trigger-condition-p)
  (let* ((intervening-occurrence (election-occurrence-date intervening-early-voting-start-date intervening-election-day))
         (sub-date (submission-date referendum-early-voting-start-date referendum-election-day))
         (material-temporal-p (material-temporal-limit-p contains-temporal-window-p contains-trigger-condition-p))
         (material-trigger-p (material-trigger-condition-p contains-temporal-window-p contains-trigger-condition-p)))
    (and (next-election-ok-p first-passage-date intervening-occurrence intervening-election-type)
         (ninety-day-rule-ok-p final-passage-date sub-date)
         (notice-ok-p published-30-13-p)
         (single-object-ok-p modifies-article-ii-p modifies-schedule-p)
         (submission-clause-ok-p
          material-temporal-p
          material-trigger-p
          ballot-discloses-temporal-limit-p
          ballot-discloses-trigger-condition-p))))

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
   ballot-discloses-trigger-condition-p)
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
        ballot-discloses-trigger-condition-p)))
