// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "EssentialFeed",
    platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "EssentialFeed",
            targets: ["EssentialFeed"]),
        .library(
            name: "EssentialFeediOS",
            targets: ["EssentialFeediOS"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EssentialFeed",
            dependencies: [],
            resources: [.process("Resources")]),
        .target(
            name: "EssentialFeediOS",
            dependencies: ["EssentialFeediOSMVC", "EssentialFeediOSMVVM", "EssentialFeediOSMVP"]),
        .target(
            name: "EssentialFeediOSMVC",
            dependencies: ["EssentialFeed", "iOSUtilities"]),
        .target(
            name: "EssentialFeediOSMVVM",
            dependencies: ["EssentialFeed", "iOSUtilities"]),
        .target(
            name: "EssentialFeediOSMVP",
            dependencies: ["EssentialFeed", "iOSUtilities"]),
        .target(
            name: "iOSUtilities",
            dependencies: [],
            resources: [.process("Resources")]),
        .target(
            name: "TestUtilities",
            dependencies: ["EssentialFeed"]),
        .testTarget(
            name: "EssentialFeedTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
        .testTarget(
            name: "EssentialFeediOSTests",
            dependencies: ["EssentialFeediOS", "TestUtilities"]),
        .testTarget(
            name: "EssentialFeedAPIEndToEndTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
        .testTarget(
            name: "EssentialFeedCacheIntegrationTests",
            dependencies: ["EssentialFeed", "TestUtilities"]),
    ]
)
