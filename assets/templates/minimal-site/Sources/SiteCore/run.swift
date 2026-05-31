import Foundation
import Saga
import SagaPathKit
import SagaParsleyMarkdownReader
import SagaSwimRenderer

func processEntry(_ item: Item<EntryMetadata>) {
  item.relativeDestination = Path(destination(for: item.metadata.path))
}

public enum SiteBuilder {
  public static func main() async throws {
    let readers: [Reader] = [
      .parsleyMarkdownReader(markdownOptions: [.unsafe, .smartQuotes], syntaxExtensions: [.autolink])
    ]

    let saga = try Saga(input: "content", output: "deploy")
    let postWriters: [Writer<EntryMetadata>] = [
      .itemWriter(swim(renderEntry)),
      .listWriter(
        swim(renderWritingArchive),
        output: "writing/index.html",
        paginate: 20,
        paginatedOutput: "writing/page/[page]/index.html"
      ),
      .tagWriter(
        swim(renderTagArchive),
        tags: { ($0.metadata.tags ?? []).map(slugifyTaxonomy).filter { !$0.isEmpty } }
      ),
      .partitionedWriter(
        swim(renderCategoryArchive),
        output: "category/[key]/index.html",
        partitioner: { items in
          var partitions = [String: [Item<EntryMetadata>]]()
          for item in items {
            for category in item.metadata.categories ?? [] {
              let slug = slugifyTaxonomy(category)
              guard !slug.isEmpty else { continue }
              partitions[slug, default: []].append(item)
            }
          }
          return partitions
        }
      ),
    ]

    saga.beforeRead { _ in
      try await TailwindCompiler.compile(minify: !Saga.isDev)
    }
    saga.ignoreChanges("content/static/style.css")

    saga.register(
      metadata: EntryMetadata.self,
      readers: readers,
      itemProcessor: processEntry,
      filter: {
        $0.relativeSource.string.hasPrefix("posts/")
          && ($0.metadata.published ?? true)
      },
      claimExcludedItems: false,
      writers: postWriters
    )

    saga.register(
      folder: "pages",
      metadata: EntryMetadata.self,
      readers: readers,
      itemProcessor: processEntry,
      filter: { $0.metadata.path == "/writing/" },
      claimExcludedItems: false,
      writers: []
    )

    saga.register(
      folder: "pages",
      metadata: EntryMetadata.self,
      readers: readers,
      itemProcessor: processEntry,
      filter: { $0.metadata.path != "/writing/" },
      writers: [.itemWriter(swim(renderEntry))]
    )

    saga.createPage("robots.txt") { _ in
      "User-agent: *\nAllow: /\n"
    }
    saga.createPage("sitemap.xml", using: sitemap(baseURL: SiteConfig.url))

    saga.afterWrite { saga in
      let duplicateWritingPage = URL(fileURLWithPath: saga.outputPath.string)
        .appendingPathComponent("writing/page/1")
      if FileManager.default.fileExists(atPath: duplicateWritingPage.path) {
        try FileManager.default.removeItem(at: duplicateWritingPage)
      }
    }

    try await saga.run()
  }
}
