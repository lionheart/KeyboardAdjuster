// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "KeyboardAdjuster",
    products: [
        .library(name: "KeyboardAdjuster", targets: ["KeyboardAdjuster"]),
    ],
    targets: [
        .target(
            name: "KeyboardAdjuster",
            path: "Pod/Classes"
        ),
    ]
)
