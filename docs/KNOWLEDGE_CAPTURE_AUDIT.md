# Knowledge Capture Audit

This audit answers whether the `saga-sites` skill captures the transferable
knowledge from `deverman-saga-site`.

## Captured In Skill References

| Area | Where Captured |
|---|---|
| Saga pipeline, register passes, build modes | `references/saga-architecture.md`, `references/lessons-from-history.md` |
| Package roles as a site operating system | `references/package-operating-system.md` |
| Maintainable package/source/content layout | `references/site-structure.md` |
| Canonical `path:`, title vs SEO title, feeds, sitemap, JSON-LD | `references/content-and-seo.md`, `references/lessons-from-history.md` |
| Modular Tailwind, SwiftTailwind hardening, style guide sync | `references/design-and-tailwind.md`, `references/lessons-from-history.md` |
| Image audit and rendered-HTML responsive image pipeline | `references/images.md`, `references/lessons-from-history.md` |
| Writer timing, fast dev archives, generated output policy | `references/performance.md`, `references/lessons-from-history.md` |
| SiteDoctor non-mutating audits and AI proposal workflows | `references/site-doctor.md`, `references/lessons-from-history.md` |
| Local Cloudflare Pages Direct Upload and validation-vs-deploy split | `references/deployment.md`, `references/lessons-from-history.md` |
| WordPress URL, media, taxonomy, and redirect preservation | `references/migration-playbook.md`, `references/content-and-seo.md` |
| Reusable package candidates and separation of concerns | `references/reusable-packages.md` |
| Copyable reference implementation | `assets/templates/minimal-site/` |

## History Lessons Covered

- PR #14: upstream Saga architecture and local SEO direction.
- PR #16 and issue #6: modular Tailwind source, focused CSS ownership, and CSS
  tests.
- PR #17 and issue #7: image audit, rendered-HTML transformation, deterministic
  derivatives, and WordPress media preservation.
- PR #18 and issue #3: central SEO contract, JSON-LD tests, canonical/sitemap
  policy, and generated-output smoke checks.
- PR #19 and issue #2: writer-level timing before performance work.
- PR #20 and issue #9: fast dev archive mode only after measuring archive cost.
- PR #27 and issue #4: SiteDoctor as a non-mutating Swift ArgumentParser CLI.
- PR #28 and issues #22, #23, #25, #26: feed SEO policy and smaller
  token-friendly source files.
- Issue #8: topic hubs are future strategy; v1 new sites keep full archives.
- Issue #10: AI SEO proposals stay outside `saga build`.
- Issue #11: prefer upstream Saga and document general improvement candidates.
- Issue #12: link, Lighthouse, and snapshot checks are validation layers, not
  deploy steps.
- Issue #21: image weight must be measured while preserving legacy URLs.
- Issue #29 and deploy commits: local Cloudflare Direct Upload, short deploy
  command, generated output out of Git.
- PR #31 and Tailwind hardening commits: temporary CSS output and non-empty
  validation before replacing generated CSS.

## Intentionally Not In The Installed Skill

- Site-specific brand copy, newsletter provider URLs, analytics IDs, and visual
  tokens.
- Exact Cloudflare project names and account identifiers.
- Full `deverman-saga-site` source code.
- Repo-only planning documents. They live in this private skill repository under
  `docs/`, but are excluded from the installed skill copy.

## Remaining Leverage Opportunities

- Extract `SagaSEO`, `SagaSiteDoctor`, `SagaTailwindCompiler`,
  `SagaImagePipeline`, `SagaCloudflareDeploy`, and `SagaBuildMetrics` only after
  a second site confirms the boundaries.
- Forward-test the skill by creating a new landing-page site, a blog site, and a
  small WordPress migration from the starter template.
- Add richer starter variants only if the minimal reference template proves too
  slow to adapt in practice.
- Add scheduled link/Lighthouse/snapshot examples once at least one downstream
  site needs them.
