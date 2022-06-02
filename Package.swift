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
                      url: "https://github.com/SchweizerischeBundesbahnen/SwissPassSDK-iOS/releases/download/4.0/SwissPassClient_framework-4.0_r220602.2122.15.zip",
                      checksum: "warning: Usage of /Users/admin/Library/org.swift.swiftpm/collections.json has been deprecated. Please delete it and use the new /Users/admin/Library/org.swift.swiftpm/configuration/collections.json instead.
cb53791de75cdeb8c38772334775bfc43d0c9a6c481cca4237f24efc1966d2c3"),
    ]
)
