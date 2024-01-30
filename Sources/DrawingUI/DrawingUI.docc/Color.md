# Color

## Overview

Here is some info about the Color utilities (TODO)

### Color Spaces
Code to convert a `UIColor` to or from:
* `RGBA`
* `HSVA`
* `HSLA`
* `CMYKA`
* `YUVA`

```swift
/// Converts `color` to different color-spaces, converts to hex value for each component.
/// ```
/// rgba: 0xFF, 0x00, 0x00, 0xFF
/// cmyka: ...
/// hsba: ...
/// hsla: ...
/// yuva: ...
/// ```
func logColor(color: UIColor) {
    [
        "rgba: \(color.rgba().stringFor(type: .baseSixteen))",
        "cmyka: \(color.cmyka().stringFor(type: .baseSixteen))",
        "hsba: \(color.hsba().stringFor(type: .baseSixteen))",
        "hsla: \(color.hsla().stringFor(type: .baseSixteen))",
        "yuva: \(color.yuva().stringFor(type: .baseSixteen))",
    ].joined(separator: "\n")
}
```
