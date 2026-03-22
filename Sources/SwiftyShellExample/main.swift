//
//  main.swift
//  SwiftyShellExample
//
//  Demonstrates how to use SwiftyShell independently
//

#if os(macOS)

import Foundation
import SwiftyShell

//@main
struct SwiftyShellExample {
    static func main() async {
        print("=== SwiftyShell Example ===\n")
        
        // Example 1: Simple command execution
        print("1. Getting current date:")
        if let date: String = await ZShell.run("date") {
            print("   \(date)\n")
        }
        
        // Example 2: Get stdout, stderr, and exit code
        print("2. Executing 'pwd' command:")
        let pwdResult = await ZShell.execute("pwd")
        print("   stdout: \(pwdResult.stdout ?? "none")")
        print("   stderr: \(pwdResult.stderr ?? "none")")
        print("   exit code: \(pwdResult.terminationStatus)\n")
        
        // Example 3: Command that produces stderr
        print("3. Attempting to list non-existent directory:")
        let lsResult = await ZShell.execute("ls /nonexistent_directory_12345")
        print("   stdout: \(lsResult.stdout ?? "none")")
        print("   stderr: \(lsResult.stderr ?? "none")")
        print("   exit code: \(lsResult.terminationStatus)\n")
        
        // Example 4: Using the full Command API
        print("4. Using Shell.Command API:")
        let command = Shell.Command(arguments: "echo Hello from SwiftyShell!")
        do {
            let response = try await ZShell.process(command: command)
            print("   Output: \(response.stdout ?? "none")")
            print("   Exit code: \(response.process.terminationStatus)\n")
        } catch {
            print("   Error: \(error.localizedDescription)\n")
        }
        
        // Example 5: Check exit codes
        print("5. Testing exit codes:")
        let trueResult = await ZShell.execute("true")
        print("   'true' exit code: \(trueResult.terminationStatus)")
        let falseResult = await ZShell.execute("false")
        print("   'false' exit code: \(falseResult.terminationStatus)\n")
        
        // Example 6: Multiple commands
        print("6. Running multiple commands:")
        let commands = [
            Shell.Command(arguments: "echo First command"),
            Shell.Command(arguments: "echo Second command")
        ]
        
        do {
            var index = 1
            try await ZShell.process(commands: commands) { response in
                print("   Command \(index): \(response.stdout ?? "none")")
                index += 1
            }
        } catch {
            print("   Error: \(error.localizedDescription)")
        }
        
        print("\n=== Example Complete ===")

        exit(0)
    }
}

Task {
    await SwiftyShellExample.main()
}

// This keeps the script open so our async events can run
RunLoop.main.run()


#endif
