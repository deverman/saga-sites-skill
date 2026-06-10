---
name: saga-sites
description: Build, design, migrate, maintain, optimize, audit, or deploy Swift Saga static sites. Use for Saga landing pages, blogs, case-study/portfolio sites, WordPress migrations, typed Markdown metadata, SEO contracts, Tailwind/SwiftTailwind styling, responsive image pipelines, SiteDoctor-style audits, Swift ArgumentParser site CLIs, build performance, full archive generation, and Cloudflare Pages Direct Upload workflows.
---

# Saga Sites

Use this skill to operate a Swift Saga website as a coherent system: Saga pipeline, Swift package layout, content model, theme, Tailwind CSS, SEO, audits, images, tests, and Cloudflare deployment.

## First Moves

1. Inspect `Package.swift`, `Sources/`, `content/`, `Tests/`, CI, docs, and recent GitHub history before editing.
2. Identify the task type: new site, landing page, content/theme work, WordPress migration, SEO, images, performance, CLI, or deployment.
3. Prefer upstream Saga and local site policy. Do not fork Saga for site-specific behavior.
4. Keep one executable target for Saga CLI compatibility and put reusable behavior in a testable library target.
5. Use Swift ArgumentParser for maintenance commands instead of ad hoc shell scripts.

## Operating Rules

- Model front matter with strongly typed `Metadata`; treat `path:` as canonical.
- Keep prose, lists, static sections, cards, and migration content in Markdown. Keep Swift renderers structural.
- Use Saga's explicit pipeline: readers, `itemProcessor`, writers, `beforeRead`, `postProcess`, `afterWrite`, and `createPage`.
- Default new sites to full tag/category archives. Add fast-dev archive skipping only after metrics show archives dominate local rebuilds.
- Centralize SEO across document titles, canonical URLs, robots, sitemap, Open Graph/Twitter, feeds, and JSON-LD.
- Compile Tailwind through SwiftTailwind from modular source files. Do not hand-edit generated CSS.
- Put classes used only in Swift strings or raw Markdown HTML in `@layer components`.
- Transform rendered HTML with a parser such as SwiftSoup. Avoid regex over Markdown for HTML rewrites.
- Keep generated output and derivatives deterministic; ignore generated files in watch mode.
- Keep AI/content suggestions in SiteDoctor-style proposal commands; never make `saga build` nondeterministic.
- Never run `saga build`, a no-subcommand Swift site run, or deploy while `saga dev` is active if they share the output directory (`deploy/` for Cloudflare Pages, `docs/` for GitHub Pages).
- GitHub Pages sites output to `docs/` and commit that directory; Cloudflare Pages sites output to `deploy/` and should gitignore it.

## Reference Routing

- Read `references/saga-architecture.md` for pipeline design and build modes.
- Read `references/lessons-from-history.md` when starting a new site, migration, or major refactor; it records the hard-won decisions from `deverman-saga-site`.
- Read `references/package-operating-system.md` before adding, removing, or generalizing packages.
- Read `references/site-structure.md` for project layout and source organization.
- Read `references/content-and-seo.md` for metadata, URLs, feeds, sitemap, JSON-LD, and WordPress preservation.
- Read `references/design-and-tailwind.md` for theme and CSS work.
- Read `references/performance.md` for archive strategy, metrics, and generated output.
- Read `references/images.md` for image audits and responsive derivatives.
- Read `references/site-doctor.md` for audits, reports, and AI proposal flows.
- Read `references/deployment.md` for Cloudflare Pages deploy CLI patterns.
- Read `references/migration-playbook.md` for WordPress conversions.
- Read `references/reusable-packages.md` before extracting shared packages or plugins.

## Adjacent Skills

- Use Cloudflare skills for current Pages, Wrangler, `_headers`, `_redirects`, API, account, and auth details.
- Use GitHub skills for PR/issue history, review comments, CI logs, or publishing branches.
- Use Browser for local visual checks after frontend/theme changes.
- Use web-performance for Lighthouse, Core Web Vitals, asset weight, and page-speed work.
- Use a Tailwind/CSS skill if one is available for deep Tailwind v4 or design-system problems.
- Use skill-creator when changing this skill's structure or metadata.

## Assets And Swift Utilities

- `assets/templates/minimal-site/` is the copyable Saga starter/reference site; read its `TEMPLATE.md` before adapting it.
- `assets/templates/*/README.md` files describe landing-page, blog, case-study, and WordPress migration starting points.
- `assets/tools/skill-validator/` is a Swift ArgumentParser replacement for `quick_validate.py`.
- Deterministic utilities for Saga sites should be implemented as Swift packages or Swift ArgumentParser commands, not Python helper scripts.
