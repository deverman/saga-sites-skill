# Images

Use a deterministic build-time image pipeline for local assets.

## Principles

- Work from rendered HTML in `itemProcessor`, after Parsley converts Markdown.
- Use SwiftSoup or another parser to mutate only `<img>` tags.
- Preserve surrounding HTML and existing attributes.
- Add missing dimensions from local files.
- Add `decoding="async"`.
- Use eager loading and `fetchpriority="high"` for the first content image when appropriate.
- Use lazy loading for later images.
- Generate deterministic derivatives under `content/static/generated/images/`.

## Supported Sources

- `/static/...`
- `/wp-content/uploads/...` for WordPress migrations
- Remote images should be reported, not locally transformed.

## Derivatives

- Use deterministic filenames based on source path and width.
- Generate same-format JPEG/PNG derivatives unless encoder support is confirmed.
- Add `srcset` and `sizes` only for derivatives that exist.
- Cache generated derivatives aggressively when deployed with stable filenames.
- Keep generated image directories out of Saga watch triggers, or the image
  pipeline can cause rebuild loops.

## Audits

Report:

- missing front matter image
- missing local files
- unreadable dimensions
- oversized originals
- deployed image weight by directory and file type
- body images without dimensions
- posts without social images

Do not remove or rewrite WordPress originals without a separate migration decision.
