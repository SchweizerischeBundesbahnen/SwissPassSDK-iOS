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
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.3.2/SwissPassLogin_framework-4.3.2_r240917.1608.11.zip",
                      checksum: "105597a3ca9f6f755dd7093b0b68fd1db82023ecf57c949edf9258c92e14926d"),
        .binaryTarget(name: "SwissPassClient",
                      url: "${URL}",
                      checksum: "${CHECKSUM}")
    ]
)
