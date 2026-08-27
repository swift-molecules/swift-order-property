// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-order-property",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Order Property",
            targets: ["Order Property"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-order.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-order-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Order Property",
            dependencies: [
                .product(name: "Order", package: "swift-order"),
                .product(name: "Order Comparison", package: "swift-order-comparison"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Property", package: "swift-property"),
            ]
        ),
        .testTarget(
            name: "Order Property Tests",
            dependencies: [
                "Order Property",
                .product(name: "Order", package: "swift-order"),
                .product(name: "Order Comparison", package: "swift-order-comparison"),
                .product(name: "Comparison", package: "swift-comparison"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
