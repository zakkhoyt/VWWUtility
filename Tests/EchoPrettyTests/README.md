# EchoPretty Snapshot Tests

This directory contains comprehensive snapshot tests for the `echo_pretty` command-line tool. These tests are designed to ensure that any refactoring (particularly the planned migration to SwiftArgumentParser) does not alter the tool's behavior.

## Overview

The snapshot tests capture the stdout and stderr output of `echo_pretty` commands and compare them against reference snapshots. This ensures that:

1. **Output remains consistent** - All ANSI escape sequences are generated correctly
2. **Flags work as expected** - Color, font, and cursor positioning flags produce the same results
3. **Edge cases are handled** - Complex scenarios and combinations continue to work
4. **Stderr/stdout separation is correct** - Flags like `--show-zsh` correctly output to stderr

## Test Coverage

The test suite covers the following categories:

### Basic Colors
- **Foreground colors**: red, green, blue, yellow, cyan, magenta, white, black, orange
- **Background colors**: RED, GREEN, BLUE, YELLOW, CYAN, MAGENTA, WHITE, BLACK, ORANGE
- **Bright variants**: bright-red, bright-green, etc. (foreground and background)

### Font Modifiers
- bold, italic, underline, double-underline
- faint, blink, blink-fast
- invert, hide, strikeout

### Advanced Colors
- **8-bit colors**: `--8-bit <0-255>` for foreground, `--8-BIT <0-255>` for background
- **24-bit RGB colors**: `--24-bit <r> <g> <b>` for foreground, `--24-BIT <r> <g> <b>` for background

### Cursor Positioning
- Movement: `--up`, `--down`, `--left`, `--right`
- Visibility: `--cursor-hide`, `--cursor-show`

### Screen Control
- `--clear-screen` - Clear the terminal screen
- `--erase-line` - Erase the current line

### Output Format Flags
- `--show-zsh` - Output zsh-formatted code to stderr
- `--show-bash` - Output bash-formatted code to stderr
- `--show-swift` - Output Swift-formatted code to stderr
- `--show` - Output all formats to stderr

### Help and Demos
- `--help` - Display help message
- `--version` - Display version
- `--demo` - Comparison demo
- `--demo-basics` - Basic ANSI code literals
- `--demo-8-bit` - 8-bit color demo
- `--demo-24-bit` - 24-bit color demo
- `--demo-web-colors` - Web colors demo

### Echo Compatibility
- `-n` - Disable trailing newline
- `-E` - Disable escape character sequences

### Edge Cases
- Empty strings
- Long text content
- Special characters
- Multiple color transitions
- Complex status messages
- Real-world use cases from issue history

## Requirements

- **Platform**: macOS 14.0 or later
- **Why macOS?**: The project uses platform-specific dependencies:
  - `DrawingUI` package from VWWUtility (macOS framework)
  - `os` module for logging (macOS/iOS only)
  - AppKit dependencies in echo_pretty source
- **Build**: The `echo_pretty` executable must be built before running tests
- **Dependencies**: SnapshotTesting framework (automatically managed by SPM)

## Running the Tests

### Initial Setup

1. **Build the project first**:
   ```bash
   swift build
   ```

2. **Run all tests**:
   ```bash
   swift test
   ```

3. **Run only EchoPretty tests**:
   ```bash
   swift test --filter EchoPrettyTests
   ```

### First-Time Setup (Recording Snapshots)

The first time you run the tests, they will **fail** because no reference snapshots exist. This is expected behavior. The test framework will:

1. Run all commands
2. Capture the output
3. Save it as reference snapshots in `Tests/EchoPrettyTests/__Snapshots__/`
4. Fail the test with a message about recording snapshots

After the first run:

1. **Review the generated snapshots** in the `__Snapshots__` directory
2. **Verify the output is correct** by examining the snapshot files
3. **Commit the snapshot files** to version control
4. **Re-run the tests** - they should now pass

### Updating Snapshots

If you intentionally change `echo_pretty`'s behavior:

1. Delete the old snapshots:
   ```bash
   rm -rf Tests/EchoPrettyTests/__Snapshots__/
   ```

2. Re-run the tests to generate new snapshots:
   ```bash
   swift test --filter EchoPrettyTests
   ```

3. Review and commit the new snapshots

### Debugging Test Failures

If a test fails after refactoring:

1. **Check the diff** - The test output will show what changed
2. **Examine the snapshot files** - Compare `.1.txt` (expected) with `.2.txt` (actual)
3. **Determine if the change is intentional**:
   - If yes, update the snapshots (see above)
   - If no, fix the regression in the code

## Test Structure

Each test follows this pattern:

```swift
func testSomething() {
    let args = ["--red", "text", "--default"]
    let result = runEchoPretty(arguments: args)
    
    assertSnapshot(
        matching: result.stdout,
        as: .lines,
        named: "descriptive_name"
    )
}
```

### Helper Methods

- `runEchoPretty(arguments:)` - Executes echo_pretty with given args, returns (stdout, stderr, exitCode)
- `snapshotName(for:)` - Generates a valid snapshot name from command arguments

## Continuous Integration

These tests should be run:

1. **Before merging any PR** that changes echo_pretty
2. **After the SwiftArgumentParser refactor** to ensure no regressions
3. **Regularly** as part of CI/CD to catch any unintended changes

## Notes

- Snapshot files are stored in `__Snapshots__/EchoPrettySnapshotTests/`
- Each snapshot is a text file containing the exact output
- ANSI escape codes are preserved in the snapshots
- The tests verify both stdout and stderr where applicable
- Exit codes are also tested for commands like `--help` and `--version`

## Troubleshooting

### "Could not find echo_pretty executable"

**Solution**: Build the project first:
```bash
swift build
```

### Tests fail with "No reference was found"

**Solution**: This is expected on first run. The snapshots will be recorded automatically. Review them and re-run the tests.

### Tests fail after refactoring

**Solution**: 
1. Check if the change is intentional
2. If yes, update snapshots: `rm -rf Tests/EchoPrettyTests/__Snapshots__/ && swift test --filter EchoPrettyTests`
3. If no, fix the code to match the original behavior

### Cannot run on Linux

**Solution**: This project requires macOS due to platform-specific dependencies. Run tests on macOS or in a macOS CI environment.

## Contributing

When adding new features to echo_pretty:

1. Add corresponding snapshot tests
2. Follow the existing test naming conventions
3. Group related tests together
4. Document any special test requirements
5. Ensure tests pass before submitting PR

## References

- [SnapshotTesting Documentation](https://github.com/pointfreeco/swift-snapshot-testing)
- [echo_pretty Source](../../Sources/EchoPretty/main.swift)
- [SwiftArgumentParser](https://github.com/apple/swift-argument-parser)
