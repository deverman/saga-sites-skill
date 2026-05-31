# Content And SEO

Make SEO a tested data layer rather than scattered strings.

## Front Matter

Recommended common fields:

```yaml
---
title: Visible or legacy title
seoTitle: Optional plain metadata title
date: 2026-05-31
path: /canonical-path/
description: Search and social summary
image: /static/images/social.jpg
published: true
tags: Swift, Saga
categories: engineering
---
```

- `path:` is required and canonical. Do not derive public URLs casually from filenames.
- `title:` or the Markdown H1 is visible content.
- `seoTitle:` is metadata-only and should use straight quotes.
- Visible Markdown H1s may use typographic quotes or emphasis.
- `description:` feeds SEO metadata, archives, and reports.
- `image:` feeds Open Graph, Twitter, feeds, and image audits.
- `published:` should default to public when omitted; drafts must be filtered
  consistently from pages, feeds, sitemaps, archives, and recommendations.

## SEO Contract

Centralize:

- plain metadata title
- document title suffix
- canonical URL
- description fallback
- robots policy
- sitemap eligibility
- social image URLs
- JSON-LD type
- feed title policy

Use `JSONEncoder` for JSON-LD. Do not interpolate JSON strings by hand.
Use the same title resolver for HTML metadata, Atom, JSON Feed, JSON-LD, and
archive rows so Markdown emphasis markers never leak into plain-text surfaces.

## Generated Output Checks

Smoke-check generated HTML for:

- exactly one canonical link
- parseable JSON-LD
- expected robots policy
- sitemap inclusion or exclusion
- feed entries using `seoTitle:` when present
- no duplicate page-one archive URL such as `/writing/page/1/`

## Archives

- New sites default to full tag/category archives.
- Imported sites with hundreds of thin tags may add fast-dev skipping and later
  topic hubs.
- Topic hubs are not a v1 default; document them as a future SEO improvement.

## WordPress Preservation

- Preserve imported `path:` values such as numeric WordPress slugs.
- Preserve media paths such as `/wp-content/uploads/...` until redirects or
  external storage are explicitly designed.
- Use WordPress-compatible taxonomy slug logic for migrated archives.
- Generate redirects for historical paths that cannot remain one-to-one.
- Treat media URLs as SEO assets too. Old image URLs may have inbound value and
  should not be removed just because responsive derivatives exist.
