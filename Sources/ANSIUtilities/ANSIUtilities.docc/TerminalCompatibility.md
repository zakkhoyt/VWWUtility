# Terminal Compatibility

Understanding ANSI escape code support across different terminal emulators.

## Overview

While ANSI escape codes are a standard, not all terminals support all features equally. This guide helps you understand compatibility and make informed decisions about which features to use.

## macOS Terminal

**Built-in Terminal.app**

macOS Terminal has good ANSI support:

✅ **Fully Supported:**
- 3-bit/4-bit colors (16 colors)
- 8-bit colors (256 colors)
- 24-bit RGB colors (true color)
- Bold, italic, underline
- Cursor positioning and control

⚠️ **Limited Support:**
- Blink effects (often disabled by default)
- Some advanced cursor shapes

❌ **Not Supported:**
- Certain exotic font variants

```swift
// Safe for macOS Terminal
let text = ANSI.UI.decorate(
    text: "Hello",
    items: [.greenForeground, .boldFont]
)

// Also works - RGB colors
let rgbItem = ANSI.Item(ansi: .rgbForeground, values: [100, 200, 50])
let rgbText = ANSI.UI.decorate(text: "Custom", items: [rgbItem])
```

## iTerm2

**Popular macOS Terminal Replacement**

iTerm2 has excellent ANSI support - one of the most feature-complete terminals:

✅ **Fully Supported:**
- All standard ANSI color modes
- 24-bit RGB colors
- All text styles (bold, italic, underline, strikethrough)
- Advanced cursor control
- Cursor shape modification
- Extended font features

```swift
// Everything works in iTerm2
let fancyText = ANSI.UI.decorate(
    text: "Advanced",
    items: [
        ANSI.Item(ansi: .rgbForeground, values: [255, 128, 0]),
        .italicFont,
        .underlineFont
    ]
)
```

**iTerm2 Advantages:**
- True 24-bit color support
- Better rendering performance
- Support for ligatures with styled text
- Rich integration with ANSI features

## VS Code Integrated Terminal

**Visual Studio Code Built-in Terminal**

VS Code's integrated terminal has solid ANSI support:

✅ **Fully Supported:**
- 3-bit/4-bit colors
- 8-bit colors
- 24-bit RGB colors
- Bold, italic, underline
- Basic cursor control

⚠️ **Considerations:**
- Color rendering depends on VS Code theme
- Some themes override ANSI colors
- Performance can vary with large amounts of colored output

```swift
// Works well in VS Code terminal
let output = ANSI.UI.decorate(
    text: "VS Code",
    items: [.cyanForeground, .boldFont]
)

// Note: Colors may look different depending on theme
```

**Best Practices for VS Code:**
- Test with multiple themes if targeting VS Code users
- Avoid rapid cursor movements (can cause flicker)
- Keep colored output reasonably sized

## Warp

**Modern Terminal for macOS**

Warp is a new-generation terminal with excellent ANSI support:

✅ **Fully Supported:**
- All ANSI color modes including 24-bit RGB
- All text styling options
- Advanced cursor control
- Excellent rendering performance

```swift
// Full feature set works in Warp
let modernText = ANSI.UI.decorate(
    text: "Warp Terminal",
    items: [
        ANSI.Item(ansi: .rgbForeground, values: [88, 166, 255]),
        .boldFont,
        .italicFont
    ]
)
```

**Warp Advantages:**
- Fast rendering of ANSI-styled output
- Modern font rendering engine
- Excellent support for complex Unicode + ANSI combinations

## Other Terminal Emulators

### Alacritty
- Excellent ANSI support
- GPU-accelerated rendering
- Supports 24-bit color

### Hyper
- Good ANSI support
- Electron-based
- Configurable color schemes

### Windows Terminal
- Modern ANSI support on Windows
- 24-bit color support
- Good compatibility with Unix-style ANSI codes

### Linux Terminals (gnome-terminal, konsole, xterm)
- Varies by terminal
- Most modern Linux terminals support 24-bit color
- Check terminal capabilities with `COLORTERM` environment variable

## Detecting Terminal Capabilities

### Check for True Color Support

```swift
import Foundation

func supportsRGBColor() -> Bool {
    // Check COLORTERM environment variable
    if let colorterm = ProcessInfo.processInfo.environment["COLORTERM"] {
        return colorterm == "truecolor" || colorterm == "24bit"
    }
    
    // Check TERM environment variable
    if let term = ProcessInfo.processInfo.environment["TERM"] {
        return term.contains("256color") || term.contains("24bit")
    }
    
    return false
}

// Usage
if supportsRGBColor() {
    // Use RGB colors
    let item = ANSI.Item(ansi: .rgbForeground, values: [255, 100, 50])
    print(ANSI.UI.decorate(text: "RGB", items: [item]))
} else {
    // Fall back to 16 colors
    print(ANSI.UI.decorate(text: "Basic", items: [.redForeground]))
}
```

## Compatibility Recommendations

### Maximum Compatibility (All Terminals)

For the widest compatibility, stick to:

```swift
// 16 basic colors
ANSI.redForeground
ANSI.greenForeground
ANSI.blueForeground
// etc.

// Basic text styles
ANSI.boldFont
ANSI.underlineFont

// Safe example
let safeText = ANSI.UI.decorate(
    text: "Compatible",
    items: [.greenForeground, .boldFont]
)
```

### Modern Terminals (Recommended)

For modern terminals (iTerm2, Warp, VS Code, macOS Terminal):

```swift
// Use full feature set including RGB
let item = ANSI.Item(ansi: .rgbForeground, values: [100, 200, 150])
let modernText = ANSI.UI.decorate(
    text: "Modern",
    items: [item, .italicFont, .boldFont]
)
```

### Progressive Enhancement

Provide fallbacks for older terminals:

```swift
func coloredText(_ text: String, rgb: (Int, Int, Int)? = nil, fallback: ANSI? = nil) -> String {
    if supportsRGBColor(), let (r, g, b) = rgb {
        let item = ANSI.Item(ansi: .rgbForeground, values: [r, g, b])
        return ANSI.UI.decorate(text: text, items: [item])
    } else if let fallback = fallback {
        return ANSI.UI.decorate(text: text, items: [fallback])
    } else {
        return text
    }
}

// Usage
let text = coloredText("Important", rgb: (255, 100, 50), fallback: .redForeground)
```

## Testing Your Output

To test terminal compatibility:

1. **Run in multiple terminals** - Test your app in Terminal.app, iTerm2, VS Code
2. **Check environment variables** - Use `TERM` and `COLORTERM` to detect capabilities
3. **Provide text-only fallback** - Always have a plain text option
4. **Test with color blindness simulators** - Ensure accessibility

## Common Pitfalls

### Don't Assume Support

```swift
// ❌ Bad - assumes RGB support
let text = ANSI.UI.decorate(
    text: "Text",
    items: [ANSI.Item(ansi: .rgbForeground, values: [255, 100, 50])]
)

// ✅ Good - checks first or uses fallback
let text = supportsRGBColor()
    ? ANSI.UI.decorate(text: "Text", items: [ANSI.Item(ansi: .rgbForeground, values: [255, 100, 50])])
    : ANSI.UI.decorate(text: "Text", items: [.redForeground])
```

### Remember to Reset

```swift
// ✅ Good - resets formatting (default behavior)
let text = ANSI.UI.decorate(text: "Colored", items: [.redForeground])
print("\(text) normal text")

// The normal text won't be red because formatting is reset
```

## References

- [Terminal.app (Apple)](https://support.apple.com/guide/terminal/welcome/mac)
- [iTerm2](https://iterm2.com/)
- [VS Code Terminal](https://code.visualstudio.com/docs/terminal/basics)
- [Warp Terminal](https://www.warp.dev/)
- [ANSI Terminal Colors](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797)
