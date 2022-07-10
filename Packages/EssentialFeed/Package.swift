// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EssentialFeed",
    platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "EssentialFeed",
            targets: ["EssentialFeed"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EssentialFeed",
            dependencies: [],
            resources: [.process("Resources")]),
        .target(
            name: "TestUtilities",
            dependencies: ["EssentialFeed"]),
        .testTarget(
            name: "EssentialFeedTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
        .testTarget(
            name: "EssentialFeedAPIEndToEndTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
        .testTarget(
            name: "EssentialFeedCacheIntegrationTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
    ]
)
