# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This is the **`saga-sites` Codex skill** — a skill definition and asset library that teaches AI agents how to build, maintain, and deploy Swift [Saga](https://github.com/loopwerk/Saga) static sites. It is not itself a Saga site.

The skill is defined in `skills/saga-sites/SKILL.md` (the skill prompt), `.claude-plugin/` (marketplace and plugin manifests), and `agents/openai.yaml` (interface metadata). The `references/` directory contains the domain knowledge the skill draws on. The `assets/` directory contains copyable site templates and Swift tooling.

## Commands

### Skill Validator (Swift tool in `assets/tools/skill-validator/`)

```bash
cd assets/tools/skill-validator
swift build
swift test
swift run swift-skill-validate ../../   # validate this skill's SKILL.md
```

### Minimal Site Template (Swift site in `assets/templates/minimal-site/`)

```bash
cd assets/templates/minimal-site
swift build
swift test
saga build
swift run ExampleSagaSite check-css
swift run ExampleSagaSite deploy --project-name your-pages-project --dry-run
```

## Architecture

```
.claude-plugin/
  marketplace.json              # Marketplace manifest (required for `plugin marketplace add`)
  plugin.json                   # Plugin manifest (name, version, skills path)
skills/
  saga-sites/
    SKILL.md                    # The skill prompt loaded by agents
agents/openai.yaml              # Display name, short description, default prompt
references/                     # Domain knowledge documents (read by the skill at runtime)
assets/
  templates/
    minimal-site/               # Copyable Saga starter (one executable + SiteCore library)
    blog/README.md              # Blog variant starting point
    case-study/README.md        # Portfolio/case-study variant
    landing-page/README.md      # Landing page variant
    wordpress-migration/README.md
  tools/
    skill-validator/            # Swift ArgumentParser CLI that validates SKILL.md front matter
docs/                           # Planning and audit docs (not loaded by agents)
```

### Key design decisions

- `SKILL.md` routes to specific `references/` files for each topic area rather than inlining everything — this keeps the skill prompt focused and the knowledge docs independently maintainable.
- The minimal-site template uses a two-target layout: one `SiteCommand` executable (for `saga build`/`saga dev` compatibility) and one `SiteCore` library target (testable). This is the canonical structure the skill recommends for all new Saga sites.
- All deterministic tooling in this repo is Swift (Swift ArgumentParser), not Python — consistent with the skill's guidance to Saga site operators.

### Modifying the skill

- Edit `skills/saga-sites/SKILL.md` to change operating rules, reference routing, or first-move guidance.
- Edit files under `references/` to update domain knowledge without touching the skill prompt.
- After adding a new reference file, add a routing entry in the `## Reference Routing` section of `SKILL.md`.
- `assets/templates/minimal-site/` is the reference implementation; keep it consistent with `references/site-structure.md` and `references/saga-architecture.md`.
