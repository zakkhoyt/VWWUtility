# ANSIUtilities

<!--- Metadata configuration to make appear this documentation page as a top-level page -->

@Metadata {
  @TechnologyRoot
}

A Swift library for working with ANSI escape codes in terminal applications.

## Overview

ANSIUtilities provides a comprehensive, type-safe API for working with ANSI escape codes in Swift. Whether you're building command-line tools, terminal UIs, or logging systems, ANSIUtilities makes it easy to add colors, styles, and cursor control to your text output.

The library supports:
- **Colors**: 3-bit/4-bit standard colors, 8-bit extended colors, and 24-bit RGB colors
- **Text Styles**: Bold, italic, underline, strikethrough, and more
- **Cursor Control**: Position, visibility, and movement
- **Terminal Compatibility**: Works with macOS Terminal, iTerm2, VS Code terminal, and modern terminals like Warp

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ANSIEscapeCodes>
- <doc:TerminalCompatibility>

### Working with ANSI Codes

- ``ANSI``
- ``ANSI/Item``
- ``ANSI/Style``
- ``ANSI/UI``

### File Descriptors

- ``FileDescriptor``

## About DocC

To preview this documentation:
```zsh
docc preview Sources/ANSIUtilities/ANSIUtilities.docc
```

For additional resources on how to get started with DocC, please refer to:
* [Swift: Documentation - Docc](https://www.swift.org/documentation/docc/)
