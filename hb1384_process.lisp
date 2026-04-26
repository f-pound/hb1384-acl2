(in-package "ACL2")

(include-book "hb1384_core")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_process.lisp  —  v2.0
;; Article XII amendment pipeline state machine.
;;
;; This book provides executable structure to the neutral vocabulary:
;;   1. Pipeline state constants and recognizers
;;   2. Amendment process state machine with event traces
;;   3. Process invariant theorems (specific paths)
;;
;; This is a NEUTRAL book — no interpretive assumptions.
;; It depends only on core.lisp.
;;
;; The state machine models the Virginia Article XII amendment procedure:
;;   propose → first passage → intervening House election →
;;   second passage → publication/notice → submission to voters →
;;   voter approval → effective
;;
;; Source: Virginia Constitution, Article XII, § 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; 1. PIPELINE STATE CONSTANTS
;;; Source: Article XII, § 1 — sequential procedural requirements
;;; =========================================================================

(defconst *state-proposed*          'proposed)
(defconst *state-first-passed*      'first-passed)
(defconst *state-election-held*     'election-held)
(defconst *state-second-passed*     'second-passed)
(defconst *state-published*         'published)
(defconst *state-submitted*         'submitted-to-voters)
(defconst *state-approved*          'voter-approved)
(defconst *state-rejected*          'voter-rejected)
(defconst *state-effective*         'effective)
(defconst *state-invalid*           'invalid)

;; State recognizer
(defun amend-statep (s)
  (member-equal s (list *state-proposed* *state-first-passed*
                        *state-election-held* *state-second-passed*
                        *state-published* *state-submitted*
                        *state-approved* *state-rejected*
                        *state-effective* *state-invalid*)))

;;; =========================================================================
;;; 2. PIPELINE EVENT CONSTANTS
;;; =========================================================================

(defconst *evt-propose*             'propose)
(defconst *evt-pass-first*          'pass-first)
(defconst *evt-hold-election*       'hold-election)
(defconst *evt-pass-second*         'pass-second)
(defconst *evt-publish*             'publish)
(defconst *evt-submit-to-voters*    'submit-to-voters)
(defconst *evt-voter-approve*       'voter-approve)
(defconst *evt-voter-reject*        'voter-reject)
(defconst *evt-make-effective*      'make-effective)
(defconst *evt-invalidate*          'invalidate)

;; Event recognizer
(defun amend-eventp (e)
  (member-equal e (list *evt-propose* *evt-pass-first*
                        *evt-hold-election* *evt-pass-second*
                        *evt-publish* *evt-submit-to-voters*
                        *evt-voter-approve* *evt-voter-reject*
                        *evt-make-effective* *evt-invalidate*)))

;;; =========================================================================
;;; 3. STATE TRANSITION FUNCTION
;;; Returns the next state given a current state and event.
;;; Invalid transitions return the current state (no-op).
;;;
;;; Source: Article XII, § 1 — the amendment must proceed through each
;;;   stage in order. The *evt-invalidate* event can fire from any
;;;   non-terminal state (modeling judicial invalidation at any stage).
;;; =========================================================================

(defun amend-next-state (current-state event)
  (cond
   ;; Happy path: propose → first passage
   ((and (equal current-state *state-proposed*)
         (equal event *evt-pass-first*))
    *state-first-passed*)

   ;; First passage → intervening election
   ((and (equal current-state *state-first-passed*)
         (equal event *evt-hold-election*))
    *state-election-held*)

   ;; Election held → second passage
   ((and (equal current-state *state-election-held*)
         (equal event *evt-pass-second*))
    *state-second-passed*)

   ;; Second passage → publication
   ((and (equal current-state *state-second-passed*)
         (equal event *evt-publish*))
    *state-published*)

   ;; Publication → submitted to voters
   ((and (equal current-state *state-published*)
         (equal event *evt-submit-to-voters*))
    *state-submitted*)

   ;; Submitted → voter approval
   ((and (equal current-state *state-submitted*)
         (equal event *evt-voter-approve*))
    *state-approved*)

   ;; Submitted → voter rejection
   ((and (equal current-state *state-submitted*)
         (equal event *evt-voter-reject*))
    *state-rejected*)

   ;; Voter approved → effective
   ((and (equal current-state *state-approved*)
         (equal event *evt-make-effective*))
    *state-effective*)

   ;; Invalidation from any non-terminal state
   ((and (not (equal current-state *state-effective*))
         (not (equal current-state *state-invalid*))
         (not (equal current-state *state-rejected*))
         (equal event *evt-invalidate*))
    *state-invalid*)

   ;; Invalid transition → stay in current state
   (t current-state)))

;;; =========================================================================
;;; 4. TRACE EXECUTOR
;;; Recursively runs a list of events from a starting state.
;;; =========================================================================

(defun amend-run-trace (start-state events)
  (if (endp events)
      start-state
    (amend-run-trace (amend-next-state start-state (car events))
                     (cdr events))))

;;; =========================================================================
;;; 5. TERMINAL STATE RECOGNIZER
;;; =========================================================================

(defun amend-terminal-statep (s)
  (or (equal s *state-effective*)
      (equal s *state-invalid*)
      (equal s *state-rejected*)))

;;; =========================================================================
;;; 6. PROCESS INVARIANT THEOREMS (specific paths)
;;;
;;; These prove that specific, named event sequences produce the
;;; expected outcomes.  General inductive proofs over arbitrary
;;; traces are in hb1384_process_invariants.lisp.
;;; =========================================================================

;; Happy path: full valid pipeline → effective
(defthm process-inv-happy-path-effective
  (equal (amend-run-trace *state-proposed*
                          (list *evt-pass-first*
                                *evt-hold-election*
                                *evt-pass-second*
                                *evt-publish*
                                *evt-submit-to-voters*
                                *evt-voter-approve*
                                *evt-make-effective*))
         *state-effective*))

;; Voter rejection path → rejected
(defthm process-inv-voter-rejection
  (equal (amend-run-trace *state-proposed*
                          (list *evt-pass-first*
                                *evt-hold-election*
                                *evt-pass-second*
                                *evt-publish*
                                *evt-submit-to-voters*
                                *evt-voter-reject*))
         *state-rejected*))

;; Judicial invalidation after first passage → invalid
(defthm process-inv-invalidation-after-first-passage
  (equal (amend-run-trace *state-proposed*
                          (list *evt-pass-first*
                                *evt-invalidate*))
         *state-invalid*))

;; Invalidation at proposed stage → invalid
(defthm process-inv-invalidation-at-proposed
  (equal (amend-run-trace *state-proposed*
                          (list *evt-invalidate*))
         *state-invalid*))

;; Missing election: attempt second passage without election → no progress
(defthm process-inv-missing-election-no-progress
  (equal (amend-run-trace *state-first-passed*
                          (list *evt-pass-second*))
         *state-first-passed*))

;; Missing first passage: attempt election without first passage → no progress
(defthm process-inv-missing-first-passage-no-progress
  (equal (amend-run-trace *state-proposed*
                          (list *evt-hold-election*))
         *state-proposed*))

;; Cannot skip from proposed to submitted
(defthm process-inv-no-skip-to-submitted
  (equal (amend-run-trace *state-proposed*
                          (list *evt-submit-to-voters*))
         *state-proposed*))

;; Cannot jump from proposed to effective
(defthm process-inv-no-skip-to-effective
  (not (equal (amend-next-state *state-proposed* *evt-make-effective*)
              *state-effective*)))

;; Invalidation after submission → invalid
(defthm process-inv-invalidation-after-submission
  (equal (amend-run-trace *state-proposed*
                          (list *evt-pass-first*
                                *evt-hold-election*
                                *evt-pass-second*
                                *evt-publish*
                                *evt-submit-to-voters*
                                *evt-invalidate*))
         *state-invalid*))
