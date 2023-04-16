// swift-tools-version:5.5.0
import PackageDescription
let package = Package(
    name: "GachaMIMTServer",
    defaultLocalization: "zh-Hans",
    products: [
        .library(
            name: "GachaMIMTServer",
            targets: ["GachaMIMTServer"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RustXcframework",
            path: "RustXcframework.xcframework"
        ),
        .target(
            name: "GachaMIMTServer",
            dependencies: ["RustXcframework"])
    ]
)
