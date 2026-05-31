// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "ExampleSagaSite",
  platforms: [.macOS(.v14)],
  products: [
    .executable(name: "ExampleSagaSite", targets: ["SiteCommand"]),
    .library(name: "SiteCore", targets: ["SiteCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/loopwerk/Saga", from: "3.4.1"),
    .package(url: "https://github.com/loopwerk/SagaPathKit", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaParsleyMarkdownReader", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SagaSwimRenderer", from: "1.0.0"),
    .package(url: "https://github.com/loopwerk/SwiftTailwind", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
  ],
  targets: [
    .target(
      name: "SiteCore",
      dependencies: [
        "Saga",
        "SagaPathKit",
        "SagaParsleyMarkdownReader",
        "SagaSwimRenderer",
        "SwiftTailwind",
      ],
      exclude: ["Styles"]
    ),
    .executableTarget(
      name: "SiteCommand",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "SiteCore",
      ]
    ),
    .testTarget(name: "SiteTests", dependencies: ["SiteCore"], path: "Tests/SiteTests"),
  ]
)
