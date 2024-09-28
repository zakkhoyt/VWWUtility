////
////  ArgumentRepresentable.swift
////
////  Created by Zakk Hoyt on 8/5/21.
////
//
// import Foundation
//
// public protocol ArgumentRepresentable: CaseIterable, RawRepresentable where RawValue == String {
//    /// Returns true if the flag should be paired with a parameter
//    /// Ex; `-f test.txt` woudl be true
//    /// Ex: `-q` would be false
//    var expectsParameter: Bool { get }
//
//    /// Returns a description fot the argument.
//    var argumentDescription: String { get }
//
//    /// Returns a usage header blur. This will be followed by each argumentDescription in a pretty format.
//    static var usageHeader: String { get }
// }
//
// extension CaseIterable where Self: ArgumentRepresentable {
//    public static var usage: String {
//        [
//            usageHeader,
//            allCases
//                .compactMap { "\($0.rawValue)\t\($0.argumentDescription)" }
//                .joined(separator: "\n")
//        ]
//            .joined(separator: "\n")
//    }
// }
//
// public enum Arguments {
//    // Returns the version passed in as first command line arg
//    public static func process<T: ArgumentRepresentable>() throws -> [T: String] {
//        var index = 1
//        var arguments: [T: String] = [:]
//
//        // Gets the next flag and parameters for that flag (if expected)
//        func getNextArgument() -> (T, String)? {
//            guard index < CommandLine.argc else {
// #if DEBUG
//                print("Looking to parse params at index [\(index)], but only have \(CommandLine.argc) arguments")
// #endif
//                return nil
//            }
//
//            guard let argumentFlag = T(rawValue: CommandLine.arguments[index]) else { return nil }
//            guard argumentFlag.expectsParameter else {
//                index += 1
// #if DEBUG
//                print("Parsed flag \(argumentFlag.rawValue) at [\(index)]")
// #endif
//                // TODO: Return something other than ""
//                return (argumentFlag, "")
//            }
//
//            index += 1
//            guard index < CommandLine.argc else {
// #if DEBUG
//                print("Looking to parse params at index [\(index), but only have \(CommandLine.argc) arguments")
// #endif
//                return nil
//            }
//            let parameter = CommandLine.arguments[index]
// #if DEBUG
//            print("Parsed flag \(argumentFlag.rawValue) and \(parameter) at [\(index) and \(index + 1)]")
// #endif
//            index += 1
//            return (argumentFlag, parameter)
//        }
//
//        /// Grab next pair (flag, parameter) and toss them into the dictionary
//        for _ in 0..<T.allCases.count {
//            guard let tuple = getNextArgument() else { break }
//            arguments[tuple.0] = tuple.1
//        }
//
//        return arguments
//    }
// }
