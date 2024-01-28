import ArgumentParser
import Foundation
import Nodes

struct App: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "Nodes terminal app.",
            abstract: "An app to test nodes",
            discussion: "Scalar, buffer, input, output, wiring."
        )
    }

    func run() throws {
//        Task {
//            let helper = SynthHelper()
//            await helper.play(for: 1)
//        }
        print("nodes.run")
    }
}

App.main()

// This keeps the script open so our async events can run
RunLoop.main.run()

// struct SynthHelper{
//    private let synth = WaveSynthesizer()
//
//    init() {
//
//    }
//
//
//    func play(
//        for duration: TimeInterval
//    ) async {
//        synth.start()
//        return await withCheckedContinuation { continuation in
//            DispatchQueue.global().asyncAfter(
//                deadline: .now() + duration
//            ) {
//                DispatchQueue.global().asyncAfter(
//                    deadline: .now()
//                ) {
//                    synth.stop()
//                    continuation.resume(returning: ())
//                }
//            }
//        }
//    }
// }
