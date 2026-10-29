# About



# `echo_pretty`

`echo_pretty` is `echo` with ANSI color, font, and cursor support, built on the `ANSIUtilities` library. Both were
relocated here from `HatchTerminal` on `2026-10-28` (branch `zakk/echo_pretty/relocate_to_vwwutility`).

Build a release binary with [`scripts/build-echo-pretty.zsh`](scripts/build-echo-pretty.zsh):

```zsh
# arm64 only -> .gitignored/release/arm64/echo_pretty
./scripts/build-echo-pretty.zsh

# Also build x86_64 + a universal binary, then install to ~/.zsh_home/bin
./scripts/build-echo-pretty.zsh --universal --install

# All options
./scripts/build-echo-pretty.zsh --help
```

> [!NOTE]
> `--install` creates the install dir if needed and warns when it is not on `PATH`.

Run the tests. `EchoPrettyTests` runs the debug `echo_pretty` binary, so build first:

```zsh
swift build
swift test --filter 'ANSIUtilitiesTests|EchoPrettyTests'
```

---

# Documentation

```zsh
# Generate and check for warnings (no Xcode required)
swift package \
  --disable-sandbox \
  generate-documentation \
  --target SwiftyShell

# Archive is written to:
# .build/plugins/Swift-DocC/outputs/SwiftyShell.doccarchive

# Preview in a browser (serves at localhost:8080)
swift package \
  --disable-sandbox \
  preview-documentation \
  --target SwiftyShell
```




# TODO
* Rename DrawingUI -> Math
  * Package.swift
  * Is there a way to rename packages?. [YES!](https://github.com/apple/swift-package-manager/blob/main/Documentation/ModuleAliasing.md)
  
  
  
* [X] CodableUtils from
   * [ ] Remove intersection with BaseUtility
   * [ ] set up tests
* [ ] RadixUtils from Module
* [ ] ColorUtils from DrawingUI?
* [ ] ShellUtils from TermTools
* [ ] SystemSettings form BaseUtility
* [ ] Swift6

