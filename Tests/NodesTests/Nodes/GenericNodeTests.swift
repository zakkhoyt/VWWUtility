import Nodes
import XCTest

final class GenericIOTests: XCTestCase {
    private let node = GeneratorNode()
    
    func testInputOutput() throws {
        let range = 1..<20
        for i in range {
            node.seed.value = Double(i)
            XCTAssert(node.seed.value == Double(i))
            
            node.process()
            
            let expected = sin(node.seed.value)
            let actual = node.amplitude.value
            print("--- \(i) -------------------------------------")
            print("\tExpect \(expected) == \(actual)")
            
            XCTAssertEqual(
                sin(node.seed.value),
                node.amplitude.value,
                "Loop \(i).\nExpected input: sin(\(node.seed.value)) (\(sin(node.seed.value))\nto match output \(node.amplitude.value)"
            )
            print("Round \(i) complete")
        }
    }
}

private class GeneratorNode: Node {
    var seed = Input(
        name: "Seed",
        value: 0.0
    )
    
    var amplitude = Output(
        name: "Amplitude",
        value: Double(0)
    )
    
    let name: String
    var isEnabled: Bool
    var inputs: [any InputRepresentable] = []
    var outputs: [any OutputRepresentable] = []
    
    init() {
        self.name = "Start Node (freq generator)"
        self.isEnabled = true
        self.inputs = [
            seed
        ]
        self.outputs = [
            amplitude
        ]
    }
    
    func process() {
        seed.value = Double(seed.value)
        amplitude.value = sin(seed.value)
    }
}
