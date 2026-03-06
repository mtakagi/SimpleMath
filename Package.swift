// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleMath",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimpleMath",
            targets: ["SimpleMath"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", exact: "1.30.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SimpleMath"
        ),
        .testTarget(
            name: "SimpleMathTests",
            dependencies: [
                "SimpleMath",
            ]
        ),
        .executableTarget(
            name: "SimpleMathBenchmarks",
            dependencies: [
                "SimpleMath",
                .product(name: "Benchmark", package: "package-benchmark")
            ],
            path: "Benchmarks/SimpleMathBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        ),
    ]
)
