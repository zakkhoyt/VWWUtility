//
//  UIImage+FallbackTintColor.swift
//
//  Created by Zakk Hoyt on 8/19/21.
//

#if os(iOS)

    import UIKit

    extension UIImage {
        /// Attempts to set the tint color where `color` is an optoinal `UIColor`.
        /// If `color` is nil, use fallback color
        /// - Parameter color: The desired tintColor `UIColor?`
        /// - Parameter fallbackColor: Color to fall back to if color is nil
        /// - Returns: A tinted UIImage
        public func withFallbackTintColor(
            _ color: UIColor?,
            fallbackColor: UIColor = .white
        ) -> UIImage {
            withTintColor(color ?? fallbackColor)
        }
    }

#endif
