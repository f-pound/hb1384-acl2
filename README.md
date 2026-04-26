# HB1384 ACL2 — Formal Constitutional Stress-Test

Formal constitutional stress-test of Virginia HB 1384 (2026 Session), which proposes a constitutional amendment to Article II, § 6 (Apportionment) authorizing out-of-cycle congressional redistricting.

This project uses the hybrid encapsulate architecture to separate text-derived statutory facts from interpretive assumptions, then runs competing ACL2 proof obligations to identify which assumptions control the constitutional outcome.

## What This Project Proves

Once the eight Article XII compliance conditions (P1–P8) are established as `defstub` predicates, the remaining formal pivot is which interpretive model constrains them.  The clean books prove that the core vocabulary is genuinely neutral and that the Article XII state machine has coherent pipeline and terminal-state properties.

The challenger model's illegality theorem depends on interpretive assumptions about void-ab-initio dispositive effect, early-voting submission dates, mandatory § 30-13 notice, material ballot disclosure, multi-object violation, and venue impermissibility.

The Commonwealth model's legality theorem depends on interpretive assumptions about void-finding reversibility, election-day submission dates, directory § 30-13 notice, non-material ballot omissions, germane single object, and venue permissibility.

**The certified ACL2 books do not prove that HB 1384 is legal or illegal.** They prove that, under explicitly stated and source-traced assumptions, the challenger model entails illegality while the Commonwealth model entails legality.

## Architecture (v2.0 — Hybrid Encapsulate)

The project uses a hybrid architecture: `encapsulate` with local witness functions for interpretive predicates (where inconsistency risk is highest), `defaxiom` for text-derived facts and scenario ground truths (self-evidently consistent constraints on `defstub` functions), and `defun` compositions for derived compliance conditions.

See [RIGOR_NOTES.md](RIGOR_NOTES.md) for the full architectural rationale.

## Quick Start

```bash
# Pull ACL2 Docker image
docker pull atwalter/acl2:latest

# Certify all 9 books
./scripts/certify_all.sh        # Linux/macOS
.\scripts\certify_all.ps1       # Windows PowerShell

# Or run individual models:
docker compose run --rm acl2 bash -lc 'acl2 < /work/hb1384_challenger_model.lisp'
docker compose run --rm acl2 bash -lc 'acl2 < /work/hb1384_commonwealth_model.lisp'
```

> **Important:** Never load both models in the same ACL2 session.  They derive opposite conclusions and are intentionally incompatible.

## Results

Primary interpretive hinges:
1. Whether the circuit court's void-ab-initio finding is legally dispositive (P1)
2. Whether the election "occurs" at early voting or on election day (P2/P4)
3. Whether § 30-13 publication is mandatory or directory (P5)

See the split hinge books (`hb1384_hinge_void_challenge.lisp`, `hb1384_hinge_election_date.lisp`) for the formal analysis.

## Project Structure

```
hb1384-acl2/
├── README.md                           # This file
├── Overview.md                         # Full predicate derivation report
├── CERTIFICATION.md                    # certify-book guide
├── PROOF_TOUR.md                       # Architecture walkthrough (10 min)
├── TOP_5_THEOREMS.md                   # Best theorems (zero axiom deps)
├── RIGOR_NOTES.md                      # Architecture rationale
├── DISCLOSURE.md                       # Invention disclosure / prior art
├── LICENSE                             # Apache 2.0
├── constitutional_language.txt         # Proposed amendment text
├── virginia_april_21_ballot_1103976.pdf  # Ballot specimen
│
├── hb1384_core.lisp                    # Neutral vocabulary (defstub + defun)
├── hb1384_facts.lisp                   # Text-derived facts (defaxiom)
├── hb1384_process.lisp                 # Article XII state machine (defun)
├── hb1384_process_invariants.lisp      # General trace invariants (induction)
├── hb1384_consistency_check.lisp       # Neutrality proofs
├── hb1384_hinge_void_challenge.lisp    # P1 hinge: void challenge
├── hb1384_hinge_election_date.lisp     # P4 hinge: election occurrence date
├── hb1384_challenger_model.lisp        # Challenger model (encapsulate + defaxiom)
├── hb1384_commonwealth_model.lisp      # Commonwealth model (encapsulate + defaxiom)
│
├── docker-compose.yml                  # ACL2 Docker config
├── .github/workflows/acl2-proofs.yml   # CI: automated proof certification
│
├── sources/
│   ├── source_manifest.json            # Provenance manifest (all sources)
│   └── clause_trace.csv               # Axiom → source clause traceability
│
├── tools/
│   └── validate_trace.py              # Machine-checkable source trace validator
│
├── scripts/
│   ├── certify_all.ps1                # Batch certification (Windows)
│   └── certify_all.sh                 # Batch certification (Linux/macOS)
│
└── reports/
    ├── axiom_inventory.md             # Full defaxiom classification report
    └── certification_status.md        # certify-book status matrix
```

## Key Features

- **Hybrid architecture**: `encapsulate` for interpretive predicates, `defaxiom` for text facts and scenarios
- **Source provenance**: Every axiom traced to authoritative source text via `clause_trace.csv`
- **Article XII state machine**: 10-state, 10-event model of the amendment pipeline
- **Induction proofs**: General theorems over arbitrary event traces (not ground-truth evaluations)
- **Neutrality proofs**: Core vocabulary alone does not force either legal outcome
- **Hinge identification**: Split hinge books for void challenge and election date
- **General theorems**: `challenger-illegality-general` and `commonwealth-legality-general`
- **CI/CD**: GitHub Actions runs all proofs on every push

## For ACL2 Reviewers

1. **Run the proof suite**: `./scripts/certify_all.sh` or `.\scripts\certify_all.ps1`.  See [CERTIFICATION.md](CERTIFICATION.md).
2. **Executable model**: `hb1384_process.lisp` — 10-state, 10-event Article XII state machine with recursive trace executor.
3. **Induction proofs**: `hb1384_process_invariants.lisp` — terminal stability, event-in-trace requirements, valid paths with arbitrary trailing events, all by induction.
4. **Encapsulate usage**: Challenger model and Commonwealth model (2 blocks total, each with 8 local witness functions).
5. **Neutrality proofs**: `hb1384_consistency_check.lisp` — decomposition, sanity checks, and `iff` neutrality theorem.
6. **Top 5 theorems**: See [TOP_5_THEOREMS.md](TOP_5_THEOREMS.md) — all five depend on zero axioms.
7. **Proof tour**: See [PROOF_TOUR.md](PROOF_TOUR.md) for the full architecture walkthrough.

## For Legal Reviewers

1. **Legal sources**: Virginia Constitution (Art. XII §1, Art. IV §12, Art. II §6), Code § 30-13, HB 1384 enrolled act, Virginia Supreme Court order, ballot specimen.  All in `sources/source_manifest.json`.
2. **Source tracing**: Every axiom traces to a specific clause in a public legal document via `sources/clause_trace.csv`.  Machine-checkable via `tools/validate_trace.py`.
3. **What ACL2 proves conditionally**: If these assumptions hold, then this legal conclusion follows.  ACL2 does not evaluate which assumptions are correct.
4. **Why this is not a judicial decision engine**: ACL2 models boolean properties.  It does not weigh competing interests, apply stare decisis, or evaluate legislative intent.
5. **Challenger vs. Commonwealth theories**: The challenger argues the referral is procedurally defective on 6 of 8 grounds.  The Commonwealth argues each deficiency is curable, directory, or permissible.  Both conclusions are formally derived from their respective assumption sets.

## Constitutional Provisions

- Virginia Constitution, Article XII, § 1 (Amendment Procedure)
- Virginia Constitution, Article IV, § 12 (Single Object Rule)
- Virginia Constitution, Article II, § 6 (Apportionment — proposed amendment)

## Disclosure

See [DISCLOSURE.md](DISCLOSURE.md) for the origin and concept disclosure establishing prior art for this architecture.

## License

Copyright 2026 F-Pound Project Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

> <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
