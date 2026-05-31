import Foundation

private let maxSkillNameLength = 64
private let maxDescriptionLength = 1024
private let allowedFrontMatterKeys: Set<String> = [
  "name",
  "description",
  "license",
  "allowed-tools",
  "metadata",
]

public struct ValidationResult: Equatable {
  public let isValid: Bool
  public let message: String
}

public enum SkillValidator {
  public static func validate(skillDirectory: URL) -> ValidationResult {
    let skillMD = skillDirectory.appendingPathComponent("SKILL.md")
    guard FileManager.default.fileExists(atPath: skillMD.path) else {
      return .invalid("SKILL.md not found")
    }

    let content: String
    do {
      content = try String(contentsOf: skillMD, encoding: .utf8)
    } catch {
      return .invalid("Could not read SKILL.md: \(error.localizedDescription)")
    }

    guard content.hasPrefix("---") else {
      return .invalid("No YAML frontmatter found")
    }
    guard let frontMatter = extractFrontMatter(from: content) else {
      return .invalid("Invalid frontmatter format")
    }

    let parsed = parseTopLevelFrontMatter(frontMatter)
    if let error = parsed.error {
      return .invalid(error)
    }

    let unexpectedKeys = Set(parsed.values.keys).subtracting(allowedFrontMatterKeys)
    if !unexpectedKeys.isEmpty {
      let allowed = allowedFrontMatterKeys.sorted().joined(separator: ", ")
      let unexpected = unexpectedKeys.sorted().joined(separator: ", ")
      return .invalid("Unexpected key(s) in SKILL.md frontmatter: \(unexpected). Allowed properties are: \(allowed)")
    }

    guard let name = parsed.values["name"] else {
      return .invalid("Missing 'name' in frontmatter")
    }
    guard let description = parsed.values["description"] else {
      return .invalid("Missing 'description' in frontmatter")
    }

    if let message = validateName(name) {
      return .invalid(message)
    }
    if let message = validateDescription(description) {
      return .invalid(message)
    }

    return .valid("Skill is valid!")
  }

  private static func extractFrontMatter(from rawContent: String) -> String? {
    let content = rawContent.replacingOccurrences(of: "\r\n", with: "\n")
    let lines = content.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    guard lines.first == "---" else {
      return nil
    }
    guard let closingIndex = lines.dropFirst().firstIndex(of: "---") else {
      return nil
    }
    return lines[1..<closingIndex].joined(separator: "\n")
  }

  private static func parseTopLevelFrontMatter(_ text: String) -> (values: [String: String], error: String?) {
    var values = [String: String]()
    for line in text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init) {
      let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty || trimmed.hasPrefix("#") {
        continue
      }
      if line.first?.isWhitespace == true || line.hasPrefix("-") {
        continue
      }
      guard let colon = line.firstIndex(of: ":") else {
        return (values, "Invalid YAML in frontmatter: expected 'key: value' at '\(line)'")
      }
      let key = String(line[..<colon]).trimmingCharacters(in: .whitespacesAndNewlines)
      let rawValue = String(line[line.index(after: colon)...]).trimmingCharacters(in: .whitespacesAndNewlines)
      values[key] = rawValue.trimmingMatchingQuotes()
    }
    return (values, nil)
  }

  private static func validateName(_ rawName: String) -> String? {
    let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
    if name.range(of: #"^[a-z0-9-]+$"#, options: .regularExpression) == nil {
      return "Name '\(name)' should be hyphen-case (lowercase letters, digits, and hyphens only)"
    }
    if name.hasPrefix("-") || name.hasSuffix("-") || name.contains("--") {
      return "Name '\(name)' cannot start/end with hyphen or contain consecutive hyphens"
    }
    if name.count > maxSkillNameLength {
      return "Name is too long (\(name.count) characters). Maximum is \(maxSkillNameLength) characters."
    }
    return nil
  }

  private static func validateDescription(_ rawDescription: String) -> String? {
    let description = rawDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    if description.contains("<") || description.contains(">") {
      return "Description cannot contain angle brackets (< or >)"
    }
    if description.count > maxDescriptionLength {
      return "Description is too long (\(description.count) characters). Maximum is \(maxDescriptionLength) characters."
    }
    return nil
  }
}

private extension ValidationResult {
  static func valid(_ message: String) -> ValidationResult {
    ValidationResult(isValid: true, message: message)
  }

  static func invalid(_ message: String) -> ValidationResult {
    ValidationResult(isValid: false, message: message)
  }
}

private extension String {
  func trimmingMatchingQuotes() -> String {
    guard count >= 2 else { return self }
    if hasPrefix("\""), hasSuffix("\"") {
      return String(dropFirst().dropLast())
    }
    if hasPrefix("'"), hasSuffix("'") {
      return String(dropFirst().dropLast())
    }
    return self
  }
}
