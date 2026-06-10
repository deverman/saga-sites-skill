# Saga Sites Skill

A [Claude Code](https://claude.ai/code) skill for building, designing, migrating, maintaining, and deploying Swift [Saga](https://github.com/loopwerk/Saga) static sites.

Covers the full Saga workflow: pipeline design, typed Markdown metadata, Tailwind/SwiftTailwind styling, SEO, responsive images, SiteDoctor-style audits, Swift ArgumentParser site CLIs, build performance, and Cloudflare Pages or GitHub Pages deployment.

## Install

Installing a skill is a two-step process: first add this repository as a **marketplace**, then install the skill from it.

### Step 1 — Add the marketplace

```
/plugin marketplace add deverman/saga-sites-skill
```

### Step 2 — Install the skill

```
/plugin install saga-sites@saga-sites-skill
```

### Verify

After installing, type `/saga-sites` in any Claude Code prompt. The skill will activate and confirm it is ready.

## Use

Once installed, start a prompt with `/saga-sites` to activate the skill, or simply describe a Saga site task — Claude Code will load the skill automatically when it recognizes the context.

Example prompts:

- `/saga-sites Build a landing page for my app using the minimal-site template.`
- `/saga-sites Migrate my WordPress export to a Saga site.`
- `/saga-sites Add Open Graph tags, a sitemap, and a JSON-LD breadcrumb to my existing site.`
- `/saga-sites Set up Cloudflare Pages Direct Upload deployment for my site.`

## What's Inside

| Path | Purpose |
|---|---|
| `.claude-plugin/marketplace.json` | Marketplace manifest |
| `.claude-plugin/plugin.json` | Plugin manifest |
| `skills/saga-sites/SKILL.md` | Skill prompt loaded by agents |
| `agents/openai.yaml` | Display name and interface metadata |
| `references/` | Domain knowledge documents (routed from the skill) |
| `assets/templates/minimal-site/` | Copyable Saga starter (two-target Swift package) |
| `assets/templates/*/README.md` | Blog, landing page, case study, and WordPress migration starting points |
| `assets/tools/skill-validator/` | Swift CLI that validates skill front matter |

## Related Skills

- [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) — Tailwind and design system work
- [marketing-skills](https://github.com/coreyhaines31/marketingskills) — Copywriting, SEO, and content strategy
