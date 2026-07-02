---
name: verifying-completion
description: >-
  Verify that a build is actually done: assemble the requirement checklist, demonstrate every item with executed evidence — run the tests, exercise the API or CLI, walk the workflows — and produce a traceability report with a per-item verdict and every gap listed. Use when someone asks "is it done?", to verify or validate an implementation against its requirements, spec, or PRD, run a completion or acceptance gate, check feature completeness, or before declaring a milestone shipped. Works from written requirements when the project has them, or reconstructs the checklist from the request and repo. Reports gaps — does not fix them, and does not review code style or architecture.
---

# Verifying Completion

## Operating Rules

This skill is an evidence gate, not a code review. The verdict is earned by demonstration — never by reading code and concluding it looks right.

### Core Directives

1. **No evidence, no pass.** Every checklist item's verdict is backed by executed evidence: the command run and its captured output, the test run, the observed behavior. "The code appears to handle this" is a gap, not a pass.
2. **Assemble the checklist before verifying anything.** Gather requirements from wherever they live — a PRD, feature specs, Definition-of-Done lists, design success criteria, README claims, the conversation itself. Don't assume locations or formats. If no written requirements exist, reconstruct the checklist from the original request and label it `reconstructed`.
3. **Completeness before correctness.** First diff the checklist against what exists — a missing feature is a finding even when everything that was built works perfectly. Then verify what exists.
4. **Name the failure mode.** Every non-pass is one of: **missing** (not implemented) · **broken** (implemented, fails its check) · **unverifiable** (no demonstrable check exists — itself a finding against the spec) · **blocked** (needs environment, credentials, or access not available).
5. **Report, don't repair.** Fixing findings is out of scope unless the user asks. Findings are ordered by severity, each with what would close it.

### Do NOT

- **Do not** pass an item because tests exist — run them.
- **Do not** substitute code reading for execution when execution is possible; when it truly isn't, mark the item `inspection` and say why.
- **Do not** shrink the checklist to what was implemented — the checklist comes from the requirements, not from the code.
- **Do not** hide unverifiable or blocked items to make the verdict cleaner.
- **Do not** drift into style, naming, or architecture review — other standards own those.

## Verification Workflow

1. **Assemble the checklist.** One row per requirement, with its source (document/section, requirement or spec ID when the project uses them, or `reconstructed`).
2. **Choose the check per item**: automated test · command (curl/CLI) · scripted walkthrough · inspection (last resort, justified).
3. **Execute and capture.** Run the checks; record the command and the relevant output as evidence.
4. **Write the report** (shape below): traceability table, gaps by severity, verdict.
5. **Verdict**: `done` or `not done`. It is `not done` if any must-level requirement is missing, broken, or unverifiable. Partial credit goes in the gap list, never in the verdict.

## Report Shape

Write the report into the project's docs layout; absent one, default to `docs/verification/<milestone-or-date>-completion-report.md`.

- **Scope & sources**: what was verified, against which requirement sources.
- **Traceability table**:

| Requirement (ID · source) | Check performed | Evidence | Verdict |
| --- | --- | --- | --- |
|  | test / command / walkthrough / inspection | command + output, test run, or observation | pass / missing / broken / unverifiable / blocked |

- **Gaps**, ordered by severity — each with its failure mode and what would close it.
- **Verdict**: done / not done, plus residual risk (any blocked or inspection-only items).
