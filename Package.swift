// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwissPassClient",
        platforms: [
            .iOS(.v11),
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwissPassClient",
            targets: ["SwissPassClient"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(name: "SwissPassClient",
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/3.1.0/SwissPassClient_framework-3.1.0_r210830.1014.9.zip",
                      checksum: "b6f516e2fb9df036ea0e9dfd4254f99fc00232e34dd89bc4592f4e440eaa85f4"),
    ]
)
