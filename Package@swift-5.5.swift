// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "ValidatableKit",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
        .macCatalyst(.v13),
    ],
    products: [
        .library(name: "ValidatableKit", targets: ["ValidatableKit"]),
    ],
    targets: [
        .target(name: "ValidatableKit", dependencies: []),
        .testTarget(name: "ValidatableKitTests", dependencies: ["ValidatableKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
