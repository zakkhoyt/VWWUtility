import XCTest
import WaveSynthesizer

final class MathNodeTests: XCTestCase {
    func testInputOutput() throws {
        let node = MathNode()
        let range = 1...20

        for mode in MathNode.Mode.allCases {
            node.mode = mode
            XCTAssert(node.mode == mode)
            
            for aa in range {
                for bb in range {
                    // Cast Int to Double
                    let a = Double(aa)
                    let b = Double(bb)
                    
                    print("---- inputA: \(a) inputB: \(b)")
                    
                    // Set node input(s) & validate
                    node.inputA.value = a
                    XCTAssert(node.inputA.value == a)
                    node.inputB.value = b
                    XCTAssert(node.inputB.value == b)
                    
                    // Update node output(s) & validate
                    node.process()
                    let actual = node.output.value
                    let (expected, message) = {
                        switch node.mode {
                        case .add:
                            let expected = a + b
                            return (
                                expected,
                                "\tExpect \(a) + \(b) (\(expected)) == \(actual)"
                            )
                        case .subtract:
                            let expected = a - b
                            return (
                                expected,
                                "\tExpect \(a) - \(b) (\(expected)) == \(actual)"
                            )
                        case .multiply:
                            let expected = a * b
                            return (
                                expected,
                                "\tExpect \(a) * \(b) (\(expected)) == \(actual)"
                            )
                        case .divide:
                            let expected = a / b
                            return (
                                expected,
                                "\tExpect \(a) / \(b) (\(expected)) == \(actual)"
                            )
                        case .power:
                            let expected = pow(a, b)
                            return (
                                expected,
                                "\tExpect pow(\(a), \(b)) (\(expected)) == \(actual)"
                            )
                        }
                    }()
                    print(message)
                    XCTAssertEqual(expected, actual, message)
                }
            }
        }
        
    }
}


