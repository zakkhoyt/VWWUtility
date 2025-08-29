//
//  Logger.swift
//
//  Created by Zakk Hoyt on 12/2/23.
//

import os.log

let logger = Logger(
    subsystem: "com.z2k",
    category: "CaptureVideoPreviewView"
)

extension os.Logger {
    /// Composes the function arguments into a useful string for logging the location of a line of code.
    ///
    /// - Parameters:
    ///   - file: Example: `$SRCROOT/Package/Sources/Package/BLE/Scanner/BLEScanner.swift`
    ///   - fileID: Example: `Package/BLEScanner.swift`
    ///   - filePath: Example: `$SRCROOT/Package/Sources/Package/BLE/Scanner/BLEScanner.swift`
    ///   - function: Example: `disconnect(from:)`
    ///   - line: Example: `377`
    /// - Returns: Returns a String with formatted file, line, function.
    func codeLocation(
        fileID: StaticString = #fileID,
        function: StaticString = #function,
        line: UInt = #line
    ) -> String {
        "[\(fileID):\(line)] \(function) > "
    }
}
