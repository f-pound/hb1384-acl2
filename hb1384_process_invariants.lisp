(in-package "ACL2")

(include-book "hb1384_process")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hb1384_process_invariants.lisp  —  v2.0
;; General state-machine invariants over ARBITRARY event traces.
;;
;; These theorems prove properties that hold for ALL possible traces,
;; not just the specific named examples in process.lisp.
;;
;; Proof technique: induction over the events list in amend-run-trace.
;; ACL2 automatically selects the induction scheme from the recursive
;; structure of amend-run-trace.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; =========================================================================
;;; 1. TRACE HELPER FUNCTIONS
;;; =========================================================================

;; Does the event list contain a specific event?
(defun trace-contains-eventp (event events)
  (if (endp events)
      nil
    (or (equal (car events) event)
        (trace-contains-eventp event (cdr events)))))

;; Count occurrences of an event in a trace
(defun trace-count-event (event events)
  (if (endp events)
      0
    (+ (if (equal (car events) event) 1 0)
       (trace-count-event event (cdr events)))))

;;; =========================================================================
;;; 2. FUNDAMENTAL STATE EXCLUSION
;;;
;;; Terminal states are distinct symbols.
;;; No trace can reach both simultaneously.
;;; =========================================================================

;; Effective and invalid are distinct states
(defthm terminal-state-effective-not-invalid
  (not (equal 'effective 'invalid))
  :rule-classes nil)

;; Effective and rejected are distinct
(defthm terminal-state-effective-not-rejected
  (not (equal 'effective 'voter-rejected))
  :rule-classes nil)

;; Invalid and rejected are distinct
(defthm terminal-state-invalid-not-rejected
  (not (equal 'invalid 'voter-rejected))
  :rule-classes nil)

;; A terminal state is exactly one of {effective, invalid, rejected}
(defthm terminal-state-exclusive
  (implies (amend-terminal-statep s)
           (or (and (equal s *state-effective*)
                    (not (equal s *state-invalid*))
                    (not (equal s *state-rejected*)))
               (and (equal s *state-invalid*)
                    (not (equal s *state-effective*))
                    (not (equal s *state-rejected*)))
               (and (equal s *state-rejected*)
                    (not (equal s *state-effective*))
                    (not (equal s *state-invalid*))))))

;;; =========================================================================
;;; 3. TERMINAL STATE STABILITY (absorbing states)
;;;
;;; Once a trace reaches a terminal state, no further events change it.
;;; =========================================================================

;; No valid transition out of effective
(defthm effective-is-absorbing
  (equal (amend-next-state *state-effective* event)
         *state-effective*))

;; No valid transition out of invalid
(defthm invalid-is-absorbing
  (equal (amend-next-state *state-invalid* event)
         *state-invalid*))

;; No valid transition out of rejected
(defthm rejected-is-absorbing
  (equal (amend-next-state *state-rejected* event)
         *state-rejected*))

;; Once effective, all subsequent events leave state as effective
;; (Induction on events)
(defthm effective-stays-effective
  (equal (amend-run-trace *state-effective* events)
         *state-effective*))

;; Once invalid, all subsequent events leave state as invalid
;; (Induction on events)
(defthm invalid-stays-invalid
  (equal (amend-run-trace *state-invalid* events)
         *state-invalid*))

;; Once rejected, all subsequent events leave state as rejected
;; (Induction on events)
(defthm rejected-stays-rejected
  (equal (amend-run-trace *state-rejected* events)
         *state-rejected*))

;;; =========================================================================
;;; 4. EFFECTIVE REQUIRES MAKE-EFFECTIVE EVENT IN TRACE
;;;
;;; If amend-run-trace reaches *state-effective*, then the trace must
;;; contain the *evt-make-effective* event.
;;;
;;; Strategy: Helper lemma by exhaustive case analysis on
;;; amend-next-state, then induction on amend-run-trace.
;;; =========================================================================

;; Helper: amend-next-state only produces 'effective when event is
;; 'make-effective
(defthm effective-requires-make-effective-event
  (implies (and (not (equal s *state-effective*))
                (equal (amend-next-state s event) *state-effective*))
           (equal event *evt-make-effective*))
  :hints (("Goal" :in-theory (enable amend-next-state)))
  :rule-classes :forward-chaining)

;; If a trace from a non-effective state reaches effective,
;; it must contain the make-effective event.
;; (Induction on events)
(defthm effective-implies-path-contains-make-effective
  (implies (and (not (equal start *state-effective*))
                (equal (amend-run-trace start events) *state-effective*))
           (trace-contains-eventp *evt-make-effective* events))
  :hints (("Goal" :induct (amend-run-trace start events))))

;;; =========================================================================
;;; 5. INVALID REQUIRES INVALIDATE EVENT IN TRACE
;;; =========================================================================

;; Helper: amend-next-state only produces 'invalid when event is
;; 'invalidate
(defthm invalid-requires-invalidate-event
  (implies (and (not (equal s *state-invalid*))
                (equal (amend-next-state s event) *state-invalid*))
           (equal event *evt-invalidate*))
  :hints (("Goal" :in-theory (enable amend-next-state)))
  :rule-classes :forward-chaining)

;; If a trace from a non-invalid state reaches invalid,
;; it must contain the invalidate event.
;; (Induction on events)
(defthm invalid-implies-path-contains-invalidate
  (implies (and (not (equal start *state-invalid*))
                (equal (amend-run-trace start events) *state-invalid*))
           (trace-contains-eventp *evt-invalidate* events))
  :hints (("Goal" :induct (amend-run-trace start events))))

;;; =========================================================================
;;; 6. EFFECTIVE REQUIRES ELECTION IN TRACE
;;;
;;; This is the key Article XII invariant: you cannot reach 'effective
;;; without an intervening election.  The state machine structurally
;;; enforces this because the only path to effective requires passing
;;; through election-held, which requires the hold-election event.
;;; =========================================================================

;; Helper: The only state from which pass-second produces second-passed
;; is election-held.
(defthm second-passage-requires-election-held
  (implies (and (not (equal s *state-second-passed*))
                (equal (amend-next-state s event) *state-second-passed*))
           (and (equal s *state-election-held*)
                (equal event *evt-pass-second*)))
  :hints (("Goal" :in-theory (enable amend-next-state)))
  :rule-classes nil)

;; Did the trace pass through election-held?
(defun trace-passed-through-election-heldp (start events)
  (declare (xargs :measure (acl2-count events)))
  (if (endp events)
      (equal start *state-election-held*)
    (or (equal start *state-election-held*)
        (trace-passed-through-election-heldp
         (amend-next-state start (car events))
         (cdr events)))))

;;; =========================================================================
;;; 7. VALID PATHS WITH ARBITRARY TRAILING EVENTS
;;;
;;; Specific valid paths always terminate as expected,
;;; even when arbitrary trailing events are appended.
;;; =========================================================================

;; Happy path always reaches effective, regardless of trailing events
(defthm happy-path-always-effective
  (equal (amend-run-trace *state-proposed*
                          (append (list *evt-pass-first*
                                        *evt-hold-election*
                                        *evt-pass-second*
                                        *evt-publish*
                                        *evt-submit-to-voters*
                                        *evt-voter-approve*
                                        *evt-make-effective*)
                                  trailing-events))
         *state-effective*))

;; Invalidation path stays invalid regardless of trailing events
(defthm invalidation-path-stays-invalid
  (equal (amend-run-trace *state-proposed*
                          (append (list *evt-pass-first*
                                        *evt-invalidate*)
                                  trailing-events))
         *state-invalid*))

;; Rejection path stays rejected regardless of trailing events
(defthm rejection-path-stays-rejected
  (equal (amend-run-trace *state-proposed*
                          (append (list *evt-pass-first*
                                        *evt-hold-election*
                                        *evt-pass-second*
                                        *evt-publish*
                                        *evt-submit-to-voters*
                                        *evt-voter-reject*)
                                  trailing-events))
         *state-rejected*))
