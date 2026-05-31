# Design And Tailwind

Treat Tailwind CSS as a source module system, not an output file to edit.

## Recommended Shape

```text
Styles/
  tailwind.css
  tokens.css
  base.css
  layout.css
  motion.css
  components/
    navigation.css
    archive.css
    article.css
    prose.css
    forms.css
  utilities.css
```

`tailwind.css` should contain imports and `@source` directives:

```css
@import "tailwindcss";
@import "./tokens.css";
@import "./base.css";
@source "../Sources";
@source "../content";
```

## Rules

- Compile with SwiftTailwind in Saga `beforeRead`.
- Write to a temporary file first and replace generated CSS only after valid,
  non-empty output exists. This protects the public stylesheet when the Tailwind
  process emits diagnostics but the wrapper does not throw.
- Use `Saga.hashed("/static/style.css")` in layout.
- Use `@theme` for tokens.
- Put reusable classes in `@layer components`.
- Classes that appear only in Swift strings or raw Markdown HTML must not rely on
  Tailwind content scanning alone.
- Keep modules small enough for focused edits.
- Exclude `Styles` from SwiftPM source handling.
- Restart `saga dev` after Swift source changes so new renderer strings and
  static-copy behavior come from the current binary.
- Add tests for import existence, module size, balanced comments/braces, and clean compilation.

## Style Guide

- Maintain a live style-guide page for component examples.
- Update it for new, renamed, or removed component classes.
- Verify it visually after theme changes.
