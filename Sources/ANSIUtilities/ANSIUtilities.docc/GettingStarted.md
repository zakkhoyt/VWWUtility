# Getting Started with ANSIUtilities

Learn how to use ANSIUtilities to add colors and styles to your terminal output.

## Overview

ANSIUtilities makes it easy to create colorful, styled terminal output in Swift. This guide will show you how to get started with the library, from basic text coloring to advanced terminal control.

## Installation

Add ANSIUtilities to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/zakkhoyt/VWWUtility", branch: "main")
]
```

Then add it to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "ANSIUtilities", package: "VWWUtility")
    ]
)
```

## Basic Usage

### Simple Text Coloring

The easiest way to add color to text is using ``ANSI/UI/decorate(text:items:endWithDefault:)``:

```swift
import ANSIUtilities

// Red text
let redText = ANSI.UI.decorate(text: "Error!", items: [.redForeground])
print(redText)

// Green text with bold
let greenBold = ANSI.UI.decorate(text: "Success!", items: [.greenForeground, .boldFont])
print(greenBold)

// Blue background with white text
let highlighted = ANSI.UI.decorate(text: "Important", items: [.blueBackground, .whiteForeground])
print(highlighted)
```

### Using ANSI Items

For more control, create ``ANSI/Item`` instances:

```swift
// Direct construction with simple colors
let yellowItem = ANSI.Item(.yellowForeground)

// RGB colors (24-bit) - requires 3 values
let rgbItem = ANSI.Item(.rgbForeground, values: [255, 100, 50])

// 8-bit colors - requires 1 value
let eightBitItem = ANSI.Item(.eightBitForeground, values: [196])
```

### Building Styles

Create reusable styles with ``ANSI/Style``:

```swift
// Define a style (ANSI.Style is a typealias for [ANSI])
let errorStyle: ANSI.Style = [.redForeground, .boldFont]

// Apply it to text
let styledText = ANSI.UI.decorate(text: "Critical Error", style: errorStyle)
print(styledText)

// Use predefined styles
let urlText = ANSI.UI.decorate(text: "https://example.com", style: .url)
print(urlText)
```

## Working with FileDescriptor

For direct stdout/stderr writing with ANSI codes:

```swift
// Write to stdout with color
FileDescriptor.stdout.write(
    ANSI.UI.decorate(text: "Standard output", items: [.cyanForeground])
)
FileDescriptor.stdout.writeLine()

// Write to stderr with color
FileDescriptor.stderr.writeLine(
    ANSI.UI.decorate(text: "Error message", items: [.redForeground])
)

// Read from stdin
if let input = try await FileDescriptor.stdin.read() {
    print("You entered: \(input)")
}
```

## Example: echo_pretty Command

The `echo_pretty` executable in this repository demonstrates real-world usage:

```bash
# Basic coloring
echo_pretty --red "Error:" --default " Something went wrong"

# Multiple styles
echo_pretty --green --bold "Success!" --default " Operation completed"

# RGB colors
echo_pretty --rgb 255 100 50 "Custom color text"

# Background colors
echo_pretty --blue-bg --white "Highlighted text"
```

## Next Steps

- Learn about <doc:ANSIEscapeCodes> to understand the underlying standards
- Check <doc:TerminalCompatibility> for platform-specific considerations
- Explore the API documentation for ``ANSI``, ``ANSI/Item``, and ``ANSI/Style``
