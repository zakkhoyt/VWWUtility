// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
/// These arguments enables upcoming Swift features.
///
/// ## Finding Upcoming Features
/// Upcoming features are listed on the [Swift Evolutions Dashboard](https://www.swift.org/swift-evolution/#?upcoming=true).
/// Each feature flag is defined in the header list with details down in the body (typically in the `Source Compatibility` section).
///
/// ## Enabling Feature Flags
/// * Xcode: See the [In Xcode](https://www.swift.org/blog/using-upcoming-feature-flags/) section
/// * Swift Package Manager: See the [In SwiftPM Packages](https://www.swift.org/blog/using-upcoming-feature-flags/) section
///
/// ## Checking features in code
/// ```swift
/// #if compiler(>=5.8)
///   #if hasFeature(BareSlashRegexLiterals)
///     let regex = /.../
///   #else
///     let regex = #/.../#
///   #endif
/// #else
///   let regex = try NSRegularExpression(pattern: "...")
/// #endif
/// ```
///
/// ## Feature Flags
/// * [(SE-0274) ConciseMagicFile](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0274-magic-file.md)
///     * Changes `#file` to contain `<module-name>/<file-name>` and adds `#filePath` to contain the full path (former #file behavior)
///     * Implemented Swift 5.8, but dark until Swift 6.0 where it becomes a compiler error.
/// * [(SE-0286) ForwardTrailingClosures](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0286-forward-scan-trailing-closures.md) -
///     * Forward-scan matching for trailing closures
///     * Implemented Swift 5.3. Released in Swift 5.8
/// * [(SE-0335) ExistentialAny](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md)
///     * Required protocols must be written `any Protocol`
///     * Implemented Swift 5.8, but dark until Swift 6.0 where it becomes a compiler error..
/// * [(SE-0337) StrictConcurrency](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md)
///     * Help developers migrate their code to support modern concurrency making the transition to Swift 6 easier
///     * Implemented Swift 5.6, but dark until Swift 6.0 where it becomes a compiler error..
/// * [(SE-0352) ImplicitOpenExistentials](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0352-implicit-open-existentials.md)
///     * Implemented Swift 5.6, but dark until Swift 6.0 where it becomes a compiler error..
///     * Make it easier to move from existentials back to the more strongly-typed generics:
/// * [(SE-0354) BareSlashRegexLiterals](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0354-regex-literals.md)
///     * Allows the use of regex syntax: `/.../`
///     * Note: Alternative syntax is available without this flag: `#/.../#`
///     * Alternative via compiler flag: `-enable-bare-slash-regex`
/// * SE-0354 - https://github.com/swiftlang/swift-evolution/blob/main/proposals/0354-regex-literals.md
///     * Implemented Swift 5.7, but dark until Swift 6.0 where it becomes a compiler error..
/// * [(SE-0383) DeprecateApplicationMain](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0383-deprecate-uiapplicationmain-and-nsapplicationmain.md)
///     * Deprecates @UIApplicationMain and @NSApplicationMain
///     * Implemented in Swift 5.10, but dark until Swift 6
/// * [(SE-0384) ImportObjcForwardDeclarations](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0384-importing-forward-declared-objc-interfaces-and-protocols.md)
///     * Importing Forward Declared Objective-C Interfaces and Protocols. This proposal seeks to improve the usability of existing Objective-C libraries from Swift by reducing the negative impact forward declarations have on API visibility from Swift
///     * Implemented in Swift 5.9, but dark until Swift 6
/// * [(SE-0401) DisableOutwardActorInference](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0401-remove-property-wrapper-isolation.md)
///     * Remove Actor Isolation Inference caused by Property Wrappers.
///     When [SE-0316 GlobalActors](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0316-global-actors.md)
///     introduced annotations like `@MainActor` to isolate a type, function, or property to a particular global actor. It also introduced new rules for how that global actor isolation could be inferred. EX:
///     `Declarations that are not explicitly annotated with either a global actor or nonisolated can infer global actor isolation
///     from several different places`
///     Removing this inferrance will lead to more explicit code (less ambiguity).
///     * Implemented in Swift 5.9. Dark until Swift 6
/// * [(SE-0409) InternalImportsByDefault](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md)
///     * Access-level modifiers on import declarations. EX: `private import HatchCBCentralManagerClient`
///     * Implemented in Swift 5.9, but dark until Swift 6.0
/// * [(SE-0411) IsolatedDefaultValues](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0411-isolated-default-values.md)
///     * Isolated default value expressions. The current actor isolation rules for initial values of stored properties admit data races.
///     * Implmented in Swfit 5.10, but dark until Swift 6.0
/// * [(SE-0412) GlobalConcurrency](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0412-strict-concurrency-for-global-variables.md)
///     * Under strict concurrency checking, require every global variable to either be isolated to a global actor or be both:
///     * Implemented Swift 5.10, but dark until Swift 6.0 where it becomes a compiler error.
/// * [(SE-0414) RegionBasedIsolation](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0414-region-based-isolation.md)
///     * Region based Isolation. Swift Concurrency assigns values to isolation domains determined by actor and task boundaries.
///     In practice, this is a significant semantic restriction, because it forbids natural programming patterns that are free of data races.
///     Adds new control flow sensitive diagnostic that enables transferring non-Sendable values across isolation boundaries and
///     emits errors at use sites of non-Sendable values that have already been transferred to a different isolation domain.
/// * [(SE-0418) InferSendableFromCaptures](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0418-inferring-sendable-for-methods.md)
///     * Inferring Sendable for methods and key path literals. This proposal is focused on a few corner cases in the language surrounding functions as values and key path literals
///     when using concurrency. The goal is to improve flexibility, simplicity, and ergonomics without significant changes to Swift.
///     * Implemented in Swift 6.0
/// * [(SE-0423) DynamicActorIsolation](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0423-dynamic-actor-isolation.md)
///     * Dynamic actor isolation enforcement from non-strict-concurrency contexts. A `@preconcurrency` import statement downgrades concurrency-related error messages that
///     the programmer cannot resolve because the fundamental issue is in one of the dependencies. To strengthen Swift's data-race safety guarantees while working with
///     preconcurrency dependencies, this proposals adds actor isolation checking at runtime for synchronous isolated functions.
///     * Implemented in Swift 6.0
/// * [(SE-0434) GlobalActorIsolatedTypesUsability](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0434-global-actor-isolated-types-usability.md)
///     * Usability of global-actor-isolated types. This proposal encompasses a collection of changes to concurrency rules concerning global-actor-isolated types to improve their usability.
///     * Implemented in Swift 6.0
/// * [(SE-0444) MemberImportVisibility](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md)
///     * Member import visibility. In Swift, there are rules dictating whether the name of a declaration in another module is considered in scope. This SE resovles those conflicts at an earlier timing
/// * [(SE-0446) NonescapableTypes](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0446-non-escapable.md)
///     * Nonescapable Types. Adds a new type constraint `~Escapable` for types that can be locally copied but cannot be assigned or transferred outside of the immediate context.
///     * Implemented in `main` branch (not yet part of public Swift)
///
/// ## Compiler Flags
/// * [-enable-actor-data-race-checks](https://forums.swift.org/t/concurrency-in-swift-5-and-6/49337)
///     * Diagnoses runtime data races caused by missed checks in `Swift 5`.
///     * EX: Swift 5 code executes a non @Sendable closure concurrently this flag will detect that a synchronous actor-isolated function was called on the wrong executor.
/// * [-warn-concurrency](https://forums.swift.org/t/concurrency-in-swift-5-and-6/49337)
///     * Warns about Swift 5 code that will be invalid under the Swift 6 rules.
///     * EX: Sendable will be checked but missing Sendable conformances will produce a warning (rather than an error).
///
/// ## Enabling Swift Flags (Swift Package Manager)
/// Just pass into the `swiftSettings` parameter:
/// ```swift
/// .target(
///     name: "MyTarget",
///     path: "...",
///     swiftSettings: swiftSettings
/// )
/// ```
let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ConciseMagicFile"), // SE-0274
    .enableUpcomingFeature("ForwardTrailingClosures"), // SE-0286
    .enableUpcomingFeature("ExistentialAny"), // SE-0335
    .enableUpcomingFeature("StrictConcurrency"), // SE-0337
    .enableUpcomingFeature("ImplicitOpenExistentials"), // SE-0352
    .enableUpcomingFeature("BareSlashRegexLiterals"), // SE-0354
    //    .enableUpcomingFeature("DeprecateApplicationMain"), // SE-0383
    //    .enableUpcomingFeature("ImportObjcForwardDeclarations"), // SE-0384
    //    .enableUpcomingFeature("DisableOutwardActorInference"), // SE-0401
    //    .enableUpcomingFeature("InternalImportsByDefault"), // SE-0409
    //    .enableUpcomingFeature("IsolatedDefaultValues"), // SE-0411
    //    .enableUpcomingFeature("GlobalConcurrency"), // SE-0412
    //    .enableUpcomingFeature("RegionBasedIsolation"), // SE-0414
    //    .enableUpcomingFeature("InferSendableFromCaptures"), // SE-0418
    //    .enableUpcomingFeature("DynamicActorIsolation"), // SE-0423
    //    .enableUpcomingFeature("GlobalActorIsolatedTypesUsability"), // SE-0434
    //    .enableUpcomingFeature("MemberImportVisibility"), // SE-0444
    //    .enableUpcomingFeature("NonescapableTypes"), // SE-0446
        .unsafeFlags(
            [
                "-enable-actor-data-race-checks",
                "-warn-concurrency"
            ]
        )
]
#warning("TODO: @zakkhoyt - Update iOS/MacOS")
#warning("TODO: @zakkhoyt - Add TerminalUtils package")
#warning("TODO: @zakkhoyt - Import utils from other code")
#warning("TODO: @zakkhoyt - Add linting/formatting tools/plugins")

let package = Package(
    name: "VWWUtility",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BaseUtility",
            targets: ["BaseUtility"]
        ),
        .library(
            name: "CameraToolbox",
            targets: ["CameraToolbox"]
        ),
        .library(
            name: "CodableUtilities",
            targets: ["CodableUtilities"]
        ),
        .library(
            name: "DrawingUI",
            targets: ["DrawingUI"]
        ),
        .library(
            name: "HIDMonitor",
            targets: ["HIDMonitor"]
        ),
        .library(
            name: "HTTPServices",
            targets: ["HTTPServices"]
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
            name: "CameraToolbox",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
                "ComputerVision/"
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "CameraToolboxTests",
            dependencies: [
                "BaseUtility",
                "CameraToolbox"
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "BaseUtility",
            dependencies: [
                .product(
                    name: "Collections",
                    package: "swift-collections"
                )
            ],
            resources: [
                // Causes SPM to generate Bundle.module
                .copy("Resources/Placeholder.txt")
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "BaseUtilityUnitTests",
            dependencies: ["BaseUtility"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BaseUtilityIntegrationTests",
            dependencies: ["BaseUtility"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CodableUtilities",
            dependencies: [],
            resources: []
        ),
        .testTarget(
            name: "CodableUtilitiesTests",
            dependencies: [
                "CodableUtilities"
            ]
        ),
        .target(
            name: "DrawingUI",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
                "Color/Palletes/references/"
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .target(
            name: "HIDMonitor",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .target(
            name: "HTTPServices",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "HTTPServiceTests",
            dependencies: [
                "HTTPServices",
            ],
            swiftSettings: swiftSettings
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
            name: "SystemSettings",
            dependencies: [
                "BaseUtility"
            ],
            exclude: [
                "README.md",
                "applescript/",
            ],
            resources: [
                // Causes SPM to generate Bundle.module
                .copy("Resources/Placeholder.txt")
            ],
            swiftSettings: swiftSettings,
            plugins: []
        ),
        .testTarget(
            name: "SystemSettingsTests",
            dependencies: [
                "BaseUtility",
                "SystemSettings"
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
