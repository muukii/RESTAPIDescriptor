// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RESTAPIDescriptor",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "CLI", targets: ["CLI"]),
        .executable(name: "Demo", targets: ["Demo"]),
        .library(
            name: "RESTAPIDescriptor",
            targets: ["RESTAPIDescriptor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Demo",
            dependencies: ["RESTAPIDescriptor", "SPMUtility"]),
        .target(
            name: "CLI",
            dependencies: ["RESTAPIDescriptor", "SPMUtility"]),
        .target(
            name: "RESTAPIDescriptor",
            dependencies: []),
        .testTarget(
            name: "RESTAPIDescriptorTests",
            dependencies: ["RESTAPIDescriptor"]),
    ]
)
