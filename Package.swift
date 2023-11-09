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
            name: "Nodes",
            targets: ["Nodes"]
        )
        // ,
        // .library(
        //     name: "WaveSynthesizer",
        //     targets: ["WaveSynthesizer"]
        // ),
        // .library(
        //     name: "WaveSynthesizerUI",
        //     targets: ["WaveSynthesizerUI"]
        // )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BaseUtility",
            dependencies: [],
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
            name: "VWWUtility",
            dependencies: [
                "BaseUtility",
                "Nodes"
            ],
            exclude: [
                ".gitignored/"
            ],
            resources: [
                // .process("Resources/Strings/Localizable.stringsdict"),
                // .copy("Resources/Fonts/Fonts.bundle"),
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
//         .target(
//             name: "WaveSynthesizerUI",
//             dependencies: [
//                 "BaseUtility",
//                 "DrawingUI",
//                 "WaveSynthesizer"
//             ],
//             exclude: [
// //                ".gitignored/"
//             ],
//             resources: [
// //                .process("View/SwiftUI/Buffer/AudioBuffer/Subviews/Shader/AudioBufferShader.metal"),
// //                .process("View/SwiftUI/Buffer/AudioBufferFFT/Subviews/Shader/FFTBufferShader.metal")
//             ],
//             swiftSettings: swiftSettings
//         ),
        .testTarget(
            name: "NodesTests",
            dependencies: ["Nodes"],
            swiftSettings: swiftSettings
        ),
        // .testTarget(
        //     name: "WaveSynthesizerTests",
        //     dependencies: ["WaveSynthesizer"],
        //     swiftSettings: swiftSettings
        // ),
    ]
)
