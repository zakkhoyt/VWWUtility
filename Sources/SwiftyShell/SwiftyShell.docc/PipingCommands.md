# Piping Commands

Chain multiple shell commands so the stdout of one feeds the stdin of the next.

## Overview

Unix shells use the `|` operator to connect commands in a pipeline. SwiftyShell
replicates this by passing the stdout `Pipe` of one `Shell.Response` as the `stdinPipe`
of the next `Shell.Command`. Two overloads of ``SwiftShell/process(commands:)`` handle the
plumbing automatically.

## Using `process(commands:)`

Pass an `[Shell.Command]` array to run the commands in sequence, with each command's stdout
automatically wired to the next command's stdin:

```swift
import SwiftyShell

// Equivalent to: echo "hello world" | tr '[:lower:]' '[:upper:]'
let commands: [Shell.Command] = [
    Shell.Command(arguments: ["echo", "hello world"]),
    Shell.Command(arguments: ["tr", "[:lower:]", "[:upper:]"])
]

let response = try await ZShell.process(commands: commands)
print(response.stdoutTrimmed ?? "")  // "HELLO WORLD"
```

The return value is the ``Shell/Response`` of the **last** command in the array.
If any command in the chain exits with a non-zero status, the whole call throws
``Shell/Error-swift.struct`` immediately and subsequent commands are not executed.

## Observing Progress

Use ``SwiftShell/process(commands:progress:)`` to receive a ``Shell/Response`` after each
step in the pipeline:

```swift
let commands: [Shell.Command] = [
    Shell.Command(arguments: ["ls", "/usr/bin"]),
    Shell.Command(arguments: ["grep", "swift"]),
    Shell.Command(arguments: ["sort"])
]

try await ZShell.process(commands: commands) { response in
    let line = response.stdoutTrimmed ?? ""
    print("Step output (\(line.count) chars): \(line.prefix(60))…")
}
```

The `progress` closure is called once per command, in order, after each process
terminates. This is useful for surfacing incremental output in a CLI or UI.

## Redirecting Output to a Pipe

By default each command's stdout is captured as a `String` in `Shell.Response.stdout`.
Set `redirectToPipe: true` on a command when its output should flow to the next
command's stdin **without** being decoded into a string first. This is useful for
binary data or large volumes of output:

```swift
let commands: [Shell.Command] = [
    Shell.Command(
        arguments: ["cat", "/usr/share/dict/words"],
        redirectToPipe: true      // stdout stays as Pipe, not decoded
    ),
    Shell.Command(arguments: ["wc", "-l"])
]

let response = try await ZShell.process(commands: commands)
print(response.stdoutTrimmed ?? "")  // word count
```

> Note: When `redirectToPipe` is `true`, `Shell.Response.stdout` is `nil` for that
> step. Only the final command's stdout is typically consumed as a string.

## Wiring Pipes Manually

If you need fine-grained control, build the pipe yourself by setting `stdinPipe`
on a `Shell.Command` directly. This lets you connect commands that are not run as
part of the same `process(commands:)` call:

```swift
// Step 1: run first command and get its stdout pipe
let firstCommand = Shell.Command(
    arguments: ["ls", "/usr/bin"],
    redirectToPipe: true
)
let firstResponse = try await ZShell.process(command: firstCommand)

// Step 2: pass the first command's stdout pipe as stdin to the second command
let secondCommand = Shell.Command(
    arguments: ["grep", "python"],
    stdinPipe: firstResponse.process.standardOutput as? Pipe
)
let secondResponse = try await ZShell.process(command: secondCommand)
print(secondResponse.stdoutTrimmed ?? "")
```

> Important: Cast `process.standardOutput` to `Pipe?` before assigning it to
> `stdinPipe`. The property is typed as `Any?` on `Foundation.Process`, so the
> cast will return `nil` if the process used a different output destination or
> if `redirectToPipe` was not set.

## Error Handling in Pipelines

When `process(commands:)` encounters a failure mid-pipeline it throws immediately.
The thrown ``Shell/Error`` contains the partial ``Shell/Response`` from the failing
command, including stderr:

```swift
let pipeline: [Shell.Command] = [
    Shell.Command(arguments: ["ls", "/no/such/path"]),   // fails here
    Shell.Command(arguments: ["sort"])                   // never runs
]

do {
    _ = try await ZShell.process(commands: pipeline)
} catch let error as Shell.Error {
    print("Failed at: \(error.command.instruction)")
    // "Failed at: ls /no/such/path"
    print("stderr: \(error.response.stderrTrimmed ?? "")")
    // "ls: /no/such/path: No such file or directory"
}
```

## Common Pipeline Patterns

### Filter lines matching a pattern

```swift
let commands: [Shell.Command] = [
    Shell.Command(arguments: ["ps", "aux"]),
    Shell.Command(arguments: ["grep", "Xcode"])
]
let response = try await ZShell.process(commands: commands)
print(response.stdoutTrimmed ?? "")
```

### Count files in a directory

```swift
let commands: [Shell.Command] = [
    Shell.Command(arguments: ["ls", "-1", "/usr/bin"]),
    Shell.Command(arguments: ["wc", "-l"])
]
let response = try await ZShell.process(commands: commands)
print("File count: \(response.stdoutTrimmed ?? "?")")
```

### Sort and deduplicate output

```swift
let commands: [Shell.Command] = [
    Shell.Command(arguments: ["cat", "/usr/share/dict/words"]),
    Shell.Command(arguments: ["sort"]),
    Shell.Command(arguments: ["uniq"])
]
let response = try await ZShell.process(commands: commands)
print(response.stdoutTrimmed ?? "")
```

## References

- [Apple — Pipe](https://developer.apple.com/documentation/foundation/pipe)
- [Apple — Process standardInput](https://developer.apple.com/documentation/foundation/process/1414916-standardinput)
- [Apple — Process standardOutput](https://developer.apple.com/documentation/foundation/process/1411106-standardoutput)
- [GNU Bash — Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html)
