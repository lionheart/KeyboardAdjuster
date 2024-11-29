// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "KeyboardAdjuster",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "KeyboardAdjuster",
            targets: ["KeyboardAdjuster"]
        )
    ],
    targets: [
        .target(
            name: "KeyboardAdjuster",
            path: "Pod/Classes"
        ),
        .testTarget(
            name: "KeyboardAdjusterTests",
            dependencies: ["KeyboardAdjuster"]
        )
    ]
)
