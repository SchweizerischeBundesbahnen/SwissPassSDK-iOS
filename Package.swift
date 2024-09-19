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
            name: "SwissPassLogin",
            targets: ["SwissPassLogin"]),
        .library(
            name: "SwissPassClient",
            targets: ["SwissPassClient"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(name: "SwissPassLogin",
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.3.2/SwissPassClient_framework-4.3.2_r240919.0923.12.zip",
                      checksum: "83334d1b65abc62ba8ed474b1d3b5983675f83fb76ff7ac780d629d2312288e7"),
        .binaryTarget(name: "SwissPassClient",
                      url: "${URL}",
                      checksum: "${CHECKSUM}")
    ]
)
