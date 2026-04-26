# Certification Status

## Book Certification Matrix

| Book | Layer | defaxiom? | `certify-book` | Status |
|------|-------|-----------|----------------|--------|
| `hb1384_core` | 0 | No | `(certify-book "hb1384_core" ?)` | ⏳ Pending |
| `hb1384_process` | 0 | No | `(certify-book "hb1384_process" ?)` | ⏳ Pending |
| `hb1384_process_invariants` | 0 | No | `(certify-book "hb1384_process_invariants" ?)` | ⏳ Pending |
| `hb1384_consistency_check` | 0 | No | `(certify-book "hb1384_consistency_check" ?)` | ⏳ Pending |
| `hb1384_facts` | 1 | Yes | `(certify-book "hb1384_facts" ? nil :defaxioms-okp t)` | ⏳ Pending |
| `hb1384_hinge_void_challenge` | 2 | Yes | `(certify-book "hb1384_hinge_void_challenge" ? nil :defaxioms-okp t)` | ⏳ Pending |
| `hb1384_hinge_election_date` | 2 | Yes | `(certify-book "hb1384_hinge_election_date" ? nil :defaxioms-okp t)` | ⏳ Pending |
| `hb1384_challenger_model` | 3 | Yes | `(certify-book "hb1384_challenger_model" ? nil :defaxioms-okp t)` | ⏳ Pending |
| `hb1384_commonwealth_model` | 3 | Yes | `(certify-book "hb1384_commonwealth_model" ? nil :defaxioms-okp t)` | ⏳ Pending |

**Total**: 9 books, 0 certified, 9 pending

## Dependency Graph

```
hb1384_core (Layer 0)
├── hb1384_process (Layer 0)
│   └── hb1384_process_invariants (Layer 0)
├── hb1384_consistency_check (Layer 0)
└── hb1384_facts (Layer 1)
    ├── hb1384_hinge_void_challenge (Layer 2)
    ├── hb1384_hinge_election_date (Layer 2)
    ├── hb1384_challenger_model (Layer 3)
    └── hb1384_commonwealth_model (Layer 3)
```

## Notes

- Layer 0 books have **zero defaxiom dependencies** — all theorems are proved from `defstub`, `defun`, and `defconst` alone.
- Layer 1+ books use `defaxiom` and require `:defaxioms-okp t` for `certify-book`.
- The challenger and commonwealth models **must not** be loaded in the same ACL2 session — they derive opposite conclusions.
