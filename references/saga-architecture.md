# Saga Architecture

Use Saga as an explicit Swift pipeline. Prefer predictable build-time work over
runtime JavaScript or request-time functions.

## Core Pipeline

- Define a typed `Metadata` model for front matter.
- Configure readers with SagaParsleyMarkdownReader and Parsley options.
- Use `itemProcessor` for per-item mutations such as canonical destinations,
  syntax highlighting, and rendered-HTML image enhancement.
- Use `itemWriter` for detail pages, `listWriter` for indexes and pagination,
  `tagWriter` and `partitionedWriter` for archives, and `createPage` for
  generated files such as sitemap, redirects, robots, and 404.
- When a dynamic writer owns a path like `/writing/`, register the matching
  Markdown page with no direct writer so the content is available to the list
  renderer without creating duplicate output.
- Use `beforeRead` for generated inputs, such as Tailwind CSS compilation.
- Use `postProcess` for production-only output changes, such as Bonsai HTML
  minification.
- Use `afterWrite` for deterministic cleanup, aliases, metrics, reports, and
  duplicate page-one pagination cleanup.

## Build Modes

- New sites default to complete output, including full tag/category archives.
- Large imported sites may add a `SiteBuildMode` that skips long-tail archives in
  `saga dev` while keeping `saga build` complete.
- Gate archive skipping behind metrics. Do not optimize archives based on guesswork.

## Compatibility Rules

- Prefer upstream Saga. Put site policy in local code or reusable packages.
- Keep one executable target so Saga CLI does not face ambiguous SwiftPM products.
- Put reusable build logic in a library target so Swift Testing can cover it.
- Avoid running commands that write the same output directory concurrently.
- Restart `saga dev` after Swift source changes; the dev server keeps using the
  binary it launched with until restarted.

## Upstream Research

Check current Saga docs before implementing unfamiliar APIs:

- `https://getsaga.dev/docs/architecture/`
- `https://getsaga.dev/docs/gettingstarted/`
- `https://getsaga.dev/docs/guides/tailwindcss/`
- `https://getsaga.dev/docs/guides/reusablehtmllayouts/`
- `https://github.com/loopwerk/Saga/tree/main/Example`
