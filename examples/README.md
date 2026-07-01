# Examples & Evaluations

Each skill ships a worked example so you can **see the expected outcome** and judge a
run objectively. These double as lightweight evals: run the prompt, then grade the
result against the rubric.

## How to run one

1. Open a **fresh session** in your agent (empty working directory for the design
   example; for the code examples, paste in the provided snippet).
2. Give the example's **Prompt** verbatim.
3. Confirm the skill **triggers on its own** (you shouldn't have to name it). If it
   doesn't, that's a triggering finding — note it.
4. Grade the output against the example's **rubric**.

## Grade scale (used by every example)

| Grade | Meaning |
|---|---|
| ✅ **Pass** | Hits **every** "Must" criterion and shows **no** failure signal. |
| ⚠️ **Partial** | Hits most Musts; minor gaps only; no failure signal that undermines the result. |
| ❌ **Fail** | Misses **any one** Must, **or** shows **any** failure signal. |

## The grading philosophy

These skills are **forcing functions against omission** — a capable model usually has
the knowledge but skips the consideration under the pressure of producing an answer.
So we grade on **whether the right considerations were raised and justified**, not on
prose or on getting a single "right" architecture. Specifically:

- **Musts** are the load-bearing moves the skill exists to force (e.g. "elicited the
  constraints," "flagged the provider SDK in the core"). Missing one is a fail.
- **Failure signals** are the tell-tale signs the skill didn't really run (e.g.
  "rubber-stamped it," "invented vanity numbers," "bolted on an LLM with no reason").
- **Reference — what good looks like** gives a concrete target, not the *only* correct
  answer. Different sound designs can pass.

Each example is deliberately **under-specified** where a real prompt would be, so a
passing run has to either ask or state labeled assumptions — never silently guess.
