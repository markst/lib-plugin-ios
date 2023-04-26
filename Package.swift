// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "lib-plugin-ios",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "YouboraLib",
            targets: ["YouboraLib"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "YouboraLib",
            path: "YouboraLib.xcframework"
        )
    ]
)
