This was my effort to apply a formal methods model checker to legislation. What better way to dive in than to pick a current issue up for a vote in Virginia, namely HB1384.

The proceed with this effort I made some assumptions:

1. The proposed laws and procedures including modifications to the constitution must be sourced from authentic authoritative sources.

To those ends I have included the 2026 Session, Virginia Acts of Assembly -- Chapter as well as the proposed constitutional law changes to the Virginia constitution.

- Virginia Legislative Information System (LIS) HB 1384 Full Text: https://lis.virginia.gov/cgi-bin/legp604.exe?261+ful+HB1384

- Virginia Legislative Information System (LIS) HB 1384 Summary: https://lis.virginia.gov/cgi-bin/legp604.exe?261+sum+HB1384

- Ballotpedia Page on the Amendment: https://ballotpedia.org/Virginia_House_Bill_1384

2. I wanted to assume that the goals of the proposed legislation were logically unvarnished in that it was attempting to correct a flaw or address a surge in population that warranted an out of cycle redistricting.

In order to prove the logic and legality I chose to incorporate a couple techniques.

Now came the extraction of the black-letter law and the ones specific to HB 1384. I used the help of three LLMs (Claude, Gemini and GPT) to help determine the predicates. LLMs are really good at quickly identifying the specific guardrails from mountains of text to determine hurdles that are involved.

| Predicate | What I abstracted it from | Why I created it | Specific source(s) |
| --- | --- | --- | --- |
| **P1 = first passage valid** | The **first step** in Article XII’s amendment process, plus the litigation claim that the first passage was void. | Article XII requires a proposed amendment to be agreed to by both houses before referral. I split that first agreement into its own predicate because the Supreme Court’s order says the circuit court held the first passage was “void ab initio.” So P1 captures whether the amendment ever validly started the Article XII pipeline. | **Article XII, § 1, first paragraph**: amendment may be proposed and “agreed to by a majority of the members elected to each of the two houses,” then referred after the next House election. ([Virginia Law](https://law.lis.virginia.gov/constitution/article12/section1/)) **Virginia Supreme Court order, p. 5, first bullet**: first passage allegedly void ab initio. |
| **P2 = next House election occurred after first passage** | The clause in Article XII requiring referral to the first regular session held after the **next general election of members of the House of Delegates**. | I created P2 because this is a separate sequencing requirement from first passage itself. The court order shows this is a live dispute: whether any qualifying next House election occurred after first passage, given early voting dates. | **Article XII, § 1, first paragraph**: “referred to the General Assembly at its first regular session held after the next general election of members of the House of Delegates.” ([Virginia Law](https://law.lis.virginia.gov/constitution/article12/section1/)) **Virginia Supreme Court order, p. 5, second bullet**: no “next general election” occurred after first passage because early voting began Sept. 19, 2025. |
| **P3 = second passage valid** | The **second-step approval** in Article XII after the intervening House election. | I created P3 because Article XII has a distinct second approval event, and if that second approval fails, the amendment cannot lawfully go to voters. This is separate from P1 because Virginia’s amendment process is explicitly two-step. | **Article XII, § 1, second paragraph**: “If at such regular session or any subsequent special session of that General Assembly the proposed amendment… shall be agreed to by a majority of all the members elected to each house, then it shall be the duty of the General Assembly to submit…” ([Virginia Law](https://law.lis.virginia.gov/constitution/article12/section1/)) |
| **P4 = submission to voters occurred at least 90 days after final passage** | The **90-day timing rule** in Article XII. | I created P4 as its own predicate because it is an independent constitutional timing condition. The court order shows plaintiffs expressly challenged this requirement based on early voting beginning before the 90th day. | **Article XII, § 1, second paragraph**: amendment must be submitted to voters “not sooner than ninety days after final passage by the General Assembly.” ([Virginia Law](https://law.lis.virginia.gov/constitution/article12/section1/)) **Virginia Supreme Court order, pp. 5–6**: assuming second passage on Jan. 16, 2026, the 90-day requirement was allegedly violated because early voting began March 6 and day 90 was April 16. |
| **P5 = required publication/posting complied with, if that law governed** | Former **Code § 30-13** publication/posting requirement, plus the act’s repeal of that section. | I created P5 because publication/posting is not in Article XII’s text itself, but it was a distinct statutory compliance theory in the litigation. The “if that law governed” qualifier is there because HB 1384 repealed § 30-13 retroactively, so one dispute is whether that statute still mattered. | **Code § 30-13, substantive posting rule**: proposed amendments had to be sent to circuit court clerks; posting had to be completed “not later than three months prior to the next ensuing general election of members of the House of Delegates.” ([Virginia Law](https://law.lis.virginia.gov/vacode/title30/chapter1/section30-13/)) **Virginia Supreme Court order, p. 5, third bullet**: plaintiffs/circuit court said the General Assembly failed to comply with § 30-13. **HB 1384 enrolled act, p. 3**: repeals § 30-13 and makes repeal retroactive to July 1, 1971. |
| **P6 = ballot submission text lawfully matched the amendment under Article XII** | The **Submission Clause** challenge: ballot language allegedly differed from the amendment passed by the General Assembly. | I created P6 because this is not just a timing or notice issue; it is a separate claim that the actual question submitted to voters was legally defective. The predicate asks whether the ballot question lawfully corresponds to the amendment text. | **Virginia Supreme Court order, p. 5, fourth bullet**: ballot language is allegedly misleading and violates Article XII because it “submits a different question on the referendum ballot than the language of the constitutional amendment passed by the General Assembly.” **HB 1384 enrolled act, pp. 2–3**: amendment text includes the trigger condition and 2025–2030 limitation; ballot question uses broader “restore fairness” wording and does not spell those out the same way. |
| **P7 = HB 1384 satisfied Article IV, Section 12’s one-object/title rule** | The **Form of Laws Clause** in Article IV, Section 12, plus the litigation claim that HB 1384 combined multiple objects. | I created P7 because this is a distinct constitutional challenge to the act as a bill, not to the amendment text alone. The predicate asks whether HB 1384 passes the one-object/title test. | **Article IV, § 12**: “No law shall embrace more than one object, which shall be expressed in its title.” ([Virginia Law](https://law.lis.virginia.gov/constitution/article4/section12/)) **Virginia Supreme Court order, p. 6**: plaintiffs argued HB 1384 addressed multiple objects—appropriations, ballot procedures, repeal of § 30-13, and venue transfer—while only the first three were referenced in the title. **HB 1384 enrolled act, p. 1 title and pp. 3–4 enactments**: title covers appropriations, submission of amendment, and repeal of § 30-13; the act also adds venue-centralization language. |

LEGAL = P1 ∧ P2 ∧ P3 ∧ P4 ∧ P5 ∧ P6 ∧ P7

ILLEGAL = ¬LEGAL = ¬P1 ∨ ¬P2 ∨ ¬P3 ∨ ¬P4 ∨ ¬P5 ∨ ¬P6 ∨ ¬P7

An action or state is **ILLEGAL** if **at least one** of the required conditions (P1 through P7) is **FALSE** (i.e., NOT P1 OR NOT P2 OR NOT P3, etc.).

If any of the terms are not met its illegal, in human terms.

The predicates were then turned into ACL2 functions:

| Pn | Legal idea | ACL2 implementation |
| --- | --- | --- |
| **P1** | first passage valid | `first-passage-validp` |
| **P2** | next House election occurred after first passage | `next-election-ok-p` |
| **P3** | second passage valid | `second-passage-validp` |
| **P4** | submission to voters occurred at least 90 days after final passage | `ninety-day-rule-ok-p` |
| **P5** | required publication/posting complied with, if governing | `notice-ok-p` |
| **P6** | ballot submission text lawfully matched/disclosed the amendment under Article XII | `submission-clause-ok-p` |
| **P7** | HB 1384 satisfied Article IV, Section 12 one-object/title rule | `single-object-ok-p` |

`legal-referral-p` is the top-level ACL2 legality predicate.  
It implements legality as the conjunction of seven conditions, where:  
`first-passage-validp` = P1,  
`next-election-ok-p` = P2,  
`second-passage-validp` = P3,  
`ninety-day-rule-ok-p` = P4,  
`notice-ok-p` = P5,  
`submission-clause-ok-p` = P6, and  
`single-object-ok-p` = P7

The goal here was to provide some motivation to apply theorem proving using ACL to more legislative actions and really get to the root of the issues without having to rely on shallow and deceptive political signage and bloviating sociopaths.
