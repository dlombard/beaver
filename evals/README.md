# Evaluations

A/B evaluation of the beaver skills: run the same prompt **without** the skill
(baseline) and **with** it (treatment), then compare against per-case success
criteria. This is how we prove a skill actually changes behavior — not just that it
reads well.

> `examples/` shows what good output *looks like* (for humans to read). `evals/` is
> the runnable harness that *measures* the skill against a no-skill baseline.

## What each case tests

Every case checks some of:

- **Triggering** — does the skill fire on its own (the `trigger` mode)?
- **Expected material** — does it produce the artifacts / findings it should?
- **Sustaining a conversation** — a `followup.txt` turn ("this element is wrong,
  tweak it") checks the skill revises the *right* element without redoing everything.
- **Skill-specific behavior** — e.g. does `crafting-code`'s **intensity** (lite vs
  ultra) actually change what it does?

## The three run modes

| Mode | Flags | Question it answers |
|---|---|---|
| `baseline` | `--safe-mode` | What does the agent do **without** the skill? |
| `trigger` | `--plugin-dir beaver --setting-sources project,local` | Does the skill **fire on its own**? |
| `treatment` | trigger + `--append-system-prompt` forcing the skill | What does the skill **do** when used? |

`--safe-mode` disables all custom skills (and your `~/.claude/skills`) while keeping
auth + model, so baseline is clean. `--plugin-dir` does **not** load under safe-mode,
so trigger/treatment load beaver directly and drop user skills via
`--setting-sources project,local` — leaving only beaver + built-ins.

## Running

```bash
# one case, one mode  (uses $MODEL, default claude-sonnet-5)
evals/run.sh crafting-code C1-simplify baseline
evals/run.sh crafting-code C1-simplify treatment

# a full A/B for every case (same model both sides):
for skill in defining-products designing-systems architecting-software \
             specifying-features crafting-code verifying-completion; do
  for case in evals/$skill/*/; do c=$(basename "$case")
    evals/run.sh "$skill" "$c" baseline
    evals/run.sh "$skill" "$c" trigger
    evals/run.sh "$skill" "$c" treatment
  done
done
```

Outputs land in `evals/<skill>/<case>/out/<mode>/`:
`turn1.txt` (final answer), `turn1.json` (full result + cost + session id),
`turn2.*` (the follow-up turn), and `docs/` (any files the run wrote).

**Cost note:** each run is a real, billed Claude session; a full matrix is ~20+
sessions. Run a subset first.

### Seeding the workspace

A case can pre-populate the sandbox so "build"/"gate" behavior is observable instead of
stalling on an empty directory:

- `evals/<skill>/<case>/seed/` — copied into the workspace **before turn 1** (e.g. a
  starter project).
- `evals/<skill>/<case>/seed-followup/` — copied in **before the follow-up turn** (e.g.
  an approved spec that turn 2 must find on disk).

## Grading

Open each case's `SUCCESS.md`. It defines the **baseline expectation** (what a
no-skill run typically misses) and the **treatment success criteria** (Must-hit
items + failure signals). Grade with the shared scale:

| Grade | Meaning |
|---|---|
| ✅ **Pass** | Treatment hits every Must and shows no failure signal. |
| ⚠️ **Partial** | Most Musts; minor gaps; no undermining failure. |
| ❌ **Fail** | Misses a Must or shows a failure signal. |

The point of the A/B is **uplift**: a skill earns its place only if `treatment`
clears the bar that `baseline` does not. Record both in `GRADING.md`.

## Confirming the skill actually loaded (hard signal)

Do **not** score triggering from output shape (tags/artifacts) — a strong model can
produce skill-shaped output without ever invoking the skill. Every `trigger`/`treatment`
run writes **`loaded-turnN.txt`**, derived from the stream-json transcript:

- `yes: Skill(<name>)` — the model actually invoked the skill and loaded its body.
- `no` — the skill never fired; the answer is model-native.

Grade "Triggered?" from that file. (Observed: `designing-systems` and an explicit
architecture review invoke the skill on their own; small snippet questions often don't —
they only load when forced in `treatment`.)
