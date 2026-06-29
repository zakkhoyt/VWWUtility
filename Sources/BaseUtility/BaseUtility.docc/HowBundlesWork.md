# Bundles

The following sections may use these vars. Here is what they mean. 
```sh
bundleIdentifier="co.hatch.WalkingSkeletonApp"
appName="WalkingSkeletonApp" # Bundle.main.bundleName (kCFBundleNameKey)
rotatingUUID="jr06zppx451b4kwyd2_bp9nc0000gn"
appUUID="3B142676-41A0-5475-A685-A4F25AE34E3E"
```


## Bundle.main
```sh
bundleURL -> "file:///private/var/folders/kd/${ROTATING_UUID}/X/${APP_UUID}/d/Wrapper/${APP_NAME}.app"
resourceURL -> "${Bundle_module_bundleURL}"
executableURL -> "${Bundle_module_bundleURL}/WalkingSkeletonApp"
privateFrameworksURL -> "${Bundle_module_bundleURL}/Frameworks"
sharedFrameworksURL -> "${Bundle_module_bundleURL}/SharedFrameworks"
sharedSupportURL -> "${Bundle_module_bundleURL}/SharedSupport"
builtInPlugInsURL -> "${Bundle_module_bundleURL}/PlugIns"
appStoreReceiptURL -> "$HOME/Library/Containers/${Bundle_module_bundleIdentifier}/Data/StoreKit/sandboxReceipt"

```

## Bundle.module

Notice how Bundle.module is a sub-module of Bundle.main (that app bundle)

```sh
bundleURL -> "file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/3B142676-41A0-5475-A685-A4F25AE34E3E/d/Wrapper/WalkingSkeletonApp.app/HatchModules_HatchBLEClient.bundle"
resourceURL -> "${Bundle_module_bundlePath}/"
executableURL -> <nil>
privateFrameworksURL -> "${Bundle_module_bundlePath}/Frameworks"
sharedFrameworksURL -> "${Bundle_module_bundlePath}/SharedFrameworks"
sharedSupportURL -> "${Bundle_module_bundlePath}/SharedSupport"
builtInPlugInsURL -> "${Bundle_module_bundlePath}/PlugIns"
appStoreReceiptURL -> <nil>
```


## Bundle.allBundles


## Bundle.allFrameworks


```sh
bundleURL -> "file:///System/iOSSupport/System/Library/AccessibilityBundles/SwiftUI.axbundle"
resourceURL -> "$Bundle_main_bundlePath/Contents/Resources"
executableURL -> "$Bundle_main_bundlePath/Contents/MacOS/SwiftUI"
privateFrameworksURL -> "$Bundle_main_bundlePath/Contents/Frameworks"
sharedFrameworksURL -> "$Bundle_main_bundlePath/Contents/SharedFrameworks"
sharedSupportURL -> "$Bundle_main_bundlePath/Contents/SharedSupport"
builtInPlugInsURL -> "$Bundle_main_bundlePath/Contents/PlugIns"
appStoreReceiptURL -> <nil>
```

## Real-World Example

The data aboe was mined from an iOS app (Bundle.main) which ships a Swift Packag (Bundle.module) and was taken on a `Designed for iPad` build.

See the mined data: 
* <doc: Bundle+main.json5>
* <doc: Bundle+module.json5>
* <doc: Bundle+allBundles.json5>
* Found `47` of them for `FileVault.app`
* <doc: Bundle+allFrameworks.json5>
* Found `636` of them for `FileVault.app`

