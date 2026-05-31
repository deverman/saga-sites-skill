import Testing
@testable import SiteCore

@Test func plainTitleStripsMarkdownEmphasis() {
  #expect(plainTitle("A _great_ title") == "A great title")
}
