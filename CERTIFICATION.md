# Certification Guide

## Prerequisites

- Docker with `atwalter/acl2:latest` image
- PowerShell (Windows) or bash (Linux/macOS)

## Pull the ACL2 image

```bash
docker pull atwalter/acl2:latest
```

## Certify all books

### Linux/macOS
```bash
chmod +x scripts/certify_all.sh
./scripts/certify_all.sh
```

### Windows PowerShell
```powershell
.\scripts\certify_all.ps1
```

## Manual certification (individual books)

### Layer 0: Clean books (no defaxiom dependency)

These books contain only `defstub`, `defun`, `defconst`, and `defthm` — no `defaxiom`.
They certify with the default `certify-book` command.

```bash
# Core vocabulary
echo '(certify-book "hb1384_core" ?)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2

# Process model (state machine)
echo '(certify-book "hb1384_process" ?)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2

# Process invariants (induction proofs)
echo '(certify-book "hb1384_process_invariants" ?)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2

# Consistency check (neutrality proofs)
echo '(certify-book "hb1384_consistency_check" ?)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2
```

### Layer 1: Source-traced axiom book

```bash
echo '(certify-book "hb1384_facts" ? nil :defaxioms-okp t)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2
```

### Layer 2: Hinge interpretation books

```bash
echo '(certify-book "hb1384_hinge_void_challenge" ? nil :defaxioms-okp t)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2
echo '(certify-book "hb1384_hinge_election_date" ? nil :defaxioms-okp t)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2
```

### Layer 3: Interpretive models

```bash
# Challenger model (expects illegality)
echo '(certify-book "hb1384_challenger_model" ? nil :defaxioms-okp t)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2

# Commonwealth model (expects legality)
echo '(certify-book "hb1384_commonwealth_model" ? nil :defaxioms-okp t)' | docker run --rm -i -v .:/work -w /work atwalter/acl2:latest acl2
```

> **Important:** Never load both models in the same ACL2 session. They derive opposite conclusions and are intentionally incompatible.

## Dependency order

```
hb1384_core.lisp                    (Layer 0 — no dependencies)
├── hb1384_process.lisp             (Layer 0 — depends on core)
│   └── hb1384_process_invariants.lisp  (Layer 0 — depends on process)
├── hb1384_consistency_check.lisp   (Layer 0 — depends on core)
├── hb1384_facts.lisp               (Layer 1 — depends on core)
│   ├── hb1384_hinge_void_challenge.lisp    (Layer 2 — depends on facts)
│   ├── hb1384_hinge_election_date.lisp     (Layer 2 — depends on facts)
│   ├── hb1384_challenger_model.lisp        (Layer 3 — depends on facts)
│   └── hb1384_commonwealth_model.lisp      (Layer 3 — depends on facts)
```

## Expected results

All 9 books should produce `.cert` files. Logs are saved to `logs/certify/`.

| Book | Layer | defaxiom? | Expected |
|------|-------|-----------|----------|
| `hb1384_core` | 0 | No | ✅ PASS |
| `hb1384_process` | 0 | No | ✅ PASS |
| `hb1384_process_invariants` | 0 | No | ✅ PASS |
| `hb1384_consistency_check` | 0 | No | ✅ PASS |
| `hb1384_facts` | 1 | Yes | ✅ PASS |
| `hb1384_hinge_void_challenge` | 2 | Yes | ✅ PASS |
| `hb1384_hinge_election_date` | 2 | Yes | ✅ PASS |
| `hb1384_challenger_model` | 3 | Yes | ✅ PASS |
| `hb1384_commonwealth_model` | 3 | Yes | ✅ PASS |
