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

The skills follow the open `SKILL.md` standard, so they work across skill-aware tools.
Pick whichever path fits your setup.

### Claude Code — marketplace

```
/plugin marketplace add dlombard/beaver
/plugin install beaver@beaver
```

Installs all three skills; each triggers on its own by description. Update later with
`/plugin marketplace update beaver`.

### Gemini CLI — extension

This repo is also a Gemini CLI extension (`gemini-extension.json`); Gemini
auto-discovers the bundled `skills/`:

```bash
gemini extensions install https://github.com/dlombard/beaver
```

(Check `gemini extensions --help` for the current install syntax.)

### Codex, Cursor & other tools — the `.agents/skills/` convention

Most non-Claude tools read skills from **`.agents/skills/`**, an emerging cross-tool
standard (Codex CLI and Gemini CLI both scan it; `.agents/skills/` takes precedence in
Gemini). Just drop the skills there:

```bash
git clone https://github.com/dlombard/beaver.git
cp -R beaver/skills/* ~/.agents/skills/          # user-level, shared across tools
# …or per project:
cp -R beaver/skills/* <your-repo>/.agents/skills/
```

Tool-specific homes also work (`~/.codex/skills/`, `~/.gemini/skills/`,
`~/.claude/skills/`); a common setup is one source of truth symlinked into the others.

*Skills directories evolve per tool — check each tool's current Agent Skills docs.*

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
