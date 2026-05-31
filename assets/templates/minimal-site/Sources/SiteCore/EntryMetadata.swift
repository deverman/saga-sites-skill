import Saga

public struct EntryMetadata: Metadata {
  public let path: String
  public var seoTitle: String?
  public var description: String?
  public var image: String?
  public var published: Bool?
  public var tags: [String]?
  public var categories: [String]?
}
