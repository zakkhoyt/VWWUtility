import XCTest
import Nodes

final class ScalarNodeTests: XCTestCase {
    private let node = ScalarGeneratorNode()
    
    func testInputOutput() throws {
        let range = 1..<20
        for i in range {
            node.generated.value = Double(i)
            XCTAssert(node.generated.value == Double(i))
            
            node.process()
            
            
            let expected = sin(node.generated.value)
            let actual = node.amplitude.value
            print("--- \(i) -------------------------------------")
            print("\tExpect \(expected) == \(actual)")
            
            XCTAssertEqual(
                sin(node.generated.value),
                node.amplitude.value,
                "Loop \(i).\nExpected input: sin(\(node.generated.value)) (\(sin(node.generated.value))\nto match output \(node.amplitude.value)"
            )
            print("Round \(i) complete")
        }
    }
}

fileprivate class ScalarGeneratorNode: Node {
    var generated = ScalarInput(
        name: "Generated",
        minValue: 0.0,
        maxValue: 100.0,
        value: Double(10),
        stride: 0.1
    )
    
    var amplitude = ScalarOutput(
        name: "Amplitude",
        minValue: -1.0,
        maxValue: 1.0,
        value: Double(0),
        stride: nil
    )
    
    let name: String
    var isEnabled: Bool
    var inputs: [any InputRepresentable] = []
    var outputs: [any OutputRepresentable] = []
    
    
    init() {
        self.name = "Start Node (freq generator)"
        self.isEnabled = true
        self.inputs = [
            generated
        ]
        self.outputs = [
            amplitude
        ]
    }
    
    func process() {
        generated.value = Double(generated.value)
        amplitude.value = sin(generated.value)
    }
}

