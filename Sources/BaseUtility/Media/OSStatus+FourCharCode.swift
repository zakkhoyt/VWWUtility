//
// OSStatus+FourCharCode.swift
//
// Created by Zakk Hoyt on 2/21/24.
//

import Foundation

#warning("FIXME: zakkhoyt - Move this to a Media type package")
extension OSStatus {
    /// This function makes working with `OSStatus` a bit more "Swifty".
    ///
    /// The `osStatusProvider` is an autoclosure where you perform work which returns `OSStatus`.
    /// If `OSStatus == noErr` (aka `0`) return.
    /// If `OSStatus != noError` convert to `OSStatus.Error` which is then thrown.
    ///
    /// - Parameters:
    ///   - osStatusProvider: An autoclosure where you perform work which returns `OSStatus`.
    ///   - context: An optional `String` which is included in `OSStatus.Error`, if instantiate.
    /// - Throws: `OSStatus.Error`
    /// - SeeAlso: `OSStatus.Error`
    ///
    /// ```swift
    /// try OSStatus.throwUnlessNoErr(AudioOutputUnitStart(audioUnit))
    ///
    /// // Or you can pass in an optional context to include in any error thrown.
    /// try OSStatus.throwUnlessNoErr(
    ///     AudioOutputUnitStart(audioUnit),
    ///     context: "Create new IOUnit with AudioComponentInstanceNew"
    /// )
    /// ```
    /// And an example `OSStatus.Error`:
    /// ```
    /// (lldb) po error.localizedDescription
    /// context: "Initializing audioUnit", fourCharCode: "fmt?", osStatus: "1718449215 0x666D743F"
    /// ```
    public static func throwUnlessNoErr(
        _ osStatusProvider: @autoclosure () -> OSStatus,
        context: String? = nil
    ) throws {
        let code: OSStatus = osStatusProvider()
        if code == noErr {
            if let context {
                logger.debug("Did succeed: \(context)")
            }
            return
        }
        throw code.error(context: context)
    }
}

extension OSStatus {
    public enum Error: LocalizedError {
        /// ## Example
        ///
        /// ```swift
        /// // this OSStatus is thrown by CoreAudio when format isn't valid.
        /// // When converted to four char string: `"fmt?"`
        /// throw OSStatus(1718449215).error
        /// ```
        ///
        /// ## Example (inspection)
        ///
        /// ```
        /// (lldb) po error.localizedDescription
        /// context: "Initializing audioUnit", fourCharCode: "fmt?", osStatus: "1718449215 0x666D743F"
        /// ```
        /// ```
        /// (lldb) po error.debugDescription
        /// ▿ Error
        ///   ▿ fourCharCode : 3 elements
        ///     ▿ fourCharCode : fourCharCode: "fmt?", osStatus: "1718449215 0x666D743F"
        ///       - osStatus : 1718449215
        ///       ▿ bytes : 4 elements
        ///         - 0 : 102
        ///         - 1 : 109
        ///         - 2 : 116
        ///         - 3 : 63
        ///       ▿ characters : 4 elements
        ///         - 0 : "f"
        ///         - 1 : "m"
        ///         - 2 : "t"
        ///         - 3 : "?"
        ///       - string : "fmt?"
        ///     - osStatus : 1718449215
        ///     ▿ context : Optional<String>
        ///       - some : "Initializing audioUnit"
        /// ```
        case fourCharCode(
            fourCharCode: OSStatus.FourCharCode,
            osStatus: OSStatus,
            context: String?
        )
        
        /// A localized message describing what error occurred.
        /// - Note: This will be returned when `error.localizedDescription` is called.
        public var errorDescription: String? {
            switch self {
            case .fourCharCode(let fourCharCode, _, let context):
                if let context {
                    "context: \"\(context)\", \(fourCharCode.debugDescription)"
                } else {
                    "\(fourCharCode.debugDescription)"
                }
            }
        }
    }
    
    /// Converts self (`OSStatus`) to `OSStatus.FourCharCode` then uses that to return an `OSStatus.Error`
    ///
    /// - Parameter context: Additional context/message information to add when composing `Error`
    /// - Returns: An instance of `OSStatus.Error`.
    public func error(
        context: String? = nil
    ) -> any Swift.Error {
        let fourCharCode = FourCharCode(osStatus: self)
        return Error.fourCharCode(
            fourCharCode: fourCharCode,
            osStatus: self,
            context: context
        )
    }
    
    /// A convenience wrapper around `func error(contex:)` when there is no `context` to pass in.
    public var error: any Swift.Error {
        error()
    }
}

extension OSStatus {
    public struct FourCharCode: Sendable, CustomDebugStringConvertible {
        /// The original `OSStatus`
        public let osStatus: OSStatus
        
        /// The original `OSStatus` (`Int32`) converted to bytes
        public let bytes: [UInt8]
        
        /// The original `OSStatus` (`Int32`) converted to an array of characters
        public let characters: [Character]
        
        /// Joins `characters` into a `String`
        public let string: String
        
        public init(
            osStatus: OSStatus
        ) {
            self.osStatus = osStatus
            
            #warning("TODO: zakkhoyt - Handle negative numbers differently")
            #warning("TODO: zakkhoyt - DRY (String+FourCharCode.swift")
            
            var unsignedStatus = UInt32(bitPattern: osStatus)
            self.bytes = withUnsafePointer(to: &unsignedStatus) {
                let count = MemoryLayout<UInt32>.size / MemoryLayout<UInt8>.size
                let bytePtr = $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                    UnsafeBufferPointer(start: $0, count: count)
                }
                return [UInt8](bytePtr).reversed()
            }
            
            self.characters = bytes.compactMap {
                guard let scalar = Unicode.Scalar(UInt32($0)) else { return nil }
                return Character(scalar)
            }
            
            self.string = characters.map { String($0) }.joined()
        }
        
        public var debugDescription: String {
            [
                "osStatus": "\(osStatus) \(osStatus.hexString)",
                "fourCharCode": string
            ].varDescription
        }
    }
}
