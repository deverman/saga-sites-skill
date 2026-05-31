# SiteDoctor

Use SiteDoctor-style commands for deterministic, reviewable maintenance.

## Core Model

- Load content once into a `ContentInventory`.
- Parse Markdown front matter and body conservatively.
- Preserve body text exactly when reading and serializing.
- Write reports as deterministic Markdown or JSON artifacts.
- Make reports non-mutating by default.

## Useful Reports

- full audit
- missing/duplicate paths
- titles and H1 policy
- descriptions
- tags/categories
- image coverage
- thin content
- generated output smoke checks
- migration redirect gaps

## AI Proposal Workflow

Keep AI out of `saga build` and `saga dev`.

Recommended flow:

1. `doctor audit` finds missing or weak content metadata.
2. `doctor seo --missing --propose` writes proposals.
3. Human reviews proposal artifacts.
4. `doctor seo --apply-approved` mutates Markdown only after approval.

Use provider abstractions so Foundation Models, OpenAI, or another provider can
produce the same proposal shape.

## CLI Rules

- Expose commands through the existing site executable.
- Use Swift ArgumentParser.
- Require explicit flags such as `--report`, `--generate`, or `--apply-approved`
  for actions with side effects.
