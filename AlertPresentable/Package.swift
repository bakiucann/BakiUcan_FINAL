// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlertPresentable",
    products: [
        .library(
            name: "AlertPresentable",
            targets: ["AlertPresentable"]),
    ],
    dependencies: [
        .package(path: "../Loadable"),
    ],
    targets: [
        .target(
            name: "AlertPresentable",
            dependencies: ["Loadable"]),
        .testTarget(
            name: "AlertPresentableTests",
            dependencies: ["AlertPresentable"]),
    ]
)
