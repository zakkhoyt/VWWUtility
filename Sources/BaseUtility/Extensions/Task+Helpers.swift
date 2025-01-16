//
//  Task+Helpers.swift
//
//  Created by Zakk Hoyt on 7/20/23.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(duration: TimeInterval) async {
        do {
            try await Task.sleep(nanoseconds: UInt64(duration * pow(10, 9)))
        } catch {
            assertionFailure("Task.sleep failed with error: \(error)")
        }
    }
}
