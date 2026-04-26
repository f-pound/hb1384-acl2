# Axiom Inventory

Complete classification of every `defaxiom` in the project.

## Summary

| Category | Count | Risk Level |
|---|---|---|
| TEXT_FACT | 8 | Low |
| PROCEDURAL_FACT | 9 | Low |
| STRUCTURAL_FACT | 6 | Low |
| BRIDGE_RULE | 1 | Low |
| SCENARIO_FACT | 4 | Low |
| INTERPRETATION_CHALLENGER | 8 | Medium |
| INTERPRETATION_COMMONWEALTH | 8 | Medium |
| **Total** | **44** | — |

## Text / Procedural / Structural Facts (hb1384_facts.lisp)

| Axiom Name | Classification | Source |
|---|---|---|
| `text-hb1384-is-enrolled-act` | TEXT_FACT | LIS HB 1384, enrolled act |
| `text-hb1384-is-amendment` | TEXT_FACT | LIS HB 1384, enrolled act |
| `text-first-passage-date` | PROCEDURAL_FACT | LIS, 2024 Regular Session journal |
| `text-intervening-election-exists` | PROCEDURAL_FACT | VA Board of Elections |
| `text-intervening-election-is-general` | PROCEDURAL_FACT | VA Board of Elections |
| `text-intervening-early-voting-date` | PROCEDURAL_FACT | VA Board of Elections |
| `text-intervening-election-day` | PROCEDURAL_FACT | VA Board of Elections |
| `text-second-passage-date` | PROCEDURAL_FACT | LIS, 2026 Regular Session journal |
| `text-final-passage-date` | PROCEDURAL_FACT | LIS, 2026 Regular Session journal |
| `text-referendum-early-voting-date` | PROCEDURAL_FACT | VA Dept. of Elections |
| `text-referendum-election-day` | PROCEDURAL_FACT | VA Dept. of Elections |
| `text-referendum-is-ballot-question` | PROCEDURAL_FACT | VA Dept. of Elections |
| `text-first-passage-challenged-as-void` | PROCEDURAL_FACT | VA Supreme Court order, p.5 |
| `text-section-30-13-noncompliant` | PROCEDURAL_FACT | VA Supreme Court order, p.5 |
| `text-amend-modifies-article-ii` | STRUCTURAL_FACT | HB 1384 enrolled act |
| `text-amend-modifies-schedule` | STRUCTURAL_FACT | HB 1384 enrolled act |
| `text-amend-contains-temporal-window` | STRUCTURAL_FACT | Schedule § 6 text |
| `text-amend-contains-trigger-condition` | STRUCTURAL_FACT | Article II, § 6 text |
| `text-ballot-omits-temporal-limit` | STRUCTURAL_FACT | Ballot specimen |
| `text-ballot-omits-trigger-condition` | STRUCTURAL_FACT | Ballot specimen |
| `text-richmond-exclusive-venue` | STRUCTURAL_FACT | HB 1384, p. 4 |
| `text-venue-transfers-pending-cases` | STRUCTURAL_FACT | HB 1384, p. 4 |
| `text-election-after-first-passage` | BRIDGE_RULE | Chronological fact |

## Scenario Facts (model files)

| Axiom Name | File | Source |
|---|---|---|
| `challenger-scenario-election-qualifies` | challenger | VA Board of Elections |
| `challenger-scenario-second-passage-after-election` | challenger | LIS chronology |
| `commonwealth-scenario-election-qualifies` | commonwealth | VA Board of Elections |
| `commonwealth-scenario-second-passage-after-election` | commonwealth | LIS chronology |

## Challenger Interpretive Assumptions (hb1384_challenger_model.lisp)

| Axiom Name | Predicate Bridged | Interpretation |
|---|---|---|
| `challenger-bridge-void` | `void-challenge-survivablep` → NOT survivable | Void ab initio is dispositive |
| `challenger-bridge-90-day` | `ninety-day-rule-satisfiedp` → NOT satisfied | Early voting = submission; 49 < 90 |
| `challenger-bridge-notice` | `notice-satisfiedp` → NOT satisfied | § 30-13 is mandatory |
| `challenger-bridge-temporal-material` | `temporal-window-materialp` → material | Temporal window must be disclosed |
| `challenger-bridge-trigger-material` | `trigger-condition-materialp` → material | Trigger condition must be disclosed |
| `challenger-bridge-single-object` | `single-object-satisfiedp` → NOT satisfied | Art II + Schedule = multiple objects |
| `challenger-bridge-venue` | `venue-centralization-permittedp` → NOT permitted | Venue is independent defect |
| `challenger-bridge-transfer` | `transfer-pending-cases-permittedp` → NOT permitted | Transfer is procedurally problematic |

## Commonwealth Interpretive Assumptions (hb1384_commonwealth_model.lisp)

| Axiom Name | Predicate Bridged | Interpretation |
|---|---|---|
| `commonwealth-bridge-void-survivable` | `void-challenge-survivablep` → survivable | Void finding is reversible |
| `commonwealth-bridge-90-day` | `ninety-day-rule-satisfiedp` → satisfied | Election day = submission; 95 ≥ 90 |
| `commonwealth-bridge-notice` | `notice-satisfiedp` → satisfied | § 30-13 is directory |
| `commonwealth-bridge-temporal-nonmaterial` | `temporal-window-materialp` → NOT material | Temporal window is not material |
| `commonwealth-bridge-trigger-nonmaterial` | `trigger-condition-materialp` → NOT material | Trigger condition is not material |
| `commonwealth-bridge-single-object` | `single-object-satisfiedp` → satisfied | Germane to redistricting |
| `commonwealth-bridge-venue` | `venue-centralization-permittedp` → permitted | GA has venue authority |
| `commonwealth-bridge-transfer` | `transfer-pending-cases-permittedp` → permitted | GA has procedural authority |

## Hinge Void Challenge (hb1384_hinge_void_challenge.lisp)

| Axiom Name | Classification |
|---|---|
| `challenger-bridge-void-not-survivable` | INTERPRETATION_CHALLENGER |
