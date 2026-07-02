# Success Criteria — P1-habit-tracker (defining-products)

**Prompt intent:** a product pitch with the classic gaps — no platform, no pricing,
no team size, and the load-bearing features (auth, roles, invitations, notifications)
implied but never stated.

## Baseline expectation (no skill)

A capable model writes a decent prose PRD: sections, features, maybe personas. It
typically **doesn't** produce an enumerated feature table with stable IDs and MoSCoW
priorities, **doesn't** systematically surface identity/roles/invitations as conscious
includes, and writes at least some unmeasurable success metrics.

## Treatment success criteria

**Must (all required to pass):**

1. An **enumerated feature table** with stable IDs (`FR-…`) and MoSCoW priorities —
   and not everything is a Must (a real MVP cut).
2. **Identity, roles/permissions, and invitations** appear as features (the pitch
   implies them but never says them); other checklist categories (data deletion,
   admin, billing) show up as conscious includes or excludes with reasons.
3. Every Must-have has at least one **observable, product-level acceptance
   criterion** (no implementation flavor — no queues, schemas, or stacks).
4. **Success metrics** each have a number, a source, and a time frame.
5. **Non-goals** stated; unknown platform/pricing/scale handled with ≤5 questions or
   **labeled assumptions** — and delivered *alongside* a first-pass PRD, never
   questions alone.

**Failure signals (any ⇒ fail):**

- Features in prose only — no IDs, no priorities.
- Misses that manager/member implies roles and invitations.
- Designs the architecture, data model, tech stack, or UI instead of the product.
- Vanity metrics ("high engagement", "users love it").
- Silently invents scope (e.g. billing plans) with no `proposal` label, or silently
  picks a platform.

## Triggering

The trigger question: does a bare "Write the PRD" pitch fire the skill without it
being named? Grade from `loaded-turn1.txt`.
