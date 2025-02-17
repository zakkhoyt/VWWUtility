# ``RadixUtilities``

## Overview

Contains utilities to convert between:

### Integer Types (FixedWidthInteger, BinaryInteger) <-> Radix Strings (binaryString, hexString, etc...)

```swift
let u8: UInt8 = UInt8(hexString: "0b11111111") // 0xb11111111
let binaryString = UInt8(0x10101010).binaryString // "0b10101010"

let u8: UInt8 = UInt8(hexString: "0xFF") // 0xFF
let hexString = UInt8(0xDE).hexString // "0xDE"

// Support for UInt8, 16, 32, 64, & 128 (iOS 18+)
// Support for Int8, 16, 32, 64, & 128 (iOS 18+)
```

### Data <-> Radix Strings (binaryString, hexString, etc...)
```swift
let data = Data(hexString: "0xFFFFFFFFFFFFFFFF") // Data(bytes: [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], count: 8)
let hexString = Data(<some blob>).hexString // blob in hexstring representation
```

### Data <-> [UInt8]
```swift
let data = Data(hexString: "0xFFFFFFFFFFFFFFFF") 
data.bytes == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
```

### [UInt8] <-> Radix Strings (binaryString, hexString, etc...)
```swift
let array: [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
array.hexString == "0xFFFFFFFFFFFFFFFF"
array.binaryString = "0b11111111111111111111111111...111"
```
### Also other similar utilities:
* isPowerOfTwo for Integer Types (FixedWidthInteger, BinaryInteger)
* String padding at either endfix. Used for padding leading "0"s onto binaryString/hexString, but exposed as a public API as well
* `FixedWidthInteger/percentString`
* `FixedWidthInteger/fractionOfMax(percent:)`

