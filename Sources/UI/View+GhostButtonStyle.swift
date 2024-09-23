//
// View+GhostButtonStyle.swift
//
// Created by Zakk Hoyt on 5/6/24.
//

import SwiftUI

// MARK: - Custom View Modifier

struct GhostBorderColor: ViewModifier {
    let color: Color
    let cornerRadius: Double
    let strokeStyle: StrokeStyle
    
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.tint)
            .background(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .strokeBorder(
                    color,
                    style: strokeStyle
                )
            )
    }
}

extension View {
    func ghostBorder(
        color: Color,
        cornerRadius: Double = 8,
        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 4)
    ) -> some View {
        modifier(
            GhostBorderColor(
                color: color,
                cornerRadius: cornerRadius,
                strokeStyle: strokeStyle
            )
        )
    }
}

#Preview(
    "GhostBorderColor\nViewModifier",
    traits: .defaultLayout,
    .landscapeLeft
) {
//    do {
//        let loadedFonts = try FontLoader.loadFonts()
//        print("Did load fonts:\n\(loadedFonts.joined(separator: ", "))")
//    } catch {
//        print(error.localizedDescription)
//    }

    VStack {
        Button("#G") {}
            .tint(.green)
            .ghostBorder(color: .yellow)
    }
}

// MARK: - Stroke style to accompany Ghos

extension StrokeStyle {
    static var ghostDashed = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .miter,
        miterLimit: 0,
        dash: [5, 10],
        dashPhase: 0
    )
}

// //

//  MARK: - Custom Button Style

//
// struct GhostButtonStyle: ButtonStyle {
//    let cornerRadius: Double
//    let borderColor: Color
//    let strokeStyle: StrokeStyle
//
//    init(
//        cornerRadius: Double = 8,
//        borderColor: Color = .blue,
//        strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2)
//    ) {
//        self.cornerRadius = cornerRadius
//        self.borderColor = borderColor
//        self.strokeStyle = strokeStyle
//    }
//
//    func makeBody(
//        configuration: Configuration
//    ) -> some View {
//        configuration.label
//            .padding()
//            .foregroundStyle(.tint)
//            .background(
//                RoundedRectangle(
//                    cornerRadius: cornerRadius,
//                    style: .continuous
//                )
//                .strokeBorder(
//                    borderColor,
//                    style: strokeStyle
//                )
//            )
//    }
// }
//
// extension ButtonStyle where Self == GhostButtonStyle {
//    static var ghost: Self {
//        .init()
//    }
//
// #warning("FIXME: zakkhoyt - can we read/use .tint color instead of defaulting to .clear?")
//    static func ghost(
//        cornerRadius: Double = 8,
//        borderColor: Color = .clear,
//        strokeStyle: StrokeStyle
//    ) -> Self {
//        GhostButtonStyle(
//            cornerRadius: cornerRadius,
//            borderColor: borderColor,
//            strokeStyle: strokeStyle
//        )
//    }
// }
//
//
// struct GhostButton: View {
//    let title: String
//    let borderColor: Color
//    let cornerRadius: Double
//    let action: () -> Void
//
//    init(
//        title: String,
//        borderColor: Color = .clear,
//        cornerRadius: Double = 8,
//        action: @escaping () -> Void
//    ) {
//        self.title = title
//        self.borderColor = borderColor
//        self.cornerRadius = cornerRadius
//        self.action = action
//    }
//
//
//    var body: some View {
//        Button(title, action: action)
//            .buttonStyle(
//                .ghost(
//                    cornerRadius: cornerRadius,
//                    borderColor: borderColor,
//                    strokeStyle: .ghostDashed
//                )
//            )
//            .frame(maxWidth: .infinity, minHeight: 40)
//            .padding(0)
//            .font(.custom("ArcadeClassic", size: 20))
//    }
// }
//
// #Preview(
//    "GhostButton",
//    traits: .defaultLayout,
//    .landscapeLeft
// ) {
//    VStack {
//
//        GhostButton(
//            title: "#P",
//            borderColor: .orange,
//            cornerRadius: 8
//        ) {
//            print("GhostButton preview tapped")
//        }
//        .tint(.green)
//    }
// }
