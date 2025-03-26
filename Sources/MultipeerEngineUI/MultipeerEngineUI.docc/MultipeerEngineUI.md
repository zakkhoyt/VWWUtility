# ``MultipeerEngineUI``

## Overview

SwiftUI views to faciltate advertising/browsing, joining/requesting, accept/declining, then transferring data

## Topics

### DemoApp
- See [Apple's Demo app here](https://developer.apple.com/documentation/nearbyinteraction/implementing-interactions-between-users-in-close-proximity)

### Info.Plist

- See [app requirements here](https://developer.apple.com/documentation/nearbyinteraction/discovering-peers-with-multipeer-connectivity)

#### `NSBonjourServices`
```xml
<key>NSBonjourServices</key>
<array>
<string>_vww-mpdev._tcp</string>
<string>_vww-mpdev._udp</string>
<string>_abc-temp._tcp</string>
<string>_abc-temp._udp</string>
</array>
```

#### `NSLocalNetworkUsageDescription`
```xml
<key>NSLocalNetworkUsageDescription</key>
<string>Multipeer Engine (usage string)</string>
```
