// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
]

#warning("TODO: @zakkhoyt - Update iOS/MacOS")
#warning("TODO: @zakkhoyt - Add TerminalUtils package")
#warning("TODO: @zakkhoyt - Import utils from other code")
#warning("TODO: @zakkhoyt - Add linting/formatting tools/plugins")

let package = Package(
    name: "VWWUtility",
    platforms: [
        .iOS(.v15),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BaseUtility",
            targets: ["BaseUtility"]
        ),
        .library(
            name: "DrawingUI",
            targets: ["DrawingUI"]
        ),
        .library(
            name: "MultipeerEngine",
            targets: ["MultipeerEngine"]
        ),
        .library(
            name: "Nodes",
            targets: ["Nodes"]
        ),
        .library(
            name: "TerminalUtility",
            targets: ["TerminalUtility"]
        ),
        .library(
            name: "VWWUtility",
            targets: ["VWWUtility"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            from: "1.0.5"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BaseUtility",
            dependencies: [
                .product(
                    name: "Collections",
                    package: "swift-collections"
                )
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "BaseUtilityTests",
            dependencies: ["BaseUtility"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DrawingUI",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .target(
            name: "MultipeerEngine",
            dependencies: [
                .target(
                    name: "BaseUtility"
                ),
                .product(
                    name: "Collections",
                    package: "swift-collections"
                )
            ],
            exclude: [
                "Docs"
            ],

            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "MultipeerEngineTests",
            dependencies: ["MultipeerEngine"],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "MultipeerEngineTerminalApp",
            dependencies: [
                .target(
                    name: "BaseUtility"
                ),
                .target(
                    name: "MultipeerEngine"
                ),
                .target(
                    name: "TerminalUtility"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "Nodes",
            dependencies: [],
            exclude: [
                "Documents"
            ],
            resources: [],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "NodesTerminalApp",
            dependencies: [
                .target(
                    name: "Nodes"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "TerminalUtility",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
            ],
            resources: [
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "VWWUtility",
            dependencies: [
                "BaseUtility",
                "Nodes"
            ],
            exclude: [
            ],
            resources: [
            ],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "VWWUtilityTerminalApp",
            dependencies: [
                .target(
                    name: "VWWUtility"
                ),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "NodesTests",
            dependencies: ["Nodes"],
            swiftSettings: swiftSettings
        )
    ]
)
