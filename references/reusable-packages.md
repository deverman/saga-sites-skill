# Reusable Packages

Extract packages only when the boundary is stable and useful across multiple sites.

## Strong Candidates

- `SagaSEO`: SEO resolution, document titles, canonicals, robots, sitemap policy,
  social images, JSON-LD helpers, and feed title policy.
- `SagaSiteDoctor`: content inventory, front matter parser, reports, duplicate
  paths, title/description/tag/image audits.
- `SagaTailwindCompiler`: hardened SwiftTailwind wrapper and `check-css`.
- `SagaImagePipeline`: rendered-HTML image enhancement and deterministic derivatives.
- `SagaCloudflareDeploy`: generic Cloudflare Pages Direct Upload CLI helpers.
- `SagaBuildMetrics`: writer timing wrappers, counters, and JSON metrics reports.
- `SagaRecommendations`: deterministic related-content data and fixed CTA
  catalog validation. Keep any model reranking outside `saga build`.

## Keep Local

- site configuration and branding
- navigation
- newsletter provider details
- visual design tokens
- case-study-specific metadata
- legacy redirect maps
- exact Cloudflare project/account names
- editorial topic catalog choices
- provider-specific newsletter or analytics behavior

## Separation Rules

- Keep packages small and cohesive.
- Avoid a "site framework" package that owns unrelated concerns.
- Prefer protocols where site policy must vary.
- Keep deterministic behavior in packages; keep editorial choices in site code.
- Add package-level tests before depending on a package from multiple sites.
- Do not let reusable packages become a second static-site framework. Each
  package should own one concern and remain optional.

## Starter Templates

Use templates to create new sites faster, but keep them easy to delete or replace.
Templates should demonstrate structure, not force a brand or content strategy.
