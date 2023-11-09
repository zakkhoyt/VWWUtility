import XCTest
import WaveSynthesizer

final class MathTransformNodeTests: XCTestCase {
    func testInputOutput() throws {
        let node = MathTransformNode()
        let range = 1...20
        
        for mode in MathTransformNode.Mode.allCases {
            node.mode = mode
            XCTAssert(node.mode == mode)
            
            for aa in range {
                // Cast Int to Double
                let a = Double(aa)
                
                print("---- input: \(a)")
                
                // Set node input(s) & validate
                node.input.value = a
                XCTAssert(node.input.value == a)
                
                // Update node output(s) & validate
                node.process()
                let actual = node.output.value
                let (expected, message) = {
                    switch node.mode {
                    case .log:
                        let expected = log(node.input.value)
                        return (
                            expected,
                            "Expect log(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .log2:
                        let expected = log2(node.input.value)
                        return (
                            expected,
                            "Expect log2(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .log10:
                        let expected = log10(node.input.value)
                        return (
                            expected,
                            "Expect log10(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .absolute:
                        let expected = abs(node.input.value)
                        return (
                            expected,
                            "Expect abs(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .sqrt:
                        let expected = sqrt(node.input.value)
                        return (
                            expected,
                            "Expect sqrt(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .ceil:
                        let expected = ceil(node.input.value)
                        return (
                            expected,
                            "Expect ceil(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .floor:
                        let expected = floor(node.input.value)
                        return (
                            expected,
                            "Expect floor(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    case .round:
                        let expected = round(node.input.value)
                        return (
                            expected,
                            "Expect round(\(node.input.value)) (\(expected)) == \(actual)"
                        )
                    }
                }()
                print(message)
                XCTAssertEqual(expected, actual, message)
            }
        }
    }
}
