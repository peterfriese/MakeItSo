// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "MakeItSoTutorials",
  products: [
    .library(
      name: "MakeItSoTutorials",
      targets: ["MakeItSoTutorials"]),
  ],
  dependencies: [
      .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "MakeItSoTutorials",
      dependencies: []),
  ]
)
