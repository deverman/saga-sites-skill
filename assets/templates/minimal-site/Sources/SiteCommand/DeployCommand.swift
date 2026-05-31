import ArgumentParser
import Foundation

struct DeployCommand: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "deploy",
    abstract: "Build and deploy the generated site to Cloudflare Pages."
  )

  @Option(help: "Cloudflare Pages project name.")
  var projectName: String

  @Option(help: "Cloudflare Pages branch name.")
  var branch = "main"

  @Option(help: "Generated site output directory.")
  var output = "deploy"

  @Flag(help: "Skip running saga build before deployment.")
  var skipBuild = false

  @Flag(help: "Print the Wrangler command without uploading.")
  var dryRun = false

  func validate() throws {
    if projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      throw ValidationError("--project-name cannot be empty.")
    }
  }

  func run() throws {
    if !skipBuild {
      try Shell.run("saga", ["build"])
    }

    try smokeCheck(output: output)

    let wrangler = Shell.find("wrangler").map { ($0, [String]()) }
      ?? Shell.find("npx").map { ($0, ["--yes", "wrangler"]) }
    guard let wrangler else {
      throw ValidationError("Install Wrangler or make npx available before deploying.")
    }

    let arguments = wrangler.1 + [
      "pages",
      "deploy",
      output,
      "--project-name=\(projectName)",
      "--branch=\(branch)",
    ]
    print("$ \(([URL(fileURLWithPath: wrangler.0).lastPathComponent] + arguments).joined(separator: " "))")
    if !dryRun {
      try Shell.run(wrangler.0, arguments)
    }
  }

  private func smokeCheck(output: String) throws {
    for path in ["index.html", "robots.txt"] {
      let url = URL(fileURLWithPath: output).appendingPathComponent(path)
      guard FileManager.default.fileExists(atPath: url.path) else {
        throw ValidationError("Missing generated file: \(output)/\(path)")
      }
    }
  }
}

enum Shell {
  static func find(_ executable: String) -> String? {
    for dir in (ProcessInfo.processInfo.environment["PATH"] ?? "").split(separator: ":") {
      let path = URL(fileURLWithPath: String(dir)).appendingPathComponent(executable).path
      if FileManager.default.isExecutableFile(atPath: path) {
        return path
      }
    }
    return nil
  }

  static func run(_ executable: String, _ arguments: [String]) throws {
    let path = executable.hasPrefix("/") ? executable : find(executable)
    guard let path else {
      throw ValidationError("Could not find \(executable) in PATH.")
    }

    let process = Process()
    process.executableURL = URL(fileURLWithPath: path)
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()

    guard process.terminationStatus == 0 else {
      throw ValidationError("\(executable) exited with status \(process.terminationStatus).")
    }
  }
}
