// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiasporaNodeInfo",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .watchOS(.v9),
        .tvOS(.v15),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "DiasporaNodeInfo",
            targets: ["DiasporaNodeInfo"]
        ),
        .executable(
            name: "nodeinfo-cli", targets: ["nodeinfo-cli"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "DiasporaNodeInfo",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
        .testTarget(
            name: "DiasporaNodeInfoTests",
            dependencies: ["DiasporaNodeInfo"]
        ),
        .executableTarget(
            name: "nodeinfo-cli",
            dependencies: [
                "DiasporaNodeInfo",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
]

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: swiftSettings)
    target.swiftSettings = settings
}
