# WordPress Migration Playbook

Migrations are URL-preservation projects first and redesign projects second.

## Inventory

- Export posts, pages, media, categories, tags, slugs, dates, descriptions, and redirects.
- Identify original post URLs, image URLs, feed URLs, and taxonomy URLs.
- Measure content and media size before deciding storage strategy.

## Content Conversion

- Convert posts to Markdown with front matter.
- Preserve `date:` and canonical `path:`.
- Keep imported media references working.
- Use raw HTML sparingly for components that Markdown cannot express cleanly.
- Keep visible copy in Markdown rather than Swift.

## SEO

- Add `description:` and `image:` where available.
- Use `seoTitle:` when visible H1 and metadata title differ.
- Preserve historical taxonomy slugs or generate redirects.
- Include drafts with `published: false` and exclude them from public output.

## Validation

- Run duplicate path checks.
- Run missing description/image/title reports.
- Build full archives.
- Smoke-check legacy post URLs, media URLs, feeds, sitemap, and redirects.
- Use Browser and web-performance skills for representative visual and performance checks.
