// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwissPassClient",
        platforms: [
            .iOS(.v12),
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwissPassClient",
            targets: ["SwissPassClient"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(name: "SwissPassClient",
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.3.2/SwissPassClient_framework-4.3.2_r250108.0946.15.zip",
                      checksum: "cfc6171f74de02c1151fdf1ad5d8f399f5e2c6e07b0cf493f13d1a7ecc174fa5")
    ]
)
