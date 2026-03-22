# SwiftyShell

SwiftyShell is a Swift library that provides a convenient interface for executing shell commands on macOS.

## Features

- Execute shell commands with a simple, Swift-friendly API
- Support for both synchronous and asynchronous execution
- Access to stdout, stderr, and exit codes
- Command chaining and piping
- Full Process control when needed

## Requirements

- macOS 14.0+
- Swift 5.10+

## Installation

### Swift Package Manager

Add SwiftyShell as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/hatch-mobile/HatchTerminal.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "SwiftyShell", package: "HatchTerminal")
    ]
)
```

## Usage

### Simple Command Execution

```swift
import SwiftyShell

// Execute a command and get stdout
let stdout = await ZShell.execute("ls -la")
print(stdout ?? "No output")

// Get full output including stderr and exit code
let result = await ZShell.execute("date -Iseconds")
print("stdout: \(result.stdout ?? "none")")
print("stderr: \(result.stderr ?? "none")")
print("exit code: \(result.terminationStatus)")
```

### Advanced Command Execution

```swift
import SwiftyShell

// Using the full Command API
let command = Shell.Command(arguments: "echo Hello World")
do {
    let response = try await ZShell.process(command: command)
    print("Output: \(response.stdout ?? "none")")
    print("Exit code: \(response.process.terminationStatus)")
} catch let error as Shell.Error {
    print("Error: \(error.localizedDescription)")
    print("stderr: \(error.response.stderr ?? "none")")
}
```

### Command Chaining

```swift
import SwiftyShell

let commands = [
    Shell.Command(arguments: "pwd"),
    Shell.Command(arguments: "ls -la")
]

try await ZShell.process(commands: commands) { response in
    print("Command output: \(response.stdout ?? "none")")
}
```

### Error Handling

```swift
import SwiftyShell

let result = await ZShell.execute("false")
if result.terminationStatus != 0 {
    print("Command failed with exit code: \(result.terminationStatus)")
    print("stderr: \(result.stderr ?? "none")")
}
```

## API Overview

### Main Types

- `ZShell`: The main entry point for executing shell commands (typealias for `SwiftShell`)
- `Shell.Command`: Represents a shell command with its arguments
- `Shell.Response`: Contains the output of a command execution
- `Shell.Error`: Error type for command failures

### Key Methods

#### Simple Execution

```swift
// Returns stdout as String?
static func execute(_ command: String) async -> String?

// Returns (stdout: String?, stderr: String?, terminationStatus: Int)
static func execute(_ command: String) async -> (stdout: String?, stderr: String?, terminationStatus: Int)
```

#### Process Command API

```swift
// Execute a command and get detailed response
static func process(command: Shell.Command) async throws -> Shell.Response

// Execute multiple commands with progress callback
static func process(commands: [Shell.Command], progress: @escaping (Shell.Response) -> Void) async throws

// Execute multiple commands and get final response
static func process(commands: [Shell.Command]) async throws -> Shell.Response
```

## Examples

### Check if a file exists

```swift
let result = await ZShell.execute("test -f /path/to/file")
if result.terminationStatus == 0 {
    print("File exists")
} else {
    print("File does not exist")
}
```

### Get current directory

```swift
if let pwd = await ZShell.execute("pwd") {
    print("Current directory: \(pwd)")
}
```

### Run git commands

```swift
let result = await ZShell.execute("git status --short")
if result.terminationStatus == 0 {
    print("Git status:\n\(result.stdout ?? "")")
} else {
    print("Git error:\n\(result.stderr ?? "")")
}
```

## License

Copyright Hatch Mobile

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
