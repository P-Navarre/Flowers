// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["APIClient", "ImageLoader"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "APIClient",
            dependencies: []
        ),
        .target(
            name: "ImageLoader",
            dependencies: []
        )
    ]
)
