# Saga Sites Skill Creation Plan

## Summary

Create a `saga-sites` Codex skill for building world-class Swift Saga websites:
new sites, landing pages, blogs, case-study sites, and WordPress migrations. The
skill is Saga-first, with `deverman-saga-site` as the main reference
architecture.

The skill should keep `SKILL.md` concise and move detailed patterns into
references. It should include starter templates, reference code, and
deterministic CLI helpers where they improve repeatability.

## Key Changes

- Create `skills/saga-sites/` with:
  - `SKILL.md`
  - `agents/openai.yaml`
  - `references/`
  - `assets/templates/`
  - `assets/tools/skill-validator/` as a Swift ArgumentParser replacement for
    the Python `quick_validate.py`
- Keep this planning collateral in the standalone `saga-sites-skill` repository,
  not in downstream Saga site repositories.
- Maintain `assets/templates/minimal-site/` as the copyable reference starter:
  a Swift package with `SiteCore`, an ArgumentParser command target, Markdown
  pages/posts, Tailwind via SwiftTailwind, generated writing/tag/category
  archives, sitemap, tests, and a generic Cloudflare Pages deploy command.
- Keep deterministic utilities as Swift reference code, Swift packages, or Swift
  ArgumentParser command templates. Do not add Python helper scripts for
  creating or managing Swift Saga sites.
- Document when to invoke adjacent Cloudflare, GitHub, Browser, web-performance,
  Tailwind/CSS, and skill-creator skills.
- Treat imported Swift packages as the Saga site operating system, not incidental
  dependencies.
- Default new sites to full tag/category archives. Curated topics remain future
  guidance, not the v1 default.

## Reusable Code And Plugin Strategy

Prefer focused packages/plugins with clean separation of concerns:

- `SagaSEO`: SEO resolution, canonicals, robots/sitemap policy, social metadata,
  JSON-LD helpers, and feed title policy.
- `SagaSiteDoctor`: content inventory, Markdown/front matter parsing, reports,
  duplicate paths, metadata coverage, and content audits.
- `SagaTailwindCompiler`: hardened SwiftTailwind wrapper, temp-file validation,
  and `check-css`.
- `SagaImagePipeline`: rendered-HTML image enhancement, deterministic
  derivatives, dimensions, `srcset`, and loading hints.
- `SagaCloudflareDeploy`: generic Cloudflare Pages Direct Upload helpers for any
  Cloudflare account/project.
- `SagaBuildMetrics`: writer/render timing, JSON snapshots, and archive/build
  mode reporting.

Keep site-specific policy local: brand/theme layout, navigation, newsletter
provider specifics, case-study details, Cloudflare project names, and migration
redirect maps.

## Test Plan

- Validate the skill folder with the Swift skill validator.
- Validate the Swift starter template with `swift build` where dependency
  resolution is available.
- Inspect that all reference files linked from `SKILL.md` exist.
- Confirm `agents/openai.yaml` matches the skill purpose.
- Later forward-test with realistic prompts:
  - create a new Saga landing page
  - convert a WordPress site
  - add SEO metadata support
  - add Cloudflare Pages deploy support
  - improve build performance on a large archive-heavy site

## Assumptions

- The skill lives in the repo for review and is copied to `~/.codex/skills` for
  Codex discovery.
- Cloudflare deploy helpers should be generic across Cloudflare accounts, but do
  not need non-Cloudflare hosting support.
- Package boundaries should follow separation of concerns rather than a
  predetermined package count.
