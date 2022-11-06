// swift-tools-version: 5.7

import PackageDescription

let github = "https://github.com"
let appleGitHub = "\(github)/apple"

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
    dependencies: [
        .package(url: "\(appleGitHub)/swift-docc-plugin", from: "1.0.0"),
        .package(url: "\(appleGitHub)/swift-format", from: "0.50700.0"),
    ],
    targets: [
        .target(name: "ValidatableKit", dependencies: []),
        .testTarget(name: "ValidatableKitTests", dependencies: ["ValidatableKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
