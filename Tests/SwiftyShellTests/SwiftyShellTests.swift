@testable import SwiftyShell
import XCTest

final class SwiftyShellTests: XCTestCase {
    // MARK: - Basic Success Tests
    
    func testShellSuccess() async throws {
        let stdout: String? = await ZShell.run("date -Iseconds")
        let timeStamp: String = try XCTUnwrap(stdout)
        
        // Should return timestamp. EX: "2024-06-14T14:37:18-06:00"
        XCTAssertTrue(timeStamp.prefix(2) == "20")
        XCTAssertTrue(timeStamp.contains("T"), "Expected stdout to contain 'T'. Actual: \(timeStamp)")
        XCTAssertTrue(timeStamp.split(separator: "T").count == 2, "Expected stdout to contain 1 'T'. Actual: \(timeStamp)")
        XCTAssertTrue(timeStamp.split(separator: "-").count == 4, "Expected stdout to contain 3 '-'. Actual: \(timeStamp)")
        XCTAssertTrue(timeStamp.split(separator: ":").count == 4, "Expected stdout to contain 3 ':'. Actual: \(timeStamp)")
    }
    
    func testShellEcho() async throws {
        let result = await ZShell.execute("echo Hello World")
        XCTAssertEqual(result.stdout, "Hello World\n")
        XCTAssertNil(result.stderr)
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    func testShellPwd() async throws {
        let result = await ZShell.execute("pwd")
        XCTAssertNotNil(result.stdout)
        XCTAssertFalse(result.stdout?.isEmpty ?? true)
        XCTAssertNil(result.stderr)
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    // MARK: - Exit Code Tests
    
    func testShellExitCodeSuccess() async throws {
        let result = await ZShell.execute("true")
        XCTAssertEqual(result.terminationStatus, 0, "true command should return exit code 0")
    }
    
    func testShellExitCodeFailure() async throws {
        let result = await ZShell.execute("false")
        XCTAssertNotEqual(result.terminationStatus, 0, "false command should return non-zero exit code")
        XCTAssertEqual(result.terminationStatus, 1, "false command should return exit code 1")
    }
    
    //    func testShellExitCodeCustom() async throws {
    //        let result = await ZShell.execute("exit 42")
    //        XCTAssertEqual(result.terminationStatus, 42, "exit 42 command should return exit code 42")
    //    }
    
    // MARK: - Stderr Tests
    
    func testShellStderr() async throws {
        // Using a command that writes to stderr
        let result = await ZShell.execute("ls /nonexistent_directory_12345")
        XCTAssertNotNil(result.stderr)
        XCTAssertFalse(result.stderr?.isEmpty ?? true, "stderr should contain error message")
        XCTAssertNotEqual(result.terminationStatus, 0, "Command should fail with non-zero exit code")
    }
    
    // MARK: - Multiple Argument Tests
    
    func testShellMultipleArguments() async throws {
        let result = await ZShell.execute("echo -n test")
        XCTAssertEqual(result.stdout, "test", "echo -n should not add newline")
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    func testShellListFiles() async throws {
        // Create a temp file and list it
        let tempDir = FileManager.default.temporaryDirectory
        let testFile = tempDir.appendingPathComponent("test_shell_\(UUID().uuidString).txt")
        try "test content".write(to: testFile, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: testFile)
        }
        print("testFile: \(testFile)")
        let result = await ZShell.execute("ls \(testFile.path)")
        XCTAssertEqual(result.stdout, "\(testFile.path)\n")
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    // MARK: - String Argument Parsing Tests
    
    func testShellArgumentParsing() async throws {
        // Test that arguments are properly split
        let result = await ZShell.execute("printf %s Hello")
        XCTAssertEqual(result.stdout, "Hello")
        XCTAssertEqual(result.terminationStatus, 0)
    }
    
    // MARK: - Process Command API Tests
    
    func testProcessCommandAPI() async throws {
        let command = Shell.Command(arguments: "echo test")
        let response = try await ZShell.process(command: command)
        
        XCTAssertEqual(response.stdout, "test\n")
        XCTAssertNil(response.stderr)
        XCTAssertEqual(response.process.terminationStatus, 0)
    }
    
    func testProcessCommandWithArray() async throws {
        let command = Shell.Command(arguments: ["echo", "multiple", "words"])
        let response = try await ZShell.process(command: command)
        
        XCTAssertEqual(response.stdout, "multiple words\n")
        XCTAssertEqual(response.process.terminationStatus, 0)
    }
    
    func testProcessCommandError() async throws {
        let command = Shell.Command(arguments: "false")
        
        do {
            _ = try await ZShell.process(command: command)
            XCTFail("Should throw error for failed command")
        } catch let error as Shell.Error {
            XCTAssertEqual(error.response.process.terminationStatus, 1)
            XCTAssertEqual(error.command.instruction, "false")
        } catch {
            XCTFail("Should throw Shell.Error, got: \(error)")
        }
    }
    
    // MARK: - Command Chaining Tests
    
    func testMultipleCommands() async throws {
        let commands = [
            Shell.Command(arguments: "echo first"),
            Shell.Command(arguments: "echo second")
        ]
        
        var responses: [Shell.Response] = []
        try await ZShell.process(commands: commands) { response in
            responses.append(response)
        }
        
        XCTAssertEqual(responses.count, 2)
        XCTAssertEqual(responses[0].stdout, "first\n")
        XCTAssertEqual(responses[1].stdout, "second\n")
    }
    
    func testEmptyCommandList() async throws {
        let commands: [Shell.Command] = []
        
        do {
            _ = try await ZShell.process(commands: commands)
            XCTFail("Should throw error for empty command list")
        } catch {
            // Expected error
            XCTAssertTrue(error.localizedDescription.contains("empty"))
        }
    }
}
