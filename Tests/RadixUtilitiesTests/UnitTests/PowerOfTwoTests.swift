//
//  PowerOfTwoTests.swift
//
//  Created by Zakk Hoyt on 2024-12-04.
//  Copyright hatch.co, 2024.
//

import Foundation
@testable import HatchRadixUtilities
import XCTest

class PowerOfTwoTests: XCTestCase {
    func testBinaryIntegerIsPowerOfTwo() {
        if #available(iOS 18.0, *) {
            let exponents = [UInt128](0..<128)
            let powersOfTwo = exponents.map { UInt128(pow(2, Double($0))) }
            let notPowersOfTwo = powersOfTwo.map {
                /// 0, 1, 2 are too crowded. Transpose them (arbitrarily) into 157...160 which are all !powerOfTwo
                if $0 < 4 {
                    $0 + 160 - $0
                } else {
                    $0 - 1
                }
            }
            
            powersOfTwo.forEach {
                let actual = $0.isPowerOfTwo
                XCTAssertTrue(actual, "expected \($0).isPowerOfTwo == true. Actual: \(actual)")
            }
            
            notPowersOfTwo.forEach {
                let actual = $0.isPowerOfTwo
                XCTAssertFalse(actual, "expected \($0).isPowerOfTwo == false. Actual: \(actual)")
            }
        } else {
            let exponents = [UInt64](0..<64)
            let powersOfTwo = exponents.map { UInt64(pow(2, Double($0))) }
            let notPowersOfTwo = powersOfTwo.map {
                /// 0, 1, 2 are too crowded. Transpose them (arbitrarily) into 157...160 which are all !powerOfTwo
                if $0 < 4 {
                    $0 + 160 - $0
                } else {
                    $0 - 1
                }
            }
            
            powersOfTwo.forEach {
                let actual = $0.isPowerOfTwo
                XCTAssertTrue(actual, "expected \($0).isPowerOfTwo == true. Actual: \(actual)")
            }
            
            notPowersOfTwo.forEach {
                let actual = $0.isPowerOfTwo
                XCTAssertFalse(actual, "expected \($0).isPowerOfTwo == false. Actual: \(actual)")
            }
        }
    }
}
