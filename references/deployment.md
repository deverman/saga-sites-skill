# Deployment

Keep Saga deployment deterministic and Cloudflare-specific.

## Cloudflare Pages Direct Upload

Use Cloudflare skills or current Cloudflare docs for exact Wrangler behavior,
auth, limits, `_headers`, `_redirects`, and CI secrets. This skill only records
the Saga-side deploy pattern.

## Saga-Aware Deploy CLI

Recommended command shape:

```bash
swift run SiteCommand deploy
swift run SiteCommand deploy pages --production
swift run SiteCommand deploy pages --preview preview-name
```

The CLI should:

- detect the project root
- refuse to run while `saga dev` appears active unless explicitly overridden
- run `saga build` unless skipped
- smoke-check required generated files
- report upload payload file count and size
- resolve `wrangler` or `npx --yes wrangler`
- pass configurable project name, production branch, output path, and preview name
- support `--dry-run`

## CI

- CI should validate by default: `swift test`, `swift build`, CSS check,
  `time saga build`, and generated HTML smoke checks.
- Do not add CI deploy steps unless the user explicitly wants CI deployment.
- Keep production deploy intentional and auditable.
