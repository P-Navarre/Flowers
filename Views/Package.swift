// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Views",
            targets: ["CustomViews", "DetailView", "ListView", "Style"]
        ),
    ],
    dependencies: [
        .package(name: "Network", path: "../Network"),
        .package(name: "Data", path: "../Data")
    ],
    targets: [
        .target(
            name: "CustomViews",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .target(name: "Style")
            ]
        ),
        .target(
            name: "DetailView",
            dependencies: [
                .product(name: "Data", package: "Data"),
                .target(name: "CustomViews"),
                .target(name: "Style")
            ]
        ),
        .target(
            name: "ListView",
            dependencies: [
                .product(name: "Data", package: "Data"),
                .target(name: "DetailView"),
                .target(name: "CustomViews"),
                .target(name: "Style")
            ]
        ),
        .target(
            name: "Style",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .target(
            name: "TestsHelpers",
            dependencies: [
                .product(name: "Data", package: "Data")
            ]
        ),
        .testTarget(
            name: "CustomViewsTests",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .target(name: "TestsHelpers"),
                .target(name: "CustomViews"),
                .target(name: "Style")
            ]
        ),
        .testTarget(
            name: "ListViewTests",
            dependencies: [
                .product(name: "Network", package: "Network"),
                .product(name: "Data", package: "Data"),
                .target(name: "TestsHelpers"),
                .target(name: "Style"),
                .target(name: "ListView")
            ]
        )
    ]
)
