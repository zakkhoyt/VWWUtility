//
//  UIView+Constraints.swift
//  Constraints
//
//  Created by Zakk Hoyt on 2/9/17.
//  Copyright © 2017 Zakk Hoyt. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    public enum PinStyle {
        case superview(edges: UIRectEdge = .all, insets: UIEdgeInsets = .zero)
        case margin(edges: UIRectEdge = .all, insets: UIEdgeInsets = .zero)
        case safeArea(edges: UIRectEdge = .all, insets: UIEdgeInsets = .zero)
    }

    public func pinEdgesToParent(
        pinStyle: PinStyle = .superview(edges: .all, insets: .zero)
    ) {
        pinEdgesToParent(pinStyles: [pinStyle])
    }

    public func pinEdgesToParent(
        pinStyles: [PinStyle]
    ) {
        guard let superview else {
            assertionFailure("View must have a superview")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        pinStyles.forEach { pinStyle in
            switch pinStyle {
            case .superview(let edges, let insets):
                if edges.contains(.left) {
                    leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
                }

                if edges.contains(.right) {
                    trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
                }

                if edges.contains(.top) {
                    topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
                }

                if edges.contains(.bottom) {
                    bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
                }
            case .margin(let edges, let insets):
                if edges.contains(.left) {
                    leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor, constant: insets.left).isActive = true
                }

                if edges.contains(.right) {
                    trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor, constant: -insets.right).isActive = true
                }

                if edges.contains(.top) {
                    topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: insets.top).isActive = true
                }

                if edges.contains(.bottom) {
                    bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: -insets.bottom).isActive = true
                }

            case .safeArea(let edges, let insets):
                if edges.contains(.left) {
                    leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left).isActive = true
                }

                if edges.contains(.right) {
                    trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right).isActive = true
                }

                if edges.contains(.top) {
                    topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
                }

                if edges.contains(.bottom) {
                    bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
                }
            }
        }
    }

    /// Snaps edges of view to edges of containerView with insets. Default insets = 0
    public func snapEdgesToSuperview(insets: UIEdgeInsets = .zero) {
        if superview == nil {
            assertionFailure("view doesn't have a superview")
        }

        translatesAutoresizingMaskIntoConstraints = false

        let leading = NSLayoutConstraint(
            item: self,
            attribute: .leading,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .leading,
            multiplier: 1.0,
            constant: insets.left
        )
        let trailing = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -insets.right
        )
        let top = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .top,
            multiplier: 1.0,
            constant: insets.top
        )
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -insets.bottom
        )

        superview!.addConstraints(
            [
                leading,
                trailing,
                top,
                bottom
            ]
        )
    }

    /// Snaps to top right corner of containerView
    public func snapToBottomRightCornerOfSuperview(
        insets: UIEdgeInsets = .zero,
        size: CGSize? = nil
    ) {
        if superview == nil {
            assertionFailure("view doesn't have a superview")
        }

        translatesAutoresizingMaskIntoConstraints = false

        let trailing = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -insets.right
        )
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superview!,
            attribute: .bottom,
            multiplier: 1.0,
            constant: insets.top
        )

        var constraints: [NSLayoutConstraint] = [
            bottom,
            trailing
        ]
        if let size {
            let width = NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: superview!,
                attribute: .width,
                multiplier: 0,
                constant: size.width
            )
            let height = NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: superview!,
                attribute: .height,
                multiplier: 0,
                constant: size.height
            )

            constraints.append(height)
            constraints.append(width)
        } else {
            let width = NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: superview!,
                attribute: .width,
                multiplier: 0,
                constant: bounds.width
            )
            let height = NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: superview!,
                attribute: .height,
                multiplier: 0,
                constant: bounds.height
            )

            constraints.append(height)
            constraints.append(width)
        }

        superview!.addConstraints(constraints)
    }

    /// Constrains the x and y anchors to the parent's x and y anchors.
    public func centerInParent() {
        guard let superview else {
            assertionFailure("View must have a superview")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    /// Pins the view to edges of the parent's superview.
    ///
    /// - Parameters:
    ///   - edges: The edges to pin to the parent's superview.
    ///   - useLayoutMargins: Whether to use parent's layout margin guide or not.
    public func pinEdgesToParent(
        _ edges: UIRectEdge = .all,
        useLayoutMargins: Bool = false,
        insets: UIEdgeInsets = .zero
    ) {
        guard let superview else {
            assertionFailure("View must have a superview")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        if edges.contains(.left) {
            let superviewLeadingAnchor = useLayoutMargins ?
                superview.layoutMarginsGuide.leadingAnchor :
                superview.leadingAnchor
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: insets.left).isActive = true
        }

        if edges.contains(.right) {
            let superviewTrailingAnchor = useLayoutMargins ?
                superview.layoutMarginsGuide.trailingAnchor :
                superview.trailingAnchor
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -insets.right).isActive = true
        }

        if edges.contains(.top) {
            let superviewTopAnchor = useLayoutMargins ?
                superview.layoutMarginsGuide.topAnchor :
                superview.topAnchor
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: insets.top).isActive = true
        }

        if edges.contains(.bottom) {
            let superviewBottomAnchor = useLayoutMargins ?
                superview.layoutMarginsGuide.bottomAnchor :
                superview.bottomAnchor
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -insets.bottom).isActive = true
        }
    }

    /// Pin the view to the X/Y center, but also pins inside superview bounds (so that the view cannot flow outside of superview)
    /// - Parameter priority: The priority
    /// - Parameter insets: Insets from superview.bounds
    public func pinToCenterInsideBounds(
        boundsPriority priority: UILayoutPriority = UILayoutPriority.defaultLow,
        insets: UIEdgeInsets = .zero
    ) {
        guard let superview else {
            assertionFailure("View must have a superview")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: insets.left, priority: priority),
            trailingAnchor.constraint(greaterThanOrEqualTo: superview.trailingAnchor, constant: insets.right, priority: priority),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: insets.top, priority: priority),
            bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor, constant: insets.bottom, priority: priority)
        ])
    }
}

extension NSLayoutDimension {
    public func constraint(
        equalTo anchor: NSLayoutDimension,
        priority: UILayoutPriority,
        multiplier m: CGFloat = 1,
        constant c: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    public func constraint(
        greaterThanOrEqualTo anchor: NSLayoutDimension,
        priority: UILayoutPriority,
        multiplier m: CGFloat = 1,
        constant c: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    public func constraint(
        lessThanOrEqualTo anchor: NSLayoutDimension,
        priority: UILayoutPriority,
        multiplier m: CGFloat = 1,
        constant c: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    public func constraint(
        equalToConstant c: CGFloat,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = constraint(equalToConstant: c)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutXAxisAnchor {
    public func constraint(
        equalTo anchor: NSLayoutXAxisAnchor,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }

    public func constraint(
        greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    public func constraint(
        equalTo anchor: NSLayoutYAxisAnchor,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }

    public func constraint(
        greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
}

extension UIEdgeInsets {
    /// Create a UIEdgeInsets with the same inset on all sides.
    public init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
}

extension UIView {
    /// Sets content hugging priorty relative to another already existing priority
    /// - Parameters:
    ///   - view: A different view to relate to
    ///   - offset: The amount to offset the `UILayoutPriority`'s rawValue by.
    ///   - axis: horizontal or vertical
    public func setContentHuggingPriority(
        relativeTo view: UIView,
        offsetBy offset: Float,
        for axis: NSLayoutConstraint.Axis
    ) {
        setContentHuggingPriority(
            UILayoutPriority(
                rawValue: UILayoutPriority.clip(
                    priority: view.contentHuggingPriority(for: axis).rawValue + offset
                )
            ),
            for: axis
        )
    }

    /// Sets content compressions resistance priorty relative to anothe already existing priority.
    /// - Parameters:
    ///   - view: A different view to relate to
    ///   - offset: The amount to offset the `UILayoutPriority`'s rawValue by.
    ///   - axis: horizontal or vertical
    public func setContentCompressionResistancePriority(
        relativeTo view: UIView,
        offsetBy offset: Float,
        for axis: NSLayoutConstraint.Axis
    ) {
        setContentCompressionResistancePriority(
            UILayoutPriority(
                rawValue: UILayoutPriority.clip(
                    priority: view.contentCompressionResistancePriority(for: axis).rawValue + offset
                )
            ),
            for: axis
        )
    }
}

extension UILayoutPriority {
    static func clip<T: Comparable & Numeric>(priority: T) -> T {
        var rawValue = priority
        rawValue = max(1, rawValue)
        rawValue = min(1000, rawValue)
        return rawValue
    }
}
#endif
