//
//  Ansi+Item.swift
//
//
//  Created by Zakk Hoyt on 1/27/24.
//

import Foundation

// protocol ANSICodeBuilder {
//     var ansi: any ANSIDescriber { get }
// }

extension ANSI {
    #warning("FIXME: zakkhoyt - Rename ANSI.Item. Maybe ANSI.Valued or similar. Item means nothing to the user.")
    /// Some `ANSI` codes cannot represented without more information.
    ///
    /// For example the `cursor` codes (`.cursorUp`, `cursorLeft`, etc.. )
    /// need a count value.
    ///
    /// This is where ANSI.Item comes in.
    public struct Item {
        public let ansi: ANSI
        public let values: [Int]
        public let code: String
        public let printableCode: String
        
        public init(
            _ ansi: ANSI,
            values: [Int] = []
        ) {
            assert(
                ansi.numberOfValues == values.count,
                "Attempted to instantiate ANSI.Item (\(ansi.summary)) with \(values.count). Requires \(ansi.numberOfValues)"
            )
            self.ansi = ansi
            self.values = values
            
            let valuesString = values.map { "\($0)" }.joined(separator: ";")
            
            let bareCode: String = switch ansi.parameterSequence {
            case .constantBeforeValue:
                [ansi.constant, valuesString].joined()
            case .valueBeforeConstant:
                [valuesString, ansi.constant].joined()
            }

            self.code = [
                ansi.prefix,
                bareCode,
                ansi.suffix
            ].compactMap { $0 }.joined()
            
            self.printableCode = [
                ansi.printablePrefix,
                bareCode,
                ansi.suffix
            ].compactMap { $0 }.joined()
        }
    }
}

extension ANSI.Item: ANSIDescriber {
    public var summary: String {
        ansi.summary
    }
    
    public var commandLineArguments: [String] {
        ansi.commandLineArguments
    }
    
    public var prefix: String {
        ansi.prefix
    }

    public var printablePrefix: String {
        ansi.printablePrefix
    }

    public var constant: String {
        ansi.constant
    }
    
    public var valuesSeparator: String {
        ansi.valuesSeparator
    }

    public var parameterSequence: ANSIParameterSequence {
        ansi.parameterSequence
    }

    public var suffix: String {
        ansi.suffix
    }
    
    public var helpUsageDescription: String {
        ansi.helpUsageDescription
    }
    
    public var numberOfValues: Int {
        ansi.numberOfValues
    }
    
    public var isDemonstrableInHelp: Bool {
        ansi.isDemonstrableInHelp
    }
}

extension String {
    public func wrap(
        before: ANSI.Item,
        after: ANSI.Item? = nil,
        surroundedBy text: String? = nil
    ) -> String {
        [
            before.code,
            text,
            self,
            text,
            after?.code
        ]
            .compactMap { $0 }
            .joined()
    }
}

// swiftlint:disable static_operator

public func + (left: ANSI.Item, right: String) -> String {
    left.code + right
}

public func + (left: String, right: ANSI.Item) -> String {
    left + right.code
}

// swiftlint:enable static_operator
