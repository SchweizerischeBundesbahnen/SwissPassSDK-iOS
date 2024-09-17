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
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.3.2/SwissPassClient_framework-4.3.2_r240917.1607.11.zip",
                      checksum: "64b64727e5cbcfe240e7618e0ca0b9f3c012b26e64ddbdafec89d969933d0508"),
        .binaryTarget(name: "SwissPassClient",
                      url: "${URL}",
                      checksum: "${CHECKSUM}")
    ]
)
