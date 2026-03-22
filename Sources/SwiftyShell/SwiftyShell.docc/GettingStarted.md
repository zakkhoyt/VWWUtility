# Getting Started with SwiftyShell

Run shell commands from Swift — from a single line of code to a fully structured async API.

## Overview

SwiftyShell provides three API tiers. Start with the simplest one that meets your needs
and reach for the structured tier when you need error details, stderr, or exit codes.

## Tier 1 — Simple String Output

Use ``SwiftShell/run(_:)`` when you only need stdout and don't care about errors:

```swift
import SwiftyShell

let today: String? = await ZShell.run("date -Iseconds")
// "2024-06-14T09:30:00-07:00"

let branch: String? = await ZShell.run("git rev-parse --abbrev-ref HEAD")
// "main"
```

`run` returns `nil` when the command produces no output or exits with a non-zero status.
It never throws.

## Tier 2 — String I/O

Use ``SwiftShell/execute(_:)`` when you also need stderr or the exit code:

```swift
let (stdout, stderr, status) = await ZShell.execute("ls /nonexistent")
// stdout: nil
// stderr: "ls: /nonexistent: No such file or directory"
// status: 1

if status == 0 {
    print("Success: \(stdout ?? "")")
} else {
    print("Failed (\(status)): \(stderr ?? "")")
}
```

Both `run` and `execute` accept a plain `String`. Arguments are split on spaces, so
commands like `"echo -n hello"` work as expected. For arguments that contain spaces,
use the structured ``Shell/Command`` API (Tier 3) and pass an `[String]` array directly.

## Tier 3 — Structured API

Use ``SwiftShell/process(command:)`` when you need typed errors, a custom working directory,
or precise control over arguments:

```swift
// Build a command from a plain string (splits on spaces)
let command = Shell.Command(arguments: "swift build")

// Build a command from an array (safe for arguments with spaces)
let command = Shell.Command(
    arguments: ["git", "commit", "-m", "fix: handle edge case with spaces"],
    currentDirectoryURL: URL(fileURLWithPath: "/path/to/repo")
)

do {
    let response = try await ZShell.process(command: command)
    print(response.stdoutTrimmed ?? "")
} catch let error as Shell.Error {
    print("Command failed: \(error.localizedDescription)")
}
```

`Shell.Command` properties:

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `executableURL` | `URL` | `/usr/bin/env` | Path to the executable |
| `arguments` | `[String]` | — | Arguments passed to the process |
| `currentDirectoryURL` | `URL?` | `nil` (inherits) | Working directory for the process |
| `redirectToPipe` | `Bool` | `false` | Route stdout to a pipe for chaining |
| `stdinPipe` | `Pipe?` | `nil` | Receive stdin from a previous command |

`Shell.Response` properties:

| Property | Type | Description |
| -------- | ---- | ----------- |
| `stdout` | `String?` | Raw standard output |
| `stdoutTrimmed` | `String?` | stdout with leading/trailing whitespace removed |
| `stderr` | `String?` | Raw standard error |
| `stderrTrimmed` | `String?` | stderr with leading/trailing whitespace removed |
| `process` | `Process` | The underlying `Foundation.Process` object |

## Callback Variant

A completion-handler overload is available for contexts where `async/await` is not yet
adopted:

```swift
try ZShell.process(command: Shell.Command(arguments: "date")) { result in
    switch result {
    case .success(let response):
        print(response.stdoutTrimmed ?? "")
    case .failure(let error):
        print("Error: \(error.failureReason ?? "")")
    }
}
```

## String Parsing Helpers

Two convenience extensions make it easy to construct argument lists from strings:

```swift
// String → [String]
let args: [String] = "ls -al".shellArguments
// ["ls", "-al"]

// [String] → [[String]]  (one array per command)
let lists: [[String]] = ["pwd", "ls -al"].shellArgumentLists
// [["pwd"], ["ls", "-al"]]
```

## Logging

SwiftyShell writes debug and fault messages to the unified logging system under the
subsystem `"SwiftyShell"` / category `"Shell"`. Use Console.app or `log stream` to
observe them at runtime:

```sh
log stream --predicate 'subsystem == "SwiftyShell"' --level debug
```

## References

- [Apple — Foundation Process](https://developer.apple.com/documentation/foundation/process)
- [Apple — Streams, Sockets, and Ports](https://developer.apple.com/documentation/foundation/streams_sockets_and_ports)
- [Apple — Unified Logging](https://developer.apple.com/documentation/os/logging)
