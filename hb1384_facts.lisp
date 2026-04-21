; hb1384_facts.lisp
; Centralized raw historical facts about HB1384

(in-package "ACL2")

;; --- Dates ---
;; Dates are modeled as integers representing relative days.
(defconst *first-passage-date* 0)
(defconst *intervening-early-voting-start-date* 150)
(defconst *intervening-election-day* 195)
(defconst *second-passage-date* 300)
(defconst *final-passage-date* 350)
(defconst *referendum-early-voting-start-date* 430) ; 80 days after final passage
(defconst *referendum-election-day* 475)            ; 125 days after final passage

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
(defconst *ballot-mentions-temporal-window-p* nil)
(defconst *ballot-mentions-trigger-condition-p* nil)
