//
// PreliminaryWorkViewModifier.swift
//
// Created by Zakk Hoyt on 5/6/24.
//

import SwiftUI

#warning("FIXME: zakkhoyt - Expose these files through Swift Package")

// MARK: - Trying a different approach using ViewModifier

/// This ViewModifier provides a point to execute some work **before** the view is loaded (via closure).
/// When working with `Canvas Preview` this can be useful to execute "set up" code (similar to `AppDelegate`)
///
/// ## References
///
/// * [Based off of this reddit post](https://www.reddit.com/r/SwiftUI/comments/njntiq/how_to_use_custom_fonts_in_previews_when_in_a/)
///
struct PreliminaryWorkViewModifier: ViewModifier {
    init(_ perform: () -> Void) {
        perform()
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    /// Provides a place to perform any work that needs ot be done *prior* to `some View` loading. For example:
    /// Loading fonts from a Swit Package.
    ///
    /// If you store your fonts in a Swift Package, you've probably had a hard time getting them to render in SwiftUI Canvas
    /// Previews, falling back to the system font.
    ///
    /// When fonts are stored in a Swift Package, they must be programmatically registered early in the app's lifecycle
    /// (typically at the `AppDelegate` level), which `Previews` does not call.
    ///
    /// One might think to execute this code in `.onAppear(perform:)`. but at that point, it's too late.
    /// The fonts must be registered *before* view is loaded.
    ///
    /// This extension provides a solution: use the `.willLoad { ... }` `ViewModifier`
    ///
    /// ```swift
    /// var body: some View {
    ///    Button("Title") {}
    ///        .font(.custom(fontName, size: 20))
    ///        .willLoad {
    ///            _ = try? BundleHelper.loadFonts()
    ///        }
    /// }
    /// ```
    ///
    /// - Invariant: The `perform` closure will always be executed
    /// - SeeAlso: ``.willPreview(_)``
    func willLoad(_ perform: () -> Void) -> some View {
        modifier(
            PreliminaryWorkViewModifier(perform)
        )
    }

    /// This `ViewModifer` is a restricted version of `.willLoad(perform:)` in that the `perform`
    /// closure is only called during `Canvas Preview` sessions (not called when running device, simulator, etc...).
    ///
    /// - Requires: This variant requires that the execution environment is `Preview Canvas` otherwise  the `perform`
    /// closure will be gracefully skipped. This function will simply return.
    /// - SeeAlso: ``.willLoad(perform:)``
    func willPreview(_ perform: () -> Void) -> some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            modifier(PreliminaryWorkViewModifier(perform))
        } else {
            modifier(PreliminaryWorkViewModifier {})
        }
    }
}

// The purpose of this preview is to ensure that fonts are loaded from
// a Swift package during Canvas Preview (vs falling back to SF Pro).
#Preview(
    "PreliminaryWorkViewModifier",
    traits: .landscapeLeft
) {
    VStack {
        ForEach(0..<10) { i in
            Button("Font Preview Test - i: \(i)") {}
                .font(.custom("ArcadeClassic", size: 20))
        }
    }
    .willPreview {
        _ = try? BundleHelper.loadFonts()
    }
}
