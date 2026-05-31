import ArgumentParser
import Foundation
import SkillValidatorCore

@main
struct SwiftSkillValidate: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "swift-skill-validate",
    abstract: "Validate Codex skill front matter without Python dependencies."
  )

  @Argument(help: "Path to a skill directory containing SKILL.md.")
  var skillDirectory: String

  func run() throws {
    let path = URL(fileURLWithPath: skillDirectory)
    let result = SkillValidator.validate(skillDirectory: path)
    print(result.message)
    if !result.isValid {
      throw ExitCode.failure
    }
  }
}
