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

    saga.beforeRead { _ in
      try await TailwindCompiler.compile(minify: !Saga.isDev)
    }
    saga.ignoreChanges("content/static/style.css")

    saga.register(
      metadata: EntryMetadata.self,
      readers: readers,
      itemProcessor: processEntry,
      filter: { $0.metadata.published ?? true },
      writers: [
        .itemWriter(swim(renderEntry)),
        .tagWriter(swim(renderTagArchive), tags: { $0.metadata.tags ?? [] }),
      ]
    )

    saga.createPage("robots.txt") { _ in
      "User-agent: *\nAllow: /\n"
    }

    try await saga.run()
  }
}
