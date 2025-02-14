//
//  Mirror+Reflect_T.swift
//  WaveSynthesizer-iOS
//
//  Created by Zakk Hoyt on 6/22/19.
//  Copyright © 2019 Zakk Hoyt. All rights reserved.
//

import Foundation

extension Mirror {
    
#warning("TODO: zakkhoyt - Try using generic '<S: StringProtocol>")
    //@inlinable public init?<S>(_ text: S, radix: Int = 10) where S : StringProtocol
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
    /// represented as a dictionary.
    /// - Parameters:
    ///   - target: The instance to inspect/reflect.
    ///   - type: The type of interest
    /// - Returns: A list of tuples `[String: T]`
    /// - Remark: This does not apply to computed properties.
    public static func propertiesDictionary<T>(
        reflecting target: Any,
        matchingType type: T.Type = T.self
    ) -> [String: T] {
        Mirror.reflectProperties(
            of: target,
            matchingType: type
        )
        .reduce(into: [:]) {
            $0[$1.name] = $1.value
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
    
    /// Inspects the properties of the instance of `target` to distill a list of propertyDescriptions
    /// of the format `"\(child.label): \(child.value)"`
    /// - Parameters:
    ///   - target: The instance to inspect/reflect.
    ///   - type: The type of interest
    /// - Returns: A list of tuples `(propertyName: String, property: T)`
    /// - Remark: This does not apply to computed properties.
    /// - Important: Mirror does not reflect `computed properties`, so take this into account
    /// by reading the source code for `target`
    public static func reflectPropertyDescriptions(
        of target: Any
    ) -> [String] {
        logger.debug("MIRROR reflecting \(String(describing: target))")
        let children = Mirror(reflecting: target)
            .children
        
        logger.debug("MIRROR children.count: \(children.count)")
        let propertyDescriptions: [String] = children.compactMap { child in
            //                        guard let label = $0.label, let value = $0.value as? any CustomStringConvertible else {
            //                            return nil
            //                        }
            guard let label = child.label else {
                logger.error("MIRROR Child has no label: \(String(describing: child))")
                return nil
            }
            
            logger.debug("MIRROR label: \(label)")
            guard let valueString: String = {
                if let value = child.value as? Bool {
                    return value.boolString
                } else if let value = child.value as? (any BinaryFloatingPoint) {
                    return "\(value)"
                } else if let value = child.value as? (any BinaryInteger) {
                    return "\(value)"
                } else if let value = child.value as? Int {
                    return "\(value)"
                } else if let value = child.value as? Float {
                    return "\(value)"
                } else if let value = child.value as? Double {
                    return "\(value)"
                } else if let value = child.value as? String {
                    return "\(value)"
                } else if let value = child.value as? Data {
                    return "\(value.hexString)"
                } else if let value = child.value as? Date {
                    return "\(value.iso8601String)"
                } else {
                    logger.error("MIRROR \(label) could not be cast to string")
                    return nil
                }
            }() else {
                logger.error("MIRROR \(label) could not be converted to property string")
                return nil
            }
            let propertyDescription = "\(label): \(valueString)"
            logger.debug("MIRROR Did compute propertyDescription: \(propertyDescription)")
            return propertyDescription
        }
        
        return propertyDescriptions
    }
}
