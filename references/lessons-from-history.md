# Lessons From Deverman Saga Site

This reference captures durable lessons from the `deverman-saga-site` history.
Use it to understand why the skill prefers these patterns.

## Architecture

- Stay on upstream `loopwerk/Saga`. Put site policy in local code or focused
  reusable packages; do not carry a Saga fork for site-specific behavior.
- Keep one executable product for Saga CLI compatibility, but move build logic,
  metadata, renderers, SiteDoctor code, and deploy helpers into a testable
  library target.
- Prefer explicit Saga registrations over clever routing. Register posts, claim
  special page sources such as `/writing/`, then register normal pages.
- When a list writer owns a destination such as `/writing/`, claim the backing
  Markdown page without a page writer so two writers do not fight over the same
  output path.
- Use `routePage` only as structural dispatch by `metadata.template` or
  canonical `metadata.path`.
- Split large source files once they become hard to review or load into agent
  context. Keep comments short and explanatory, not noisy.

## Content And URLs

- `path:` is the public contract. Do not derive imported URLs from filenames or
  casually rewrite WordPress numeric slugs.
- Keep prose, static project cards, timelines, lists, and page copy in Markdown.
  Swift renderers should provide structure and dynamic data only.
- Keep visible H1 and SEO title separate. Parsley extracts Markdown H1 text for
  `item.title`, including emphasis markers, so metadata/feed/JSON-LD paths must
  use a plain-text SEO resolver.
- Raw HTML in Markdown is acceptable for reusable editorial components, but
  stable CSS for those classes must live in `@layer components`.
- Newsletter forms, subscriber gates, analytics, and provider URLs are
  site-specific. The transferable lesson is to test the real POST/redirect
  behavior and avoid provider redirects that convert POSTs to GETs.

## SEO

- Treat SEO as a central data policy, not layout string duplication. Resolve
  document titles, canonical URLs, descriptions, robots, sitemap eligibility,
  social images, feeds, and JSON-LD through one layer.
- Use typed `Encodable` JSON-LD payloads and `JSONEncoder`; do not hand-build
  JSON strings.
- Feed titles must use the same SEO title policy as HTML metadata and JSON-LD.
- Include generated archives in production by default for new sites. For large
  migrated sites, skip long-tail archives only in fast dev mode and only after
  metrics show archives dominate rebuild time.
- Thin tag policy belongs in SEO strategy. Curated topic hubs are a future
  improvement; v1 new sites should still generate full tag/category archives.
- Snapshot or smoke-check representative generated pages for canonical tags,
  JSON-LD parseability, sitemap membership, nav structure, feeds, and archive
  pagination.

## Tailwind And Theme Work

- Treat Tailwind source as modules with a small import entrypoint. Keep design
  tokens in `@theme` and reusable selectors in `@layer components`.
- Exclude the `Styles` directory from SwiftPM source handling.
- Compile Tailwind in `beforeRead`, write to a temp file, validate non-empty
  output, then atomically replace `content/static/style.css`. The wrapper exists
  because compiler failures can otherwise leave stale public CSS.
- Use `Saga.hashed("/static/style.css")` in layouts and never edit generated CSS
  by hand.
- When `saga dev` is running, restart it after Swift source changes so the new
  binary is used and static files are recopied.
- Keep a style-guide page in reusable themes and update it whenever CSS classes,
  markup, or front matter fields change.

## Images

- Transform rendered HTML after Markdown parsing, not source Markdown. Use an
  HTML parser such as SwiftSoup and mutate only the image tag so surrounding
  HTML and attributes stay intact.
- Generate deterministic derivatives under `content/static/generated/images/`
  and ignore generated directories in Saga watch mode to avoid rebuild loops.
- Add dimensions, `decoding`, loading hints, `fetchpriority` for the likely LCP
  image, and `srcset` only for derivatives that exist.
- Preserve `/wp-content/uploads/...` during WordPress migrations. Generated
  derivatives improve rendered pages, but original URL preservation may keep
  deploy size high until a separate storage/redirect plan exists.
- Measure image weight before optimizing. Do not delete or downscale source
  migration images without legacy URL and visual checks.

## Build Performance

- Add writer-level metrics before optimizing. Measure Tailwind, item rendering,
  page rendering, writing archives, tag/category archives, feeds, sitemap, 404,
  minification, and after-write work.
- New sites should start with full deterministic builds. Add fast-dev modes only
  when measurements justify them.
- Production builds must remain complete and deterministic.
- Clean up Saga pagination artifacts such as duplicate page-one archive output
  when they create duplicate URLs.
- Generated CSS, generated image derivatives, and `deploy/` are build artifacts
  for Direct Upload workflows and should not be tracked unless the deployment
  model explicitly requires checked-in output.
- Avoid carrying generated `deploy/` history. It made this repo hundreds of MiB
  larger; if history cleanup is needed, coordinate a deliberate filter-repo
  rewrite instead of ad hoc deletions.

## SiteDoctor And Automation

- SiteDoctor-style commands should load content once, parse front matter and
  body conservatively, preserve body text exactly, and write deterministic
  reports.
- Reports are non-mutating by default. Mutating flows need explicit verbs such
  as `--generate` or `--apply-approved`.
- AI proposals belong in SiteDoctor workflows, not `saga build` or `saga dev`.
  Proposal artifacts should be reviewable before content changes.
- Generated recommendations or CTA choices should use fixed IDs and Swift
  renderers, not model-generated HTML.

## Deployment

- Prefer local Cloudflare Pages Direct Upload for Swift/macOS-heavy Saga sites
  when cloud builders are slower or lack required Apple frameworks.
- The deploy command should be Swift ArgumentParser, not shell script glue.
- A good deploy command resolves the project root, refuses to run while
  `saga dev` appears active, runs `saga build`, smoke-checks output, reports
  payload file count/size, resolves `wrangler` or `npx --yes wrangler`, and
  supports production, preview, and dry-run modes.
- GitHub Actions should validate by default; do not add CI deployment unless
  the human chooses that deployment model.
- If Direct Upload is the deployment source, disable Cloudflare Git-triggered
  deploys so two deployment paths do not race.

## Reuse Boundaries

- Good package candidates: SEO policy, SiteDoctor inventory/reports, Tailwind
  compile wrapper, rendered-HTML image pipeline, Cloudflare Pages Direct Upload,
  and build metrics.
- Keep brand, navigation, newsletter providers, visual tokens, case-study fields,
  legacy redirect maps, and Cloudflare project/account names site-specific.
- Extract packages after a boundary is stable across multiple sites, not just
  because the first site has useful code.
