# Contributing to Beaver

Thanks for helping build the lodge. Beaver is a collection of **Agent Skills** —
each one a focused, reusable capability an AI coding agent loads on demand.

## Ways to contribute

- **Report a problem** — a skill didn't trigger when it should, over-fired, or gave
  weak guidance (see "Reporting a problem").
- **Improve an existing skill** — a missed consideration, tighter wording, a better
  rubric. Small fixes can go straight to a PR.
- **Add an example or eval case** — more graded cases keep the skills honest.
- **Propose a new skill** — open an issue first (see "Propose before you build").
- **Ask a question** — open an issue; there's no separate chat channel.

## Reporting a problem

A skill bug is a *behavior* bug, so the report needs enough to reproduce the behavior:

1. The tool and model (e.g. Claude Code + claude-sonnet-5, Codex CLI + …).
2. The exact prompt you gave, in a fresh session.
3. Whether the skill actually triggered, and how you know — it was invoked/loaded,
   not just skill-shaped output.
4. What you expected vs. what happened.

## Propose before you build

Before writing a new skill — or structurally changing an existing one — **open an
issue describing it**: what it forces the agent to do, when it should trigger, and why
it belongs in this collection. Agreeing on the idea first protects your time from
building something the collection won't take. Typo and wording fixes skip this.

## The mechanics

1. **Fork** the repo and create a branch.
2. Make the change.
3. **Verify it** — see "Examples & evals" below; note the result in your PR.
4. Open a PR against `main`. PRs are **squash-merged**: the PR title becomes the
   commit message, so write it accordingly; commit hygiene inside the PR doesn't
   matter.
5. Don't bump versions in the manifests (`.claude-plugin/`, `.codex-plugin/`,
   `gemini-extension.json`) — releases are a maintainer action.

By submitting a PR you agree your contribution is licensed under the repo's MIT
license (inbound = outbound).

## Repo layout

```
beaver/
├── .claude-plugin/
│   ├── plugin.json                 # the single "beaver" plugin (bundles all skills)
│   └── marketplace.json            # publishes the beaver plugin
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md                # the skill (required)
│       └── references/…            # optional supporting files (one level deep)
├── examples/<skill-name>/          # runnable examples + grading rubric
├── evals/                          # A/B eval harness, cases, grading log
├── AGENTS.md                       # cross-tool index
├── README.md
└── LICENSE
```

## Adding a skill

1. **Name it as a gerund action verb** — `designing-`, `architecting-`, `crafting-`,
   `reviewing-`, etc. Kebab-case, `<verb>-<object>` (e.g. `migrating-databases`).
   Lowercase letters/numbers/hyphens only, ≤ 64 chars, and avoid the reserved words
   `anthropic`/`claude`.
2. **Create the folder**: `skills/<name>/SKILL.md`. It's automatically part of the
   `beaver` plugin — no per-skill manifest needed.
3. **Write the `SKILL.md` frontmatter** (two fields, kept standard for portability):
   - `name`: the kebab-case skill name.
   - `description`: **this is what makes the skill trigger.** Write it in the **third
     person**, **≤ 1024 characters**. Say *when* to use it in the words a user actually
     types, name the domain breadth, and keep a scope exclusion so it doesn't
     over-fire. Triggering is governed entirely by this field, not the body — test it
     in a fresh session.
4. **Keep the body lean (progressive disclosure).** SKILL.md under ~500 lines; move
   long detail into `references/` and link it **one level deep** from SKILL.md, telling
   the agent *when* to load each file. Add a short table of contents to any reference
   over ~100 lines.
5. **Keep it a forcing function, not a textbook.** Favor terse checklists, opinionated
   **defaults (not menus of options)**, and clear "do / do not" over re-teaching what a
   capable model already knows.
6. **Stay vendor-neutral and un-branded.** No internal product codenames or
   company-specific examples; use widely known, open, or multi-vendor examples.
7. **Add an example** under `examples/<name>/` with a prompt, the expected outcome,
   and a **pass/fail grading rubric** (see `examples/README.md` for the format) — and
   at least one eval case under `evals/<name>/` (a `prompt.txt` + `SUCCESS.md`).

## Modifying an existing skill

- Touching the **description**? It alone governs triggering — keep it third person and
  ≤ 1024 chars, then re-test in a fresh session that the skill still fires on a
  realistic prompt (and doesn't over-fire).
- Touching the **body**? Re-run the skill's example against its rubric.
- A behavior change updates the example/rubric **in the same PR** — the `[sync]` rule
  applies to this repo too.

## Examples & evals (how changes are verified)

- **`examples/<skill>/`** — the public test surface: a prompt, the expected outcome,
  and a pass/fail rubric. Run it in a fresh session, grade the result, and note the
  grade in your PR description.
- **`evals/`** — the A/B harness (`evals/run.sh`) that measures a skill against a
  no-skill baseline in three modes (baseline / trigger / treatment), scoring
  triggering from the transcript rather than from output shape. Graded results live
  in `evals/GRADING.md`; adversarial findings in `evals/REVIEW.md`. Run **outputs**
  (`evals/*/*/out/`) are billed sessions and stay local (gitignored).
- The bar: a skill — or a change to one — earns its place by **uplift**: the
  treatment run clears a bar the baseline does not.

## AI-assisted contributions

This is a repo of skills *for* coding agents, and using an agent to write your
contribution is welcome and expected. The rule: **you** verify the result. Run the
example in a fresh session yourself, confirm the skill triggered, and grade the
rubric — don't submit unverified agent output.

## Where skills write output

Skills that generate documents write them under **`docs/`** in the target repo, by
category, so the collection composes as a pipeline:

| Category | Location | Produced by |
|---|---|---|
| Product definition (PRD) | `docs/product/` | `defining-products` |
| System design artifacts | `docs/design/` | `designing-systems` |
| Architecture Decision Records | `docs/adr/` | `architecting-software`, `crafting-code` |
| Specs | `docs/specs/` | `specifying-features` (consumed by `crafting-code`'s `[spec]` gate) |
| API contracts (OpenAPI) | `docs/api/` | `crafting-code` |
| Verification reports | `docs/verification/` | `verifying-completion` |

If the target repo already uses a different documentation layout, **conform to it**
instead of imposing this one. A new skill that emits documents should follow this
convention (add its category above). These locations are **defaults, not contracts**:
a skill that consumes another skill's artifact must discover it in the project (or
work without it) — never hardcode the path or require the artifact to exist.

## Licensing

- Contributions are MIT-licensed (see `LICENSE`).
- If a skill embeds third-party material, include its license file alongside the
  skill and add an **Attribution** section to the `SKILL.md` (see
  `skills/crafting-code` and its `LICENSE-ponytail` for the pattern).

## Code of conduct

Be kind and assume good faith. The full text lives in
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Before you open a PR

- Confirm the skill **triggers on its own** from a fresh session on a realistic
  prompt (not just when named explicitly).
- Run its example and check the output against the rubric; note the grade in the PR.
- No stray files (`.DS_Store`, editor swapfiles, `evals/*/*/out/`) and no symlinks in
  the skill folder.
