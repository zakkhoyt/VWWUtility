//
//  IterateTests.swift
//  BaseUtilityTests
//
//  Created by Zakk Hoyt on 2/20/24.
//

import XCTest

final class IterateTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // num to iterate to on each nest level
    //private let v: UInt64 = 200
    private let v: UInt64 = 100
   
    //
    private var a: UInt64 = 0
    private var arr: [UInt64] = []
    
    override func setUp() {
        super.setUp()
        arr = [UInt64](repeating: 0, count: Int(pow(Float(v), Float(3))))
    }
    
    override func tearDown() {
        a = 0
        arr.removeAll(keepingCapacity: true)
    }
    
    func testForLoop() throws {
        // This is an example of a performance test case.
        measure {
            for z in 0..<v {
                for y in 0..<v {
                    for x in 0..<v {
                        mark(x: x, y: y, z: z)
                    }
                }
            }
            finish()
        }
    }
    
    func testEnumerateForLoop() throws {
        // This is an example of a performance test case.
        measure {
            for ez in (0..<v).enumerated() {
                let z = ez.element
                for ey in (0..<v).enumerated() {
                    let y = ey.element
                    for ex in (0..<v).enumerated() {
                        let x = ex.element
                        mark(x: x, y: y, z: z)
                    }
                }
            }
            finish()
        }
    }
    
    func testForEach() throws {
        // This is an example of a performance test case.
        measure {
            (0..<v).forEach { z in
                (0..<v).forEach { y in
                    (0..<v).forEach { x in
                        mark(x: x, y: y, z: z)
                    }
                }
            }
            finish()
        }
    }
    
    func testEnumerateForEach() throws {
        // This is an example of a performance test case.
        measure {
            (0..<v).enumerated().forEach { ez in
                (0..<v).enumerated().forEach { ey in
                    (0..<v).enumerated().forEach { ex in
                        mark(x: ex.element, y: ey.element, z: ez.element)
                    }
                }
            }
            finish()
        }
    }

    
    private func mark(x: UInt64, y: UInt64, z: UInt64) {
        let xx = x
        let yy = y * (v)
        let zz = z * (v * v)
        let i = xx + yy + zz
        arr[Int(i)] = i
        a += 1
    }
    
    private func finish() {
        print("a: \(a)")
        XCTAssertEqual(a, UInt64(pow(Float(v), Float(3))))
        a = 0
        
    }

}
