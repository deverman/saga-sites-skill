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

## Content Rules

- `content/pages` holds static and structured pages.
- `content/posts` holds posts and imported WordPress entries.
- `content/static` holds deployable static assets and generated CSS.
- `content/static/generated` is intermediate output; do not hand-edit it.
- `deploy` is generated output for local builds/uploads and should usually not
  be tracked.

## Documentation Rules

- Keep agent docs current with commands, generated output policy, front matter,
  and deployment cautions.
- Keep a style-guide page in the site when building a reusable theme.
- Update examples whenever CSS classes or raw Markdown components change.
