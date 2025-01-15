# ``HatchCodableUtilities``

## Overview

This module contains extensions around the subject of `Codable`

### JSON helpers for implementors of `Encodable`
```swift
let myEncodableStruct = ...
logger.debug("json representation: \(myEncodableStruct.jsonDescription)")
```

### DecodingError

Get human readable descriptions for `DecodingError` including line numbers, array indexes, absolute key paths into nested structs, type mismatches, and more. 

```swift
do {
    let content = try JSONDecoder().decode(MyStruct.self, from: data)
} catch let decodingError as DecodingError {
    logger.fault("Fail to decode data as MyStruct with decodingError: \(decodingError.debugDescription)")
} catch {
    logger.fault("An error occurred while decoding: \(error.localizedDescription)")
}
```

### EncodingError

Get human readable descriptions for `EncodingError` including line numbers, array indexes, absolute key paths into nested structs, type mismatches, and more.

```swift
do {
    let data = try JSONEncoder().encode(myStruct)
    logger.debug("Did encode myStruct: \(data.jsonDescription)")
} catch let encodingError as EncodingError {
    logger.fault("Fail to encode myStruct (to JSON Data) with encodingError: \(encodingError.debugDescription)")
} catch {
    logger.fault("An error occurred while encoding myStruct: \(error.localizedDescription)")
}
```

## Dependencies

For an overview of our modules and how they relate to each other, see [here](https://hatchbaby.atlassian.net/wiki/spaces/iosDevelopers/pages/591036417/Hatch+Sleep+Dependencies+iOS)
