import Foundation
import HTML
import Saga
import SagaPathKit

func destination(for path: String) -> String {
  let trimmed = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
  if trimmed.isEmpty { return "index.html" }
  if trimmed.contains(".") { return trimmed }
  return "\(trimmed)/index.html"
}

func plainTitle(_ raw: String) -> String {
  raw.replacingOccurrences(of: #"_([^_]+)_"#, with: "$1", options: .regularExpression)
}

func slugifyTaxonomy(_ raw: String) -> String {
  raw.trimmingCharacters(in: .whitespacesAndNewlines)
    .lowercased()
    .replacingOccurrences(of: #"[^a-z0-9]+"#, with: "-", options: .regularExpression)
    .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
}

func seoTitle(for item: Item<EntryMetadata>) -> String {
  plainTitle(item.metadata.seoTitle ?? item.title)
}

func absoluteURLString(_ path: String) -> String {
  var base = SiteConfig.url.absoluteString
  if !base.hasSuffix("/") {
    base += "/"
  }
  return base + (path.hasPrefix("/") ? String(path.dropFirst()) : path)
}

func allEntryItems(from allItems: [AnyItem]) -> [Item<EntryMetadata>] {
  allItems.compactMap { $0 as? Item<EntryMetadata> }
}

func baseHtml(
  pageTitle: String,
  path: String,
  description: String?,
  image: String? = nil,
  @NodeBuilder content: () -> NodeConvertible
) -> Node {
  let documentTitle = path == "/" ? SiteConfig.name : "\(plainTitle(pageTitle))\(SiteConfig.titleSuffix)"
  let canonical = absoluteURLString(path)
  let description = description ?? SiteConfig.description
  let image = image ?? SiteConfig.defaultImage

  return Node.fragment([
    .documentType("html"),
    html(lang: "en") {
      head {
        meta(charset: "utf-8")
        meta(content: "width=device-width, initial-scale=1", name: "viewport")
        title { documentTitle }
        meta(content: description, name: "description")
        meta(content: "index, follow", name: "robots")
        meta(content: "website", customAttributes: ["property": "og:type"])
        meta(content: canonical, customAttributes: ["property": "og:url"])
        meta(content: documentTitle, customAttributes: ["property": "og:title"])
        meta(content: description, customAttributes: ["property": "og:description"])
        meta(content: image, customAttributes: ["property": "og:image"])
        meta(content: SiteConfig.name, customAttributes: ["property": "og:site_name"])
        meta(content: "summary_large_image", name: "twitter:card")
        meta(content: documentTitle, name: "twitter:title")
        meta(content: description, name: "twitter:description")
        meta(content: image, name: "twitter:image")
        link(href: canonical, rel: "canonical")
        link(href: Saga.hashed("/static/style.css"), rel: "stylesheet")
      }
      body {
        header(class: "site-header") {
          a(class: "site-brand", href: "/") { SiteConfig.name }
          nav {
            a(href: "/writing/") { "Writing" }
          }
        }
        main { content() }
      }
    }
  ])
}

func renderEntry(context: ItemRenderingContext<EntryMetadata>) -> Node {
  baseHtml(
    pageTitle: seoTitle(for: context.item),
    path: context.item.metadata.path,
    description: context.item.metadata.description,
    image: context.item.metadata.image
  ) {
    article {
      h1 { context.item.title }
      Node.raw(context.item.body)
    }
  }
}

func renderWritingArchive(context: ItemsRenderingContext<EntryMetadata>) -> Node {
  let writingItem = allEntryItems(from: context.allItems).first { $0.metadata.path == "/writing/" }
  let title = writingItem.map(seoTitle(for:)) ?? "Writing"
  let description = writingItem?.metadata.description ?? "Recent writing."
  let path = writingArchivePath(for: context)

  return baseHtml(pageTitle: title, path: path, description: description, image: writingItem?.metadata.image) {
    section {
      h1 { writingItem?.title ?? "Writing" }
      if let body = writingItem?.body, !body.isEmpty {
        div(class: "entry-body") { Node.raw(body) }
      }
      ul(class: "post-list") {
        context.items.sorted { $0.date > $1.date }.map { item in
          li {
            a(href: item.url) { seoTitle(for: item) }
            if let description = item.metadata.description {
              p { description }
            }
          }
        }
      }
    }
  }
}

func writingArchivePath(for context: ItemsRenderingContext<EntryMetadata>) -> String {
  guard let paginator = context.paginator, paginator.index > 1 else {
    return "/writing/"
  }
  return "/writing/page/\(paginator.index)/"
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

func renderCategoryArchive(context: PartitionedRenderingContext<String, EntryMetadata>) -> Node {
  let title = context.key.replacingOccurrences(of: "-", with: " ").capitalized

  return baseHtml(pageTitle: title, path: "/category/\(context.key)/", description: "Posts in \(title)") {
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

func sitemap(baseURL: URL) -> @Sendable (PageRenderingContext) -> String {
  return { context in
    let base = baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    let urls = context.generatedPages
      .filter {
        $0.string != "writing/page/1/index.html"
          && ($0.string.hasSuffix(".html") || $0.string.hasSuffix("/index.html"))
      }
      .map { path in
        """
        <url>
          <loc>\(base)\(path.url)</loc>
        </url>
        """
      }
      .sorted()
      .joined(separator: "\n")

    return """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    \(urls)
    </urlset>
    """
  }
}
