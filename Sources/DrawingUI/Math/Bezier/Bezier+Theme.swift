//
//  Bezier+Theme.swift
//  Bezier+Theme
//
//  Created by Zakk Hoyt on 9/8/21.
//

#if os(iOS)
import BaseUtility
import UIKit

protocol TextTheme {
    var font: UIFont { get }
    var textColor: UIColor { get }
    var textIsHidden: Bool { get }
}

protocol ShadowTheme {
    var shadowColor: UIColor? { get }
    var shadowRadius: CGFloat? { get }
}

protocol ShapeTheme: ShadowTheme {
    var size: CGSize { get }
    var fillColor: UIColor { get }
    var strokeColor: UIColor { get }
    var borderWidth: CGFloat { get }
}

protocol LineTheme: ShadowTheme {
    var color: UIColor { get }
    var lineWidth: CGFloat { get }
}

protocol LineStrideTheme: LineTheme {
    var stride: Int { get }
}

extension Bezier {
    struct Theme {
        struct ControlPoint: ShapeTheme {
            let font: UIFont
            let textColor: UIColor
            let textIsHidden: Bool
            let size: CGSize

            let fillColor: UIColor
            let strokeColor: UIColor
            let borderWidth: CGFloat

            let shadowColor: UIColor?
            let shadowRadius: CGFloat?
        }

        struct Line: LineTheme {
            let color: UIColor
            let lineWidth: CGFloat

            let shadowColor: UIColor?
            let shadowRadius: CGFloat?

            init(
                color: UIColor,
                lineWidth: CGFloat,
                shadowColor: UIColor? = nil,
                shadowRadius: CGFloat? = nil
            ) {
                self.color = color
                self.lineWidth = lineWidth
                self.shadowColor = shadowColor
                self.shadowRadius = shadowRadius
            }
        }

        struct LineSet: LineStrideTheme {
            let color: UIColor
            let lineWidth: CGFloat
            let stride: Int

            let shadowColor: UIColor?
            let shadowRadius: CGFloat?
        }

        struct Dot: LineTheme {
            let color: UIColor
            let lineWidth: CGFloat

            let shadowColor: UIColor?
            let shadowRadius: CGFloat?
        }

        // MARK: Render Inputs

        let controlPoint = ControlPoint(
            font: .preferredFont(forTextStyle: .caption1),
            textColor: .label,
            textIsHidden: false,
            size: CGSize(width: 44, height: 44),
            fillColor: .systemGreen.withAlphaComponent(0.25),
            strokeColor: .label,
            borderWidth: 2,
            shadowColor: nil,
            shadowRadius: nil
        )

        let path = Line(
            color: .label,
            lineWidth: 2,
            shadowColor: .label,
            shadowRadius: 4
        )

        let t = Dot(
            color: .label,
            lineWidth: 16,
            shadowColor: nil,
            shadowRadius: nil
        )

        let tangent = Line(
            color: .systemPink,
            lineWidth: 1,
            shadowColor: .systemPink,
            shadowRadius: 4
        )

        let stride = 4
        let strideTangent = Line(
            color: .systemGray.withAlphaComponent(0.5),
            lineWidth: 0.5,
            shadowColor: nil,
            shadowRadius: nil
        )

        let showStrideTangent = true
        let showPath = true
        let showControlPoints = true

        let calculationPoint = ControlPoint(
            font: .preferredFont(forTextStyle: .caption1),
            textColor: .label,
            textIsHidden: false,
            size: CGSize(width: 22, height: 22),
            fillColor: .systemGreen.withAlphaComponent(0.5),
            strokeColor: .systemGreen,
            borderWidth: 2,
            shadowColor: nil,
            shadowRadius: nil
        )

        let calculationLine = Line(
            color: .systemGreen.withAlphaComponent(0.5),
            lineWidth: 0.5,
            shadowColor: nil,
            shadowRadius: nil
        )
//
//        let basisFunctionPlot = Line(
//            color: .label,
//            lineWidth: 1,
//            shadowColor: .label,
//            shadowRadius: 0
//        )

        func basisFunctionPlot(index: Int) -> Line {
            Line(
                color: color(index: index),
                lineWidth: 1
            )
        }
        
        func color(index: Int) -> UIColor {
            switch index {
            case 0: UIColor(hexString: "#FE1060")
            case 1: UIColor(hexString: "#3BC3FE")
            case 2: UIColor(hexString: "#0FFEB3")
            case 3: UIColor(hexString: "#E3C854")
            case 4: .magenta
            case 5: .systemOrange
            case 6: .systemPink
            default: .label
            }
        }
    }
}

#endif
