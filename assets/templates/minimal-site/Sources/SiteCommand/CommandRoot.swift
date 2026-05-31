import ArgumentParser
import SiteCore

@main
enum SiteMain {
  static func main() async throws {
    let arguments = Array(CommandLine.arguments.dropFirst())
    if arguments.isEmpty {
      try await SiteBuilder.main()
    } else {
      await SiteCommand.main(arguments)
    }
  }
}

struct SiteCommand: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "ExampleSagaSite",
    abstract: "Build and maintain the site.",
    subcommands: [
      CheckCSS.self,
      DeployCommand.self,
    ]
  )
}

struct CheckCSS: AsyncParsableCommand {
  static let configuration = CommandConfiguration(commandName: "check-css")

  func run() async throws {
    try await TailwindCompiler.check()
  }
}
