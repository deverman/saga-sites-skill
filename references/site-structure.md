# Site Structure

Use a structure that supports fast edits, tests, and future extraction.

## Recommended Layout

```text
Package.swift
Sources/
  SiteCommand/
    CommandRoot.swift
    DeployCommand.swift
    DoctorCommand.swift
  SiteCore/
    run.swift
    EntryMetadata.swift
    SiteConfig.swift
    SiteOutput.swift
    Theme/
    Styles/
    SiteDoctor/
Tests/
content/
  pages/
  posts/
  static/
```

## Source Boundaries

- Keep the executable target thin. It should delegate to `SiteBuilder.main()` or
  an ArgumentParser command group.
- Keep renderers split by page family once files become large enough to hurt
  review or context loading.
- Keep generated navigation/configuration separate from renderers.
- Keep static copy, project cards, timelines, and prose in Markdown unless they
  are truly dynamic.
- Put source CSS under `Sources/.../Styles` and exclude that directory from
  SwiftPM source handling.
- Split renderer files by page family when source size starts slowing review or
  agent context loading. Prefer small, named files over one large theme file.

## Content Rules

- `content/pages` holds static and structured pages.
- `content/posts` holds posts and imported WordPress entries.
- `content/static` holds deployable static assets and generated CSS.
- `content/static/generated` is intermediate output; do not hand-edit it.
- `deploy` is generated output for Cloudflare Pages Direct Upload and should
  usually not be tracked.
- `docs` is an alternative output directory used when deploying via GitHub Pages
  (configured in `Package.swift` as `output: "docs"`). Like `deploy`, it should
  be tracked only when GitHub Pages requires it — keep it out of `.gitignore` in
  that case and treat it as a build artifact that is committed deliberately.

## Documentation Rules

- Keep agent docs current with commands, generated output policy, front matter,
  and deployment cautions.
- Keep a style-guide page in the site when building a reusable theme.
- Update examples whenever CSS classes or raw Markdown components change.
- Keep repo-only planning and audits outside downstream site repos once they
  become reusable skill collateral.
