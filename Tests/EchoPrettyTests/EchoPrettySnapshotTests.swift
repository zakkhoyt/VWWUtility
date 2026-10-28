import XCTest
import SnapshotTesting
import Foundation

/// Comprehensive snapshot tests for echo_pretty to ensure no regressions during refactoring.
///
/// These tests capture the stdout and stderr output of various echo_pretty commands
/// to ensure the behavior remains consistent after the SwiftArgumentParser refactor.
final class EchoPrettySnapshotTests: XCTestCase {
    
    // MARK: - Setup
    
    /// Path to the echo_pretty executable
    var echoPrettyPath: String = ""
    
    override func setUp() {
        super.setUp()
        
        // Determine the path to the echo_pretty executable
        // In development: .build/debug/echo_pretty or .build/release/echo_pretty
        // In CI/CD: Ensure the executable is built first (see SNAPSHOT_TESTING_GUIDE.md)
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        
        // Try various possible paths
        let possiblePaths = [
            "\(currentPath)/.build/debug/echo_pretty",
            "\(currentPath)/.build/release/echo_pretty",
            "\(currentPath)/echo_pretty"
        ]
        
        for path in possiblePaths {
            if fileManager.fileExists(atPath: path) {
                echoPrettyPath = path
                break
            }
        }
        
        XCTAssertFalse(echoPrettyPath.isEmpty, "Could not find echo_pretty executable. Please build the project first.")
    }
    
    // MARK: - Helper Methods
    
    /// Runs echo_pretty with the given arguments and returns stdout and stderr
    func runEchoPretty(arguments: [String]) -> (stdout: String, stderr: String, exitCode: Int32) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: echoPrettyPath)
        process.arguments = arguments
        
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe
        
        // Read pipes asynchronously to avoid deadlock when buffers fill up
        var stdoutData = Data()
        var stderrData = Data()
        
        let stdoutHandle = stdoutPipe.fileHandleForReading
        let stderrHandle = stderrPipe.fileHandleForReading
        
        let group = DispatchGroup()
        
        // Read stdout on background queue
        group.enter()
        DispatchQueue.global().async {
            stdoutData = stdoutHandle.readDataToEndOfFile()
            group.leave()
        }
        
        // Read stderr on background queue
        group.enter()
        DispatchQueue.global().async {
            stderrData = stderrHandle.readDataToEndOfFile()
            group.leave()
        }
        
        do {
            try process.run()
            process.waitUntilExit()
            
            // Wait for all pipe reading to complete
            group.wait()
            
            let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
            let stderr = String(data: stderrData, encoding: .utf8) ?? ""
            
            return (stdout, stderr, process.terminationStatus)
        } catch {
            XCTFail("Failed to run echo_pretty: \(error)")
            return ("", "", -1)
        }
    }
    
    /// Creates a snapshot name from test arguments.
    /// This helper is available for generating snapshot names dynamically if needed,
    /// though most tests use explicit named snapshots for clarity.
    func snapshotName(for args: [String]) -> String {
        return args.joined(separator: "_")
            .replacingOccurrences(of: "--", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "'", with: "")
            .prefix(100)
            .description
    }
    
    // MARK: - Basic Color Tests
    
    func testBasicForegroundColors() {
        let colors = [
            "red", "green", "blue", "yellow", "cyan", "magenta",
            "white", "black"
        ]
        
        for color in colors {
            let args = ["-\(color)", "\(color) text", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "foreground_\(color)"
            )
        }
        
        // Orange is a special case with double dash
        let orangeArgs = ["--orange", "orange text", "--default"]
        let orangeResult = runEchoPretty(arguments: orangeArgs)
        assertSnapshot(
            of: orangeResult.stdout,
            as: .lines,
            named: "foreground_orange"
        )
    }
    
    func testBasicBackgroundColors() {
        let colors = [
            "RED", "GREEN", "BLUE", "YELLOW", "CYAN", "MAGENTA",
            "WHITE", "BLACK"
        ]
        
        for color in colors {
            let args = ["-\(color)", "\(color) background", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "background_\(color)"
            )
        }
        
        // ORANGE is a special case with double dash
        let orangeArgs = ["--ORANGE", "ORANGE background", "--default"]
        let orangeResult = runEchoPretty(arguments: orangeArgs)
        assertSnapshot(
            of: orangeResult.stdout,
            as: .lines,
            named: "background_ORANGE"
        )
    }
    
    func testBrightForegroundColors() {
        let colors = [
            "red", "green", "blue", "yellow",
            "cyan", "magenta", "white", "black"
        ]
        
        for color in colors {
            // Bright colors use double dash (--red instead of -red)
            let args = ["--\(color)", "\(color) text", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "bright_bright_\(color)"
            )
        }
    }
    
    func testBrightBackgroundColors() {
        let colors = [
            "RED", "GREEN", "BLUE", "YELLOW",
            "CYAN", "MAGENTA", "WHITE", "BLACK"
        ]
        
        for color in colors {
            // Bright background colors use double dash (--RED instead of -RED)
            let args = ["--\(color)", "\(color) background", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "bright_bg_BRIGHT_\(color)"
            )
        }
    }
    
    // MARK: - Font Modifier Tests
    
    func testFontModifiers() {
        let modifiers = [
            ("bold", "BOLD text"),
            ("italic", "ITALIC text"),
            ("underline", "UNDERLINE text"),
            ("double-underline", "DOUBLE UNDERLINE text"),
            ("faint", "FAINT text"),
            ("blink", "BLINK text"),
            ("blinkFast", "BLINK FAST text"),
            ("invert", "INVERT text"),
            ("hide", "HIDE text"),
            ("strikeout", "STRIKEOUT text")
        ]
        
        for (modifier, text) in modifiers {
            let args = ["--\(modifier)", text, "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "font_\(modifier.replacingOccurrences(of: "-", with: "_"))"
            )
        }
    }
    
    // MARK: - Combined Color and Font Tests
    
    func testCombinedColorAndFont() {
        let combinations = [
            (["-red", "--bold", "RED BOLD", "--default"], "red_bold"),
            (["-green", "--italic", "GREEN ITALIC", "--default"], "green_italic"),
            (["-blue", "--underline", "BLUE UNDERLINE", "--default"], "blue_underline"),
            (["-yellow", "--bold", "--underline", "YELLOW BOLD UNDERLINE", "--default"], "yellow_bold_underline"),
            (["-CYAN", "--bold", "CYAN BG BOLD", "--default"], "cyan_bg_bold"),
        ]
        
        for (args, name) in combinations {
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "combined_\(name)"
            )
        }
    }
    
    // MARK: - Complex Text Sequences
    
    func testMultipleColorTransitions() {
        let args = [
            "-red", "R",
            "--default", "-green", "G",
            "--default", "-blue", "B",
            "--default", "cape",
            "--left", "4", "head"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "multiple_color_transitions"
        )
    }
    
    func testColoredFlagText() {
        let args = ["-red", "--red", "--default"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "colored_flag_text"
        )
    }
    
    func testComplexStatusMessage() {
        let args = [
            "-red", "[FAILED]",
            "--default", ": \"status\": \"404\" ",
            "-red", "[1]",
            "--default"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "complex_status_message"
        )
    }
    
    func testMixedColoredText() {
        let args = [
            "-red", "red text",
            "--default", " ",
            "-green", "green text",
            "--default", " default text"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "mixed_colored_text"
        )
    }
    
    // MARK: - Cursor Positioning Tests
    
    func testCursorMovement() {
        let movements = [
            (["--up", "3", "text"], "cursor_up_3"),
            (["--down", "2", "text"], "cursor_down_2"),
            (["--left", "4", "text"], "cursor_left_4"),
            (["--right", "5", "text"], "cursor_right_5")
        ]
        
        for (args, name) in movements {
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: name
            )
        }
    }
    
    func testCursorVisibility() {
        let tests = [
            (["--cursor-hide", "hidden cursor text"], "cursor_hide"),
            (["--cursor-show", "visible cursor text"], "cursor_show")
        ]
        
        for (args, name) in tests {
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: name
            )
        }
    }
    
    // MARK: - 8-bit Color Tests
    
    func test8BitColors() {
        let testValues = [0, 16, 128, 196, 231, 255]
        
        for value in testValues {
            let args = ["--8-bit", "\(value)", "8-bit color \(value)", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "8bit_fg_\(value)"
            )
        }
    }
    
    func test8BitBackgroundColors() {
        let testValues = [0, 16, 128, 196, 231, 255]
        
        for value in testValues {
            let args = ["--8-BIT", "\(value)", "8-bit background \(value)", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "8bit_bg_\(value)"
            )
        }
    }
    
    // MARK: - 24-bit RGB Color Tests
    
    func test24BitColors() {
        let rgbValues = [
            (255, 0, 0, "red"),
            (0, 255, 0, "green"),
            (0, 0, 255, "blue"),
            (255, 255, 0, "yellow"),
            (255, 0, 255, "magenta"),
            (0, 255, 255, "cyan"),
            (128, 128, 128, "gray")
        ]
        
        for (r, g, b, name) in rgbValues {
            let args = ["--24-bit", "\(r)", "\(g)", "\(b)", "RGB(\(r),\(g),\(b))", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "24bit_fg_\(name)"
            )
        }
    }
    
    func test24BitBackgroundColors() {
        let rgbValues = [
            (255, 0, 0, "red"),
            (0, 255, 0, "green"),
            (0, 0, 255, "blue")
        ]
        
        for (r, g, b, name) in rgbValues {
            let args = ["--24-BIT", "\(r)", "\(g)", "\(b)", "RGB BG(\(r),\(g),\(b))", "--default"]
            let result = runEchoPretty(arguments: args)
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "24bit_bg_\(name)"
            )
        }
    }
    
    // MARK: - Show Flags Tests (stderr output)
    
    func testShowZshFlag() {
        let testCases = [
            (["-red", "red text", "--default", "--show-zsh"], "red_text"),
            (["-green", "green text", "--default", "--show-zsh"], "green_text"),
            (["--bold", "BOLD", "--default", "--show-zsh"], "bold"),
            (["--underline", "UNDERLINE", "--default", "--show-zsh"], "underline")
        ]
        
        for (args, name) in testCases {
            let result = runEchoPretty(arguments: args)
            
            // The --show-zsh flag outputs to stderr
            assertSnapshot(
                of: result.stderr,
                as: .lines,
                named: "show_zsh_stderr_\(name)"
            )
            
            // stdout should still have the colored output
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "show_zsh_stdout_\(name)"
            )
        }
    }
    
    func testShowBashFlag() {
        let testCases = [
            (["-red", "red text", "--default", "--show-bash"], "red_text"),
            (["--bold", "BOLD", "--default", "--show-bash"], "bold")
        ]
        
        for (args, name) in testCases {
            let result = runEchoPretty(arguments: args)
            
            // The --show-bash flag outputs to stderr
            assertSnapshot(
                of: result.stderr,
                as: .lines,
                named: "show_bash_stderr_\(name)"
            )
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "show_bash_stdout_\(name)"
            )
        }
    }
    
    func testShowSwiftFlag() {
        let testCases = [
            (["-red", "red text", "--default", "--show-swift"], "red_text"),
            (["--bold", "BOLD", "--default", "--show-swift"], "bold")
        ]
        
        for (args, name) in testCases {
            let result = runEchoPretty(arguments: args)
            
            // The --show-swift flag outputs to stderr
            assertSnapshot(
                of: result.stderr,
                as: .lines,
                named: "show_swift_stderr_\(name)"
            )
            
            assertSnapshot(
                of: result.stdout,
                as: .lines,
                named: "show_swift_stdout_\(name)"
            )
        }
    }
    
    func testShowAllFormatsFlag() {
        let args = ["-red", "red text", "--default", "--show"]
        let result = runEchoPretty(arguments: args)
        
        // The --show flag outputs all formats to stderr
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "show_all_stderr"
        )
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "show_all_stdout"
        )
    }
    
    // MARK: - Help and Demo Tests
    
    func testHelpOutput() {
        let result = runEchoPretty(arguments: ["--help"])
        
        // Help output goes to stderr with exit code 1
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "help_output"
        )
        
        XCTAssertEqual(result.exitCode, 1, "Help should exit with code 1")
    }
    
    func testVersionOutput() {
        let result = runEchoPretty(arguments: ["--version"])
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "version_output"
        )
        
        XCTAssertEqual(result.exitCode, 0, "Version should exit with code 0")
    }
    
    func testDemoBasicsOutput() {
        let result = runEchoPretty(arguments: ["--demo-basics"])
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "demo_basics_output"
        )
        
        XCTAssertEqual(result.exitCode, 1, "Demo should exit with code 1")
    }
    
    func testDemoCompareOutput() {
        let result = runEchoPretty(arguments: ["--demo"])
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "demo_compare_output"
        )
        
        XCTAssertEqual(result.exitCode, 1, "Demo should exit with code 1")
    }
    
    func testDemo8BitOutput() {
        let result = runEchoPretty(arguments: ["--demo-8-bit"])
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "demo_8bit_output"
        )
        
        XCTAssertEqual(result.exitCode, 1, "Demo should exit with code 1")
    }
    
    func testDemo24BitOutput() {
        // Set a seed for deterministic random generation in the demo
        let process = Process()
        process.executableURL = URL(fileURLWithPath: echoPrettyPath)
        process.arguments = ["--demo-24-bit"]
        process.environment = ProcessInfo.processInfo.environment.merging(
            ["ECHO_PRETTY_TEST_SEED": "12345"],
            uniquingKeysWith: { _, new in new }
        )
        
        let stderrPipe = Pipe()
        process.standardError = stderrPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
            let stderr = String(data: stderrData, encoding: .utf8) ?? ""
            
            assertSnapshot(
                of: stderr,
                as: .lines,
                named: "demo_24bit_output"
            )
            
            XCTAssertEqual(process.terminationStatus, 1, "Demo should exit with code 1")
        } catch {
            XCTFail("Failed to run echo_pretty: \(error)")
        }
    }
    
    func testDemoWebColorsOutput() {
        let result = runEchoPretty(arguments: ["--demo-web-colors"])
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "demo_web_colors_output"
        )
        
        XCTAssertEqual(result.exitCode, 1, "Demo should exit with code 1")
    }
    
    // MARK: - Echo Compatibility Tests
    
    func testDisableTrailingNewline() {
        let args = ["-n", "no newline"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "no_trailing_newline"
        )
    }
    
    func testDisableEscapeCharacters() {
        let args = ["-E", "literal \\n text"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "disable_escape_chars"
        )
    }
    
    // MARK: - Screen and Line Control Tests
    
    func testClearScreen() {
        let args = ["--clearScreen", "text after clear"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "clear_screen"
        )
    }
    
    func testEraseLine() {
        let args = ["--eraseLine", "text on cleared line"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "erase_line"
        )
    }
    
    // MARK: - Edge Cases and Complex Scenarios
    
    func testEmptyString() {
        let args = [""]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "empty_string"
        )
    }
    
    func testOnlyDefaultFlag() {
        let args = ["--default"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "only_default_flag"
        )
    }
    
    func testMultipleDefaultFlags() {
        let args = ["-red", "red", "--default", "-green", "green", "--default", "--default"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "multiple_default_flags"
        )
    }
    
    func testMixedTextAndFlags() {
        let args = [
            "plain text",
            "-red", "red text",
            "--default",
            "more plain",
            "--bold", "bold text",
            "--default"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "mixed_text_and_flags"
        )
    }
    
    func testLongTextContent() {
        let longText = String(repeating: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ", count: 10)
        let args = ["-green", longText, "--default"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "long_text_content"
        )
    }
    
    func testSpecialCharacters() {
        let args = ["-yellow", "Special: !@#$%^&*()_+-={}[]|:;<>?,./~`", "--default"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "special_characters"
        )
    }
    
    func testEscapeSequences() {
        let args = ["Text with \\n newline and \\t tab"]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "escape_sequences"
        )
    }
    
    func testWithDebugFlag() {
        let args = ["-red", "text", "--default", "--debug"]
        let result = runEchoPretty(arguments: args)
        
        // Debug output goes to stderr. It echoes the binary's absolute path (argv[0]) and the
        // number of environment variables, both of which differ per machine/shell, so normalize
        // them before snapshotting.
        let stderr = result.stderr
            .replacingOccurrences(of: echoPrettyPath, with: "<echo_pretty_path>")
            .replacingOccurrences(
                of: #"ProcessInfo\.processInfo\.environment \(\d+\)"#,
                with: "ProcessInfo.processInfo.environment (<count>)",
                options: .regularExpression
            )
        assertSnapshot(
            of: stderr,
            as: .lines,
            named: "debug_stderr"
        )
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "debug_stdout"
        )
    }
    
    // MARK: - Real-World Use Cases from Issue History
    
    func testRealWorldExample1() {
        let args = [
            "-red", "R",
            "--default", "-green", "G",
            "--default", "-blue", "B",
            "--default", "cape",
            "--left", "4", "head",
            "--show-zsh"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "real_world_1_stdout"
        )
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "real_world_1_stderr"
        )
    }
    
    func testRealWorldExample2() {
        let args = [
            "-red", "[FAILED]",
            "--default", ": \"status\": \"404\" ",
            "-red", "[1]",
            "--default", "--show-zsh"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "real_world_2_stdout"
        )
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "real_world_2_stderr"
        )
    }
    
    func testRealWorldExample3() {
        let args = [
            "-red", "red text",
            "--default", " ",
            "-green", "green text",
            "--default", " default text",
            "--show-zsh"
        ]
        let result = runEchoPretty(arguments: args)
        
        assertSnapshot(
            of: result.stdout,
            as: .lines,
            named: "real_world_3_stdout"
        )
        
        assertSnapshot(
            of: result.stderr,
            as: .lines,
            named: "real_world_3_stderr"
        )
    }

    // MARK: - Hyperlink (OSC 8) Tests

    func testHyperlinkMarkdown() {
        let args = ["--link", "[the docs](https://example.com)"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_markdown_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkMarkdownWithTitleAttribute() {
        // The optional Markdown title attribute must be tolerated and discarded.
        let args = ["--link", "[docs](https://x.com \"hover title\")"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_markdown_title_attr_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkHtmlAnchor() {
        // Extra attributes (target, class, quote style) must be tolerated.
        let args = ["--link", "<a class='c' href=\"https://example.com\" target=\"_blank\">Example</a>"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_html_anchor_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkBareUrl() {
        // A bare URL uses the URL itself as the visible title.
        let args = ["--link", "https://example.com"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_bare_url_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkFileUrl() {
        let args = ["--link", "file:///tmp/report.txt"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_file_url_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkInlineEqualsSyntax() {
        let args = ["--link=[docs](https://x.com)"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_inline_equals_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkEmbeddedInText() {
        // A hyperlink is self-closing and must not leak into following arguments.
        let args = ["See ", "--link", "[the docs](https://example.com)", " for details.", "--default"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_embedded_in_text_stdout")
        XCTAssertEqual(result.exitCode, 0)
    }

    func testHyperlinkUnsupportedFallsBackToText() {
        // Unrecognized value: printed verbatim on stdout, warning on stderr, exit 0.
        let args = ["--link", "not a link"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_unsupported_stdout")
        assertSnapshot(of: result.stderr, as: .lines, named: "hyperlink_unsupported_stderr")
        XCTAssertEqual(result.exitCode, 0, "Unsupported --link value must not cause a non-zero exit")
    }

    func testHyperlinkShowZsh() {
        let args = ["--link", "[the docs](https://example.com)", "--show-zsh"]
        let result = runEchoPretty(arguments: args)

        assertSnapshot(of: result.stdout, as: .lines, named: "hyperlink_show_zsh_stdout")
        assertSnapshot(of: result.stderr, as: .lines, named: "hyperlink_show_zsh_stderr")
    }
}
