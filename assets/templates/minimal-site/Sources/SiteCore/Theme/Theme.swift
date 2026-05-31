import Foundation
import HTML
import Saga

func destination(for path: String) -> String {
  let trimmed = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
  if trimmed.isEmpty { return "index.html" }
  if trimmed.contains(".") { return trimmed }
  return "\(trimmed)/index.html"
}

func plainTitle(_ raw: String) -> String {
  raw.replacingOccurrences(of: #"_([^_]+)_"#, with: "$1", options: .regularExpression)
}

func seoTitle(for item: Item<EntryMetadata>) -> String {
  plainTitle(item.metadata.seoTitle ?? item.title)
}

func baseHtml(pageTitle: String, path: String, description: String?, @NodeBuilder content: () -> NodeConvertible) -> Node {
  let documentTitle = path == "/" ? SiteConfig.name : "\(plainTitle(pageTitle))\(SiteConfig.titleSuffix)"
  let canonical = SiteConfig.url.absoluteString + (path.hasPrefix("/") ? String(path.dropFirst()) : path)

  return Node.fragment([
    .documentType("html"),
    html(lang: "en") {
      head {
        meta(charset: "utf-8")
        meta(content: "width=device-width, initial-scale=1", name: "viewport")
        title { documentTitle }
        meta(content: description ?? SiteConfig.description, name: "description")
        link(href: canonical, rel: "canonical")
        link(href: Saga.hashed("/static/style.css"), rel: "stylesheet")
      }
      body {
        main { content() }
      }
    }
  ])
}

func renderEntry(context: ItemRenderingContext<EntryMetadata>) -> Node {
  baseHtml(pageTitle: context.item.title, path: context.item.metadata.path, description: context.item.metadata.description) {
    article {
      h1 { seoTitle(for: context.item) }
      Node.raw(context.item.body)
    }
  }
}

func renderTagArchive(context: PartitionedRenderingContext<String, EntryMetadata>) -> Node {
  let title = context.key.replacingOccurrences(of: "-", with: " ").capitalized

  return baseHtml(pageTitle: title, path: "/tag/\(context.key)/", description: "Posts tagged \(title)") {
    section {
      h1 { title }
      ul {
        context.items.sorted { $0.date > $1.date }.map { item in
          li {
            a(href: item.url) { seoTitle(for: item) }
          }
        }
      }
    }
  }
}
