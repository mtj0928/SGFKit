// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SGFKit",
    products: [
        .library(name: "SGFKit", targets: ["SGFKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SGFKit"),
        .testTarget(name: "SGFKitTests", dependencies: ["SGFKit"]),
    ]
)
