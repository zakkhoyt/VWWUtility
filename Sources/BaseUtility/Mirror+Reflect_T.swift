//
//  Mirror+Reflect_T.swift
//  WaveSynthesizer-iOS
//
//  Created by Zakk Hoyt on 6/22/19.
//  Copyright © 2019 Zakk Hoyt. All rights reserved.
//

import Foundation

extension Mirror {
    /// Inspects the properties of the instance of `target` to distill a list of all properties of `matchingType`
    /// - Parameters:
    ///   - target: The instance to inspect/reflect.
    ///   - type: The type of interest
    /// - Returns: A list of tuples `(propertyName: String, property: T)`
    /// - Remark: This does not apply to computed properties.
    public static func reflectProperties<T>(
        of target: Any,
        matchingType type: T.Type = T.self
    ) -> [(name: String, value: T)] {
        Mirror(reflecting: target)
            .children
            .compactMap {
                guard let label = $0.label, let value = $0.value as? T else {
                    return nil
                }
                return (label, value)
            }
    }
    
    /// Inspects the properties of the instance of `target` to distill a list of all properties of `matchingType`
    /// - Parameters:
    ///   - target: The instance to inspect/reflect.
    ///   - type: The type of interest
    /// - Returns: A list of tuples `(propertyName: String, property: T)`
    /// - Remark: This does not apply to computed properties.
    public static func reflectProperties(
        of target: Any
    ) -> [(name: String, value: String)] {
        Mirror(reflecting: target)
            .children
            .compactMap {
                guard let label = $0.label else {
                    return nil
                }
                if let value = $0.value as? Float {
//                    return (label, String(format: "%.03f", value))
                    return (label, String(format: "%.2f", value))
//                    return (label, "\(Int(value))")
                } else if let value = $0.value as? Double {
//                    return (label, String(format: "%.03f", value))
                    return (label, String(format: "%.2f", value))
//                    return (label, "\(Int(value))")
                } else if let value = $0.value as? any BinaryInteger {
                    return (label, "\(value)")
                } else if let value = $0.value as? Bool {
                    return (label, "\(value ? "true" : "false")")
                }  else {
                    return (label, String(describing: $0.value))
                }
            }
    }

    
    /// Inspects the properties of the instance of `target` to distill a list of all property instances of `matchingType`.
    /// Very similar to `reflectProperties(...)`, but returns only the property values.
    /// - Parameters:
    ///   - target: The instance to inspect/reflect.
    ///   - type: The type of interest
    /// - Returns: A list of property values `property: T` (Does not return the property names. See `reflectProperties(...)` for this).
    /// - Remark: This does not apply to computed properties.
    public static func reflectInstances<T>(
        of target: Any,
        matchingType type: T.Type = T.self
    ) -> [T] {
        Mirror(reflecting: target)
            .children
            .compactMap {
                guard let value = $0.value as? T else {
                    return nil
                }
                return value
            }
    }
}

//    //
//    //  Mirror+Properties.swift
//    //
//    //  Created by Zakk Hoyt on 10/09/23.
//    //
//
//    import Foundation
//
//    extension Mirror {
//        /// Inspects the properties of the instance of `target` to distill a list of all properties of `matchingType`
//        /// - Parameters:
//        ///   - target: The instance to inspect/reflect.
//        ///   - type: The type of interest
//        /// - Returns: A list of tuples `(propertyName: String, property: T)`
//        /// - Remark: This does not apply to computed properties.
//        public static func reflectProperties<T>(
//            reflecting target: Any,
//            matchingType type: T.Type = T.self
//        ) -> [(name: String, value: T)] {
//            Mirror(reflecting: target)
//                .children
//                .compactMap {
//                    guard let label = $0.label, let value = $0.value as? T else {
//                        return nil
//                    }
//                    return (label, value)
//                }
//        }
//
//        /// Inspects the properties of the instance of `target` to distill a list of all properties of `matchingType`
//        /// represented as a dictionary.
//        /// - Parameters:
//        ///   - target: The instance to inspect/reflect.
//        ///   - type: The type of interest
//        /// - Returns: A list of tuples `[String: T]`
//        /// - Remark: This does not apply to computed properties.
//        public static func propertiesDictionary<T>(
//            reflecting target: Any,
//            matchingType type: T.Type = T.self
//        ) -> [String: T] {
//            Mirror.reflectProperties(
//                reflecting: target,
//                matchingType: type
//            )
//            .reduce(into: [:]) {
//                $0[$1.name] = $1.value
//            }
//        }
//
//        /// Inspects the properties of the instance of `target` to distill a list of all property instances of `matchingType`
//        /// represented as a array of values.
//        /// - Parameters:
//        ///   - target: The instance to inspect/reflect.
//        ///   - type: The type of interest
//        /// - Returns: A list of property values `property: T` (Does not return the property names. See `reflectProperties(...)` for this).
//        /// - Remark: This does not apply to computed properties.
//        public static func reflectInstances<T>(
//            reflecting target: Any,
//            matchingType type: T.Type = T.self
//        ) -> [T] {
//            Mirror.reflectProperties(
//                reflecting: target,
//                matchingType: type
//            )
//            .reduce(into: []) {
//                $0.append($1.value)
//            }
//        }
//    }
