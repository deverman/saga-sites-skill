# Saga Sites Skill

A [Claude Code](https://claude.ai/code) skill for building, designing, migrating, maintaining, and deploying Swift [Saga](https://github.com/loopwerk/Saga) static sites.

Covers the full Saga workflow: pipeline design, typed Markdown metadata, Tailwind/SwiftTailwind styling, SEO, responsive images, SiteDoctor-style audits, Swift ArgumentParser site CLIs, build performance, and Cloudflare Pages or GitHub Pages deployment.

## Install

### Install with the Claude Code CLI

```bash
claude plugin install https://github.com/deverman/saga-sites-skill
```

### Install via Claude Code settings

1. Open Claude Code.
2. Run `/config` and open **Settings**.
3. Go to **Plugins** → **Add plugin**.
4. Enter the repository URL:

   ```
   https://github.com/deverman/saga-sites-skill
   ```

5. Confirm the install.

### Verify the install

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
| `SKILL.md` | Skill prompt loaded by agents |
| `agents/openai.yaml` | Display name and interface metadata |
| `references/` | Domain knowledge documents (routing in `SKILL.md`) |
| `assets/templates/minimal-site/` | Copyable Saga starter (two-target Swift package) |
| `assets/templates/*/README.md` | Blog, landing page, case study, and WordPress migration starting points |
| `assets/tools/skill-validator/` | Swift CLI that validates `SKILL.md` front matter |

## Related Skills

- [frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) — Tailwind and design system work
- [marketing-skills](https://github.com/coreyhaines31/marketingskills) — Copywriting, SEO, and content strategy
