//
//  MultilineListDescription.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 5/12/25.
//

enum MultilineListDescription {
    // static func describe<T>(value: T) -> String where T == AnyHashable {
    static func describe<T: Hashable>(
        value: T,
        indentLevel: Int
    ) -> String {
        #warning(
            """
            TODO: zakkhoyt - Check if value is array or dict, then call .multilineListDescription
            """
        )

        let valueDescription: String = if type(of: value) is String, let valueString = value as? String {
            valueString.quoted
        } else if let valueString = value as? [T] {
            valueString.multilineListDescription(indentLevel: indentLevel + 1)
        } else if let valueString = value as? [String: T] {
            valueString.multilineListDescription(indentLevel: indentLevel + 1)
        } else if let valueString = value as? any CustomStringConvertible {
            valueString.description.quoted
        } else if let valueString = value as? any CustomDebugStringConvertible {
            valueString.debugDescription.quoted
        } else {
            String(describing: value)
        }
        return valueDescription
    }
}
