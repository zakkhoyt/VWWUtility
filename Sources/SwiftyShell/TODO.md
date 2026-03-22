

# Simplify  interface
```swift
let today: String? = await ZShell.run("date -Iseconds")

let (stdout, stderr, status) = await ZShell.execute("ls /nonexistent")



do {
    let response = try await ZShell.process(command: command)
    print(response.stdoutTrimmed ?? "")
} catch let error as Shell.Error {
    print("Command failed: \(error.localizedDescription)")
}
```








* Remove `.run` in favor of `.execute`

```swift
// Before
let today: String? = await ZShell.run("date -Iseconds")

// After
let today: String? = try? try ZShell.execute("date -Iseconds")
```



