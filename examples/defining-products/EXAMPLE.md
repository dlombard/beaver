# Example — defining-products

**Skill:** `defining-products` · **Grade scale:** see [../README.md](../README.md)

Run in a fresh session in an empty directory. The skill should trigger on its own.

## Prompt

> We're building a habit tracker for remote teams. A manager creates shared habits
> ("post a daily standup", "write weekly retro notes"), teammates check in, everyone
> sees streaks, and a weekly digest goes out. Write the PRD.

## What the skill should do

Turn the pitch into a decision-grade PRD: an enumerated, prioritized feature list with
stable requirement IDs, product-level acceptance criteria, measurable success metrics,
milestones, and explicit non-goals — surfacing the load-bearing features the pitch
forgot (identity, roles, invitations, notifications) as conscious includes/excludes.

## Reference — what good looks like

- **The feature list is rows, not prose** — each with an ID (`FR-1…`), a MoSCoW
  priority, and acceptance criteria. The MVP is the Must set, and it's a real cut
  (streak history, integrations, digests can wait; check-ins can't).
- **The completeness checklist catches what the pitch forgot**: "manager creates,
  teammates check in" implies **auth, roles/permissions, and invitations** — Musts the
  prompt never mentions. Notifications (the digest implies a channel), data deletion,
  and admin appear as conscious includes or excludes with reasons.
- **Acceptance criteria are observable and product-level**: "when a member checks in,
  the team's streak view reflects it on next load" — not "the system stores check-ins
  in a database".
- **Success metrics are measurable** — a number, a source, a time frame (e.g. "60% of
  invited members check in ≥3×/week by week 4, from product analytics"), not "teams
  are engaged".
- **Unknowns handled**: platform, pricing, and team size aren't stated — ≤5 questions
  or labeled assumptions, never silent guesses. Anything the skill adds beyond the
  pitch (e.g. billing) is marked `proposal`.
- **No architecture, no UI**: no tech stack, no data model, no wireframes — that's
  later phases.

## Rubric

**Must (all required to pass):**
1. Produces an **enumerated feature table** with stable IDs and MoSCoW priorities —
   and not everything is a Must.
2. Surfaces **identity, roles/permissions, and invitations** as features (the pitch
   implies them but never says them), and shows other checklist categories as
   conscious includes/excludes.
3. Every Must-have has at least one **observable, product-level acceptance
   criterion** (no implementation flavor).
4. **Success metrics** have a number, a source, and a time frame.
5. States **non-goals**, and handles unknown platform/pricing/scale with ≤5 questions
   or **labeled assumptions**.

**Failure signals (any ⇒ fail):**
- Features described in prose with no IDs or priorities.
- Misses that manager/member implies roles and invitations.
- Designs the architecture, data model, tech stack, or UI instead of the product.
- Vanity metrics ("high engagement", "users love it").
- Silently invents scope (e.g. billing plans) with no `proposal` label, or silently
  picks a platform.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = minor gaps only · ❌ Fail =
any Must missed or any signal present.
