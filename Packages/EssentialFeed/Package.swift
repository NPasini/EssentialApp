// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "EssentialFeed",
    defaultLocalization: "en",
    platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "EssentialFeed",
            targets: ["EssentialFeed", "iOSUtilities"]),
        .library(
            name: "EssentialFeediOS",
            targets: ["EssentialFeediOSMVP"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EssentialFeed",
            dependencies: ["iOSUtilities"]),
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
            dependencies: []),
        .target(
            name: "TestUtilities",
            dependencies: ["EssentialFeed", "iOSUtilities"]),
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
