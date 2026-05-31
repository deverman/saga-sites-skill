# Package Operating System

Treat the package graph as the site operating system. Each dependency should
have a clear role.

## Core Packages

- `Saga`: static-site orchestration, readers, writers, hooks, generated pages,
  feeds, `Saga.isDev`, and `Saga.hashed`.
- `SagaParsleyMarkdownReader` and `Parsley`: Markdown, front matter, raw HTML,
  smart quotes, Markdown attributes, and syntax extensions.
- `SagaSwimRenderer`, `Swim`, and `HTML`: type-safe renderers, layout functions,
  and controlled `Node.raw` boundaries.
- `SagaPathKit`: output path handling and canonical destination paths.

## Site Capability Packages

- `SwiftTailwind`: Tailwind compiler inside Swift. Wrap it so invalid or empty
  output never replaces the public stylesheet.
- `Bonsai`: production HTML minification in `postProcess`.
- `Moon`: build-time syntax highlighting without client-side JavaScript.
- `SwiftSoup`: parser-based mutation of rendered HTML, especially images.
- `swift-argument-parser`: site management CLI commands.
- `Swift Testing`: contracts for content, SEO, feeds, CSS, images, and build modes.

## Apple Framework Roles

- `Foundation`: filesystem, dates, process execution, JSON/XML encoding.
- `OSLog`: build metrics instrumentation.
- `CryptoKit`: deterministic content or path hashes.
- `CoreGraphics`, `ImageIO`, `UniformTypeIdentifiers`: local image dimensions and derivatives.
- `FoundationXML`: Atom feed generation when XML support is split from Foundation.

## Dependency Rules

- Add a dependency only when it owns a real concern better than local code.
- Keep build-only utilities out of renderers unless they are deterministic.
- Prefer small reusable packages only after at least two sites need the same concern.
- Keep account, brand, URL, and migration policy out of generic packages.
