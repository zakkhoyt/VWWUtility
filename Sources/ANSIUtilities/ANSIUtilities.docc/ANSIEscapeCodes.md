# ANSI Escape Codes

Understanding ANSI escape codes and how ANSIUtilities implements them.

## Overview

ANSI escape codes are special sequences that control text formatting, colors, and cursor positioning in terminal emulators. ANSIUtilities provides a type-safe Swift API for working with these codes.

## What are ANSI Escape Codes?

ANSI escape codes (also called ANSI escape sequences) are standardized sequences of bytes used to control text formatting, color, and other display options on text terminals. They originated from the ANSI X3.64 standard (later ISO/IEC 6429).

### Basic Structure

An ANSI escape code typically follows this pattern:

```
ESC [ <parameters> <command>
```

Where:
- `ESC` is the escape character (ASCII 27, or `\u{001B}` in Swift)
- `[` is the Control Sequence Introducer (CSI)
- `<parameters>` are semicolon-separated numeric values
- `<command>` is a letter indicating the operation

### Example

To make text red, you would use:

```
\u{001B}[31m
```

This breaks down as:
- `\u{001B}[` - Escape + CSI
- `31` - Parameter for red foreground color
- `m` - Command for "Set Graphics Mode"

## Color Support Levels

ANSIUtilities supports three levels of color depth:

### 3-bit and 4-bit Colors (16 colors)

The original 8 colors plus 8 bright variants:

```swift
// Basic colors (30-37)
ANSI.blackForeground   // \u{001B}[30m
ANSI.redForeground     // \u{001B}[31m
ANSI.greenForeground   // \u{001B}[32m
ANSI.yellowForeground  // \u{001B}[33m
ANSI.blueForeground    // \u{001B}[34m
ANSI.magentaForeground // \u{001B}[35m
ANSI.cyanForeground    // \u{001B}[36m
ANSI.whiteForeground   // \u{001B}[37m

// Bright colors (90-97)
ANSI.brightRedForeground   // \u{001B}[91m
ANSI.brightGreenForeground // \u{001B}[92m
// ... etc
```

### 8-bit Colors (256 colors)

Extended color palette with 256 colors:

```swift
// Use color from 256-color palette
let item = ANSI.Item(ansi: .eightBitForeground, values: [196]) // Bright red
let colored = ANSI.UI.decorate(text: "Text", items: [item])
```

The 256 colors are organized as:
- 0-15: Standard and bright colors
- 16-231: 216-color RGB cube (6×6×6)
- 232-255: 24 grayscale colors

### 24-bit RGB Colors (16.7 million colors)

True color support with full RGB specification:

```swift
// Custom RGB color (255, 100, 50)
let item = ANSI.Item(ansi: .rgbForeground, values: [255, 100, 50])
let colored = ANSI.UI.decorate(text: "Custom color", items: [item])
```

## Text Styles and Fonts

Beyond colors, ANSI codes support various text styles:

```swift
ANSI.boldFont           // \u{001B}[1m - Bold/bright
ANSI.dimFont            // \u{001B}[2m - Dim/faint
ANSI.italicFont         // \u{001B}[3m - Italic
ANSI.underlineFont      // \u{001B}[4m - Underline
ANSI.blinkFont          // \u{001B}[5m - Slow blink
ANSI.rapidBlinkFont     // \u{001B}[6m - Rapid blink
ANSI.reverseVideoFont   // \u{001B}[7m - Reverse video
ANSI.concealFont        // \u{001B}[8m - Conceal/hide
ANSI.strikethroughFont  // \u{001B}[9m - Strikethrough
```

## Cursor Control

Move and control the cursor position:

```swift
ANSI.cursorUp(lines: 5)      // Move up 5 lines
ANSI.cursorDown(lines: 2)    // Move down 2 lines
ANSI.cursorForward(cols: 10) // Move right 10 columns
ANSI.cursorBack(cols: 3)     // Move left 3 columns
ANSI.cursorPosition(row: 5, col: 10) // Move to specific position
ANSI.cursorHide              // Hide cursor
ANSI.cursorShow              // Show cursor
```

## The Hard Way vs. The Easy Way

### The Hard Way (Manual ANSI Codes)

Without ANSIUtilities, you'd write:

```swift
// Error-prone, hard to read
print("\u{001B}[31m\u{001B}[1mError:\u{001B}[0m Something went wrong")

// Easy to make mistakes
let color = 31 // What color is this?
print("\u{001B}[\(color)mText\u{001B}[0m")
```

### The Easy Way (ANSIUtilities)

With ANSIUtilities:

```swift
// Type-safe, readable, and maintainable
let errorText = ANSI.UI.decorate(text: "Error:", items: [.redForeground, .boldFont])
print("\(errorText) Something went wrong")

// Clear intent
let colored = ANSI.UI.decorate(text: "Text", items: [.redForeground])
```

## Resetting Formatting

Always reset formatting after applying styles:

```swift
// ANSIUtilities handles this automatically
let text = ANSI.UI.decorate(text: "Colored", items: [.redForeground])
// Automatically appends \u{001B}[0m to reset

// Manual control
let text = ANSI.UI.decorate(text: "Colored", items: [.redForeground], endWithDefault: false)
// Doesn't reset - use when chaining multiple decorations
```

## References

- [ANSI escape code (Wikipedia)](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [3-bit and 4-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)
- [8-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit)
- [24-bit RGB colors](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit)
- [ANSI X3.64 Standard](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [Bash Prompt HOWTO](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html)
