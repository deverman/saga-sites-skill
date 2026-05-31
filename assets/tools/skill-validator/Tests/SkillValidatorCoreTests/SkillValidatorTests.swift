import Foundation
import SkillValidatorCore
import Testing

@Suite
struct SkillValidatorTests {
  @Test
  func validatesMinimalSkill() throws {
    let directory = try makeSkill("""
    ---
    name: saga-sites
    description: Build Swift Saga sites.
    ---

    # Saga Sites
    """)
    defer { try? FileManager.default.removeItem(at: directory) }

    let result = SkillValidator.validate(skillDirectory: directory)

    #expect(result.isValid)
    #expect(result.message == "Skill is valid!")
  }

  @Test
  func rejectsMissingFrontMatter() throws {
    let directory = try makeSkill("# Missing")
    defer { try? FileManager.default.removeItem(at: directory) }

    let result = SkillValidator.validate(skillDirectory: directory)

    #expect(!result.isValid)
    #expect(result.message == "No YAML frontmatter found")
  }

  @Test
  func rejectsInvalidName() throws {
    let directory = try makeSkill("""
    ---
    name: Saga Sites
    description: Build Swift Saga sites.
    ---
    """)
    defer { try? FileManager.default.removeItem(at: directory) }

    let result = SkillValidator.validate(skillDirectory: directory)

    #expect(!result.isValid)
    #expect(result.message.contains("should be hyphen-case"))
  }

  @Test
  func allowsNestedMetadata() throws {
    let directory = try makeSkill("""
    ---
    name: saga-sites
    description: Build Swift Saga sites.
    metadata:
      short-description: Saga site builder
    ---
    """)
    defer { try? FileManager.default.removeItem(at: directory) }

    let result = SkillValidator.validate(skillDirectory: directory)

    #expect(result.isValid)
  }

  private func makeSkill(_ skillMarkdown: String) throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("swift-skill-validate-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    try skillMarkdown.write(
      to: directory.appendingPathComponent("SKILL.md"),
      atomically: true,
      encoding: .utf8
    )
    return directory
  }
}
