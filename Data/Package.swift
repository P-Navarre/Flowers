// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["FlowerCategoryData", "FlowerItemData"]),
    ],
    dependencies: [
        .package(name: "Network", path: "../Network")
    ],
    targets: [
        .target(
            name: "FlowerCategoryData",
            dependencies: [
                .product(name: "Network", package: "Network"),
            ]
        ),
        .target(
            name: "FlowerItemData",
            dependencies: [
                .product(name: "Network", package: "Network"),
            ]
        )
    ]
)
