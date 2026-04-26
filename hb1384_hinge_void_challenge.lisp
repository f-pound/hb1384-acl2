(in-package "ACL2")

(include-book "hb1384_facts")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_hinge_void_challenge.lisp  —  v2.0
;; Split hinge: void-ab-initio challenge survivability.
;;
;; The circuit court held that the first passage was "void ab initio."
;; Whether this finding is legally dispositive is the primary P1 hinge.
;;
;; Semantic A (Challenger): The void-ab-initio finding is dispositive.
;;   A fundamentally defective first passage cannot be rescued.
;;   The amendment never validly entered the Article XII pipeline.
;;
;; Semantic B (Commonwealth): The void-ab-initio finding is reversible
;;   on appeal. The first passage was conducted through regular
;;   legislative order; any procedural challenge is curable, not fatal.
;;
;; Source: Virginia Supreme Court order, p. 5, first bullet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; SEMANTIC A: Void finding IS dispositive (Challenger theory)
;;; =========================================================================

(encapsulate
  ((challenger-void-dispositivep (amend) t))

  ;; ---- Witness model ----
  ;; The witness always returns t (void finding is always dispositive).
  (local (defun challenger-void-dispositivep (amend)
    (declare (ignore amend)) t))

  ;; ---- Exported constraint ----
  ;; INTERPRETATION_CHALLENGER: If first passage is challenged as void,
  ;; the void finding is legally dispositive — the first passage fails.
  ;;
  ;; Doctrinal basis: The circuit court's finding that the first passage
  ;; was conducted in violation of procedural requirements renders it
  ;; a nullity. Under Virginia law, acts void ab initio have no legal
  ;; effect and cannot be ratified or cured.
  (defthm challenger-void-interpretation
    (implies (first-passage-challenged-as-voidp amend)
             (challenger-void-dispositivep amend))))

;; Bridge axiom: challenger's void-dispositive → core void-challenge
;; not survivable.
(defaxiom challenger-bridge-void-not-survivable
  (implies (challenger-void-dispositivep amend)
           (not (void-challenge-survivablep amend))))

;; Under Semantic A: first passage fails for hb1384-amendment
(defthm hinge-void-challenger-first-passage-fails
  (not (first-passage-ok-p 'hb1384-amendment)))

;; Under Semantic A: the referral is illegal (P1 alone is sufficient)
(defthm hinge-void-challenger-illegal
  (illegal-referral-conditionp 'hb1384-amendment elec ballot))
