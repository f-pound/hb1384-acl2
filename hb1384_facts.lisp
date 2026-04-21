; hb1384_facts.lisp
; Centralized raw historical facts about HB1384

(in-package "ACL2")

;; --- Dates ---
;; All date constants below are encoded as ordinal day counts
;; measured from 2024-01-01 = day 0.
;; This preserves both chronological ordering and correct day-difference
;; arithmetic (needed for the 90-day rule).
;;
;; Date mapping (YYYY-MM-DD → day offset):
;;   2024-03-11 → 70   First passage (2024 session)
;;   2025-09-19 → 627  Intervening early voting begins
;;   2025-11-04 → 673  Intervening election day (House of Delegates)
;;   2026-01-16 → 746  Second passage / final passage (2026 session)
;;   2026-03-06 → 795  Referendum early voting begins (49 days after final passage)
;;   2026-04-21 → 841  Referendum election day (95 days after final passage)
;;
(defconst *first-passage-date* 70)                   ; 2024-03-11
(defconst *intervening-early-voting-start-date* 627) ; 2025-09-19
(defconst *intervening-election-day* 673)            ; 2025-11-04
(defconst *second-passage-date* 746)                 ; 2026-01-16
(defconst *final-passage-date* 746)                  ; 2026-01-16
(defconst *referendum-early-voting-start-date* 795)  ; 2026-03-06 (day 49 after final passage)
(defconst *referendum-election-day* 841)             ; 2026-04-21 (day 95 after final passage)

;; --- First Passage Judicial Status ---
(defconst *first-passage-challenged-as-void-p* t)

;; --- Election Types ---
(defconst *intervening-election-type* 'general)

;; --- Notice / Publication ---
(defconst *published-30-13-p* nil) ; Failed strict compliance with 30-13

;; --- Amendment Text Features (Pure Facts) ---
(defconst *amendment-modifies-article-ii-p* t)
(defconst *amendment-modifies-schedule-p* t)
(defconst *amendment-contains-temporal-window-p* t)
(defconst *amendment-contains-trigger-condition-p* t)

;; --- Ballot Language Properties (Pure Facts) ---
;; Whether the ballot text actually discloses the temporal window and
;; trigger condition to voters.  Both are nil because the ballot
;; language omitted these details.
(defconst *ballot-discloses-temporal-limit-p* nil)
(defconst *ballot-discloses-trigger-condition-p* nil)

;; --- Venue Provision (Pure Facts) ---
(defconst *richmond-exclusive-venue-p* t)
(defconst *venue-provision-transfers-pending-cases-p* t)
