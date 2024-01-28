//
//  UIViewController+SwiftUI.swift
//  Bezier
//
//  Created by Zakk Hoyt on 9/5/21.
//

#if os(iOS)
    import SwiftUI
    import UIKit

    extension UIViewController {
        public func embedSwiftUI(view swiftUIView: some View) {
            let hostingController = UIHostingController(rootView: swiftUIView)
            addChild(hostingController)
            hostingController.didMove(toParent: self)
            view.addSubview(hostingController.view)
            hostingController.view.pinEdgesToParent()
        }
    }
#endif
