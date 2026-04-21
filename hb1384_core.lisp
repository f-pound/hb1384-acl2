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

;; --- Venue Provision Core Logic ---
;; Both sides agree on this structural rule for venue validity
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
