//
//  DisplayLink+OnFrame.swift
//  Bezier
//
//  https://github.com/timdonnelly/DisplayLink
//

import Combine
import SwiftUI

extension SwiftUI.View {
    public func onFrame(
        isActive: Bool = true,
        displayLink: DisplayLink = .shared,
        _ action: @escaping (DisplayLink.Frame) -> Void
    ) -> some View {
        SubscriptionView(
            content: self,
            publisher: isActive
                ? displayLink.eraseToAnyPublisher()
                : Empty<DisplayLink.Frame, Never>().eraseToAnyPublisher(),
            action: action
        )
    }
}
