# Saga Site Starter Template

This starter is meant to be copied into a new Swift Saga website and then renamed.
It demonstrates the default structure the `saga-sites` skill should prefer:

- one executable target compatible with `saga build` and `saga dev`
- one testable `SiteCore` library for the pipeline, metadata, renderers, and helpers
- Markdown content in `content/pages` and `content/posts`
- canonical URLs from front matter `path:`
- a writing index generated from posts
- full tag and category archives by default
- Tailwind v4 compiled through SwiftTailwind
- a Swift ArgumentParser CLI for checks and Cloudflare Pages deploys

After copying, update:

- package/product names in `Package.swift`
- `SiteConfig.swift`
- command name in `Sources/SiteCommand/CommandRoot.swift`
- sample content under `content/`
- Cloudflare Pages project name used with `deploy --project-name`

Use these checks while adapting the template:

```bash
swift test
swift build
saga build
swift run ExampleSagaSite check-css
swift run ExampleSagaSite deploy --project-name your-pages-project --dry-run
```

Do not commit `deploy/`, `.build/`, generated CSS, or generated image
derivatives from copied sites.
