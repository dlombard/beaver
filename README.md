# 🦫 Beaver

> Skills for system design, software architecture, and specs — structure before code.

Beavers are nature's engineers. They read the current before they build, raise a dam
that bends the whole river, and shape a lodge log by log — nothing placed that the
structure doesn't need. Beaver brings that instinct to software: **survey the terrain,
frame the architecture, and craft the code — deliberately, structure before code.**

It's a collection of [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
that follow the open `SKILL.md` standard, so they work across skill-aware tools —
Claude Code, Codex CLI, Gemini CLI, Cursor, and more.

## What's inside

| Skill | Stage | What it does |
|---|---|---|
| [`designing-systems`](skills/designing-systems) | 🌊 Survey the current | Idea → decision-grade high-level design: constraint register, building-block selections, component inventory, data/ML flows, quality attributes, risks, SMART criteria, next-phase spec backlog. Works for software, data/ML/AI, IoT/edge, and cyber-physical systems. |
| [`architecting-software`](skills/architecting-software) | 🪵 Raise the dam | Design or review a service against **Clean Architecture** — domain independent of frameworks, DB, and providers. |
| [`crafting-code`](skills/crafting-code) | 🏠 Shape the lodge | A coding standard: a blocking process gate, four quality pillars, and the ponytail simplicity ladder. |

They chain — **designing-systems** → **architecting-software** → **crafting-code** —
or stand alone.

## Install

### Claude Code (marketplace)

```
/plugin marketplace add dlombard/beaver
/plugin install beaver@beaver
```

That installs all three skills; each then triggers on its own by description. Update
later with `/plugin marketplace update beaver`.

### Other tools (Codex CLI, Gemini CLI, Cursor, …)

The skills are standard `SKILL.md` folders, so they're portable. Clone and place the
skill folder where your tool discovers skills:

```bash
git clone https://github.com/dlombard/beaver.git
# copy any skill into your tool's skills directory, e.g. for Claude Code:
cp -R beaver/skills/designing-systems ~/.claude/skills/
```

- **Codex CLI / Gemini CLI**: both read the `SKILL.md` standard — place the skill
  folder in the tool's skills location (see each tool's Agent Skills docs).
- **Cursor**: copy the skill folder in (manual placement), or reference it from
  `.cursor/rules/`. Cursor also reads this repo's root `AGENTS.md`.

*Exact install paths per tool shift release-to-release — check each tool's current
"Agent Skills" docs for the directory.*

## Examples & evaluations

Every skill ships a runnable example with an expected outcome and a **pass/fail
grading rubric** in [`examples/`](examples/). Run one in a fresh session and grade the
result against its rubric — that's how we keep the skills honest.

## Contributing

New skills welcome — one lodge at a time. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE). The `crafting-code` skill embeds the MIT-licensed
[ponytail](https://github.com/DietrichGebert/ponytail) simplicity ladder
(© Dietrich Gebert); its license travels with the skill.
