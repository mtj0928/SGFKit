// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SGFKit",
    products: [
        .library(name: "SGFKit", targets: ["SGFKit"]),
    ],
    targets: [
        .target(name: "SGFKit"),
        .testTarget(name: "SGFKitTests", dependencies: ["SGFKit"]),
    ]
)
