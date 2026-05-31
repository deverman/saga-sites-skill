import Testing
@testable import SiteCore

@Test func plainTitleStripsMarkdownEmphasis() {
  #expect(plainTitle("A _great_ title") == "A great title")
}

@Test func taxonomySlugsAreStable() {
  #expect(slugifyTaxonomy("Swift + Saga") == "swift-saga")
  #expect(slugifyTaxonomy(" Engineering ") == "engineering")
}

@Test func writingArchivePathUsesCanonicalFirstPage() {
  #expect(destination(for: "/writing/") == "writing/index.html")
}
