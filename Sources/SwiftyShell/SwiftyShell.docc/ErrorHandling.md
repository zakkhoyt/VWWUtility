# Error Handling

Understand how SwiftyShell surfaces errors, stderr output, and non-zero exit codes.

## Overview

SwiftyShell distinguishes three categories of failure that a shell command can produce:

1. **Process launch failure** — the executable could not be started at all (e.g. bad path,
   missing permissions). Represented by `Shell.Error.Cause.processRun`.
2. **Non-zero exit code** — the process ran and exited with a status other than `0`.
   Represented by `Shell.Error.Cause.nonZeroTerminationStatus`.
3. **Pipe decode failure** — the raw bytes written to stdout/stderr could not be decoded as
   UTF-8. Represented by `Shell.Error.Cause.failedToDecodePipe`.

The structured API (`ZShell.process(command:)`) throws a ``Shell/Error-swift.struct`` when any of these
occur. The simple string APIs (`run` and `execute`) absorb errors and signal failure
through `nil` output or a non-zero `terminationStatus` integer instead of throwing.

## The Error Type

``Shell/Error-swift.struct`` conforms to `LocalizedError` and carries three pieces of information:

| Property | Type | Description |
| -------- | ---- | ----------- |
| `command` | `Shell.Command` | The command that was executing when the error occurred |
| `response` | `Shell.Response` | The partial response — stderr and stdout captured before failure |
| `cause` | `Shell.Error.Cause` | The specific reason for failure |

```swift
do {
    let response = try await ZShell.process(
        command: Shell.Command(arguments: "false")  // always exits 1
    )
} catch let error as Shell.Error {
    print(error.localizedDescription)
    // "instruction: false
    //  cause: Termination status: 1
    //  terminationStatus: 1
    //  stdout: <nil>
    //  stderr: <nil>
    //  command: /usr/bin/env false"
}
```

## Error Cause Cases

``Shell/Error-swift.struct/Cause-swift.enum`` is an `enum` with four cases:

### Non-Zero Exit Code

The most common case. The process ran to completion but exited with a non-zero status code.
The associated `Int32` value is the exact exit code.

```swift
do {
    _ = try await ZShell.process(command: Shell.Command(arguments: "ls /nonexistent"))
} catch let error as Shell.Error {
    if case .nonZeroTerminationStatus(let code) = error.cause {
        print("Exit code: \(code)")  // 1
        print("stderr: \(error.response.stderrTrimmed ?? "")")
        // "ls: /nonexistent: No such file or directory"
    }
}
```

### Launch Failure

The `Process.run()` call itself threw — the executable was not found, the file was not
executable, or a sandbox restriction prevented the launch. The associated value is the
underlying `Error` from Foundation.

```swift
do {
    let command = Shell.Command(
        executableURL: URL(fileURLWithPath: "/nonexistent/binary"),
        arguments: ["--help"]
    )
    _ = try await ZShell.process(command: command)
} catch let error as Shell.Error {
    if case .processRun(let underlying) = error.cause {
        print("Launch failed: \(underlying.localizedDescription)")
    }
}
```

### Pipe Decode Failure

The bytes written to stdout could not be decoded as UTF-8. The associated `Data?` value
contains the raw bytes that failed decoding, or `nil` if the pipe was empty.

```swift
catch let error as Shell.Error {
    if case .failedToDecodePipe(let raw) = error.cause {
        print("Raw bytes: \(raw?.hexString ?? "none")")
    }
}
```

### Empty Command List

Thrown by `process(commands:)` when the caller passes an empty array. This is a
programmer error and should not occur in production code.

## Reading stderr

Regardless of whether a command succeeds or fails, stderr is always captured and available
on the ``Shell/Response``:

```swift
// Successful command that writes to stderr
let response = try await ZShell.process(
    command: Shell.Command(arguments: "git status")
)
if let errOutput = response.stderrTrimmed {
    print("git stderr: \(errOutput)")
}

// Failed command — stderr is on the error's response
do {
    _ = try await ZShell.process(
        command: Shell.Command(arguments: "ls /no/such/path")
    )
} catch let error as Shell.Error {
    print("stderr: \(error.response.stderrTrimmed ?? "")")
    // "ls: /no/such/path: No such file or directory"
}
```

## Reading the Exit Code (Termination Status)

The exit code is accessible in two ways depending on which API tier you use:

**String I/O tier** — returned directly as the third tuple element:

```swift
let (_, _, status) = await ZShell.execute("false")
print(status)  // 1

let (_, _, status) = await ZShell.execute("true")
print(status)  // 0
```

**Structured tier** — available on the `Process` object inside the response:

```swift
let response = try await ZShell.process(
    command: Shell.Command(arguments: "true")
)
print(response.process.terminationStatus)   // Int32: 0
print(response.process.terminationReason)   // .exit or .uncaughtSignal
```

When the command fails, the exit code is on the error's embedded response:

```swift
catch let error as Shell.Error {
    let code = error.response.process.terminationStatus  // Int32
    print("Exited with code \(code)")
}
```

## Termination Reasons

`Process.terminationReason` is `.exit` for normal exit (including non-zero codes) and
`.uncaughtSignal` when the process was killed by a Unix signal (e.g. `SIGTERM`,
`SIGSEGV`). SwiftyShell extends `Process.TerminationReason` with `CustomStringConvertible`
so it prints as `"exit"` or `"uncaughtSignal"` rather than a raw integer:

```swift
let response = try await ZShell.process(
    command: Shell.Command(arguments: "date")
)
print(response.process.terminationReason)  // "exit"
```

## Legacy Error Type

``ShellInputError`` is used only by the older `SwiftShell.exec(commands:)` synchronous entry
point. Prefer the async APIs; `exec(commands:)` is kept for backward compatibility.

| Case | Meaning |
| ---- | ------- |
| `.stdinEmpty` | An empty `[String]` was passed to `exec(commands:)` |
| `.noStdOut` | The legacy execute helper returned `nil` |
| `.terminationStatus(Int32)` | Non-zero exit code from the legacy helper |

## Quick Reference

| Goal | API | Error signal |
| ---- | --- | ------------ |
| stdout only, ignore errors | `ZShell.run(_:)` | `nil` return |
| stdout + stderr + code | `ZShell.execute(_:)` | non-zero `terminationStatus` |
| Full typed error | `ZShell.process(command:)` | throws `Shell.Error` |
| Inspect stderr on failure | `Shell.Error.response.stderrTrimmed` | — |
| Inspect exit code | `Shell.Error.response.process.terminationStatus` | — |
| Inspect cause | `Shell.Error.cause` | see `Shell.Error.Cause` |

## References

- [Apple — Process terminationStatus](https://developer.apple.com/documentation/foundation/process/1415801-terminationstatus)
- [Apple — Process terminationReason](https://developer.apple.com/documentation/foundation/process/1413110-terminationreason)
- [Apple — LocalizedError](https://developer.apple.com/documentation/swift/localizederror)
- [GNU — Exit Status Codes](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html)
