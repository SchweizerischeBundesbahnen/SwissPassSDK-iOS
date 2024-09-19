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
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.3.2/SwissPassLogin_framework-4.3.2_r240919.0921.12.zip",
                      checksum: "202ec20b785b0ac20610c6825cbfcef9a0efbbf988cdd428b8f2a89e38e93fa4"),
        .binaryTarget(name: "SwissPassClient",
                      url: "${URL}",
                      checksum: "${CHECKSUM}")
    ]
)
