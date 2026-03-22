# ``SwiftyShell``

Run shell commands from Swift using a clean async/await API built on `Foundation.Process`.

## Overview

SwiftyShell wraps macOS's `Foundation.Process` class to make shell execution feel
natural in Swift. It offers three tiers of API — choose the one that fits your use case:

| Tier | Entry Point | Returns |
| ---- | ----------- | ------- |
| **Simple** | `ZShell.run(_:)` | `String?` (stdout only) |
| **String I/O** | `ZShell.execute(_:)` | `(stdout, stderr, terminationStatus)` |
| **Structured** | `ZShell.process(command:)` | `Shell.Response` (throws `Shell.Error`) |

All three tiers are `async`. There is also a callback variant of the structured API and a
deprecated synchronous `legacyExecute` kept for backward compatibility.

### Platform

SwiftyShell is macOS-only. Every public symbol is compiled only when `os(macOS)` is true.

### Entry Point

`ZShell` is a type-alias for `SwiftShell`, a concrete `enum` that conforms to `Shellable`.
All API is accessed through static functions on `ZShell`:

```swift
import SwiftyShell

// Simplest — just stdout
let output: String? = await ZShell.run("date -Iseconds")

// String I/O — stdout + stderr + exit code
let (stdout, stderr, status) = await ZShell.execute("ls /nonexistent")

// Structured — full control, typed errors
let response = try await ZShell.process(command: Shell.Command(arguments: "pwd"))
print(response.stdoutTrimmed ?? "")
```

## Topics

### Getting Started

- <doc:GettingStarted>

### Error Handling

- <doc:ErrorHandling>

### Piping Commands

- <doc:PipingCommands>

### Core Types

- ``Shell``
- ``Shell/Command``
- ``Shell/Response``
- ``Shell/Error-swift.struct``
- ``Shell/Error-swift.struct/Cause-swift.enum``
- ``SwiftShell``
- ``Shellable``

### Legacy & Errors

- ``ShellInputError``
