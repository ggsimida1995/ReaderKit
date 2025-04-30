// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ReaderKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ReaderKit",
            targets: ["ReaderKit"]),
    ],
    dependencies: [
        // 如有依赖的外部库，可在此添加
    ],
    targets: [
        .target(
            name: "ReaderKit",
            dependencies: [],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "ReaderKitTests",
            dependencies: ["ReaderKit"]),
    ]
) 
