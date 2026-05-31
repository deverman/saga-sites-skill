import Foundation
import SwiftTailwind

public enum TailwindCompiler {
  public static let version = "4.3.0"
  public static let input = "Sources/SiteCore/Styles/tailwind.css"
  public static let output = "content/static/style.css"

  public static func compile(output: String = output, minify: Bool) async throws {
    let outputURL = URL(fileURLWithPath: output)
    let temp = outputURL.deletingLastPathComponent()
      .appendingPathComponent(".\(outputURL.lastPathComponent).\(UUID().uuidString).tmp")
    defer { try? FileManager.default.removeItem(at: temp) }
    try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
    try await SwiftTailwind(version: version).run(input: input, output: temp.path, options: minify ? [.minify] : [])
    let data = try Data(contentsOf: temp)
    guard !data.isEmpty else { throw CocoaError(.fileReadCorruptFile) }
    try data.write(to: outputURL, options: .atomic)
  }

  public static func check() async throws {
    let temp = FileManager.default.temporaryDirectory.appendingPathComponent("saga-tailwind-check-\(UUID().uuidString).css")
    defer { try? FileManager.default.removeItem(at: temp) }
    try await compile(output: temp.path, minify: false)
  }
}
