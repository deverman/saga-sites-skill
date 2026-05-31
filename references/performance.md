# Performance

Optimize with measurements, not assumptions.

## Build Metrics

Instrument site-owned work:

- Tailwind compilation
- post item rendering
- page rendering
- writing archive rendering
- tag/category archives
- feeds
- sitemap and 404
- HTML minification
- after-write cleanup

Write metrics to `.build/site-metrics/latest.json` and print a short console
summary.

## Fast Development

- Start with complete builds for new sites.
- If `saga dev` becomes slow, identify which writer dominates.
- For large imported sites, skip long-tail tag/category archives in normal dev
  while preserving full archives in production builds.
- Use an explicit env var such as `SAGA_FULL_ARCHIVES=1` for full local archive validation.

## Generated Output

- Do not track `deploy/` for Direct Upload workflows.
- Do not track generated CSS or generated image derivatives unless the deployment
  model requires checked-in output.
- Ignore generated image directories in Saga watch mode to prevent rebuild loops.
- Measure deploy payload size before optimizing source assets.

## Browser Performance

- Remove avoidable JavaScript. Prefer server-rendered navigation, archives, and
  content discovery.
- Use web-performance skill for Lighthouse/Core Web Vitals and asset-weight work.
- Snapshot critical generated pages to catch accidental SEO or layout regressions.
