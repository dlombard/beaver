# Contributing to Beaver

Thanks for helping build the lodge. Beaver is a collection of **Agent Skills** —
each one a focused, reusable capability an AI coding agent loads on demand.

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
   and a **pass/fail grading rubric** (see `examples/README.md` for the format).

## Where skills write output

Skills that generate documents write them under **`docs/`** in the target repo, by
category, so the collection composes as a pipeline:

| Category | Location | Produced by |
|---|---|---|
| System design artifacts | `docs/design/` | `designing-systems` |
| Architecture Decision Records | `docs/adr/` | `architecting-software`, `crafting-code` |
| Specs | `docs/specs/` | `crafting-code` |
| API contracts (OpenAPI) | `docs/api/` | `crafting-code` |

If the target repo already uses a different documentation layout, **conform to it**
instead of imposing this one. A new skill that emits documents should follow this
convention (add its category above).

## Licensing

- Contributions are MIT-licensed (see `LICENSE`).
- If a skill embeds third-party material, include its license file alongside the
  skill and add an **Attribution** section to the `SKILL.md` (see
  `skills/crafting-code` and its `LICENSE-ponytail` for the pattern).

## Before you open a PR

- Confirm the skill **triggers on its own** from a fresh session on a realistic
  prompt (not just when named explicitly).
- Run its example and check the output against the rubric.
- No stray files (`.DS_Store`, editor swapfiles) and no symlinks in the skill folder.
