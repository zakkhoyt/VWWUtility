# Platforms

This artilce shows how properties differ for an app across platforms and targets. 



## iOSDevice
An iOS app running on a physical iOS device

```log
#if os(macOS): false
#if canImport(AppKit): false
#if os(iOS): true
#if canImport(UIKit): true
#if targetEnvironment(simulator): false
#if targetEnvironment(macCatalyst): false

ProcessInfo.processInfo.isiOSAppOnMac: false
ProcessInfo.processInfo.isMacCatalystApp: false
ProcessInfo.processInfo.hostName: zphone.local
ProcessInfo.processInfo.processName: CameraPreviewUI
ProcessInfo.processInfo.processIdentifier: 5726
ProcessInfo.processInfo.globallyUniqueString: 7692831C-6F41-4F16-9835-60240D38AEB8-5726-000006B0D5322523
ProcessInfo.processInfo.processorCount: 6
ProcessInfo.processInfo.activeProcessorCount: 6
ProcessInfo.processInfo.physicalMemory: 5918310400
ProcessInfo.processInfo.systemUptime: 306523.369942
ProcessInfo.processInfo.operatingSystem(): 5
ProcessInfo.processInfo.operatingSystemName(): NSMACHOperatingSystem
ProcessInfo.processInfo.operatingSystemVersionString: Version 18.3.1 (Build 22D72)
ProcessInfo.processInfo.operatingSystemVersion: 18.3.1
ProcessInfo.processInfo.thermalState: nominal
ProcessInfo.processInfo.isLowPowerModeEnabled: false

URLService.applicationDirURL.path: /private/var/mobile/Containers/Data/Application/DE66ABF6-E995-4D44-8CFE-95820C32FA4D
URLService.applicationDirectoryURL.path: /var/mobile/Containers/Data/Application/DE66ABF6-E995-4D44-8CFE-95820C32FA4D/Applications
URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test").path: /private/var/mobile/Containers/Shared/AppGroup/37E93A5A-69E5-4DB4-9D13-79A6E7FFC768
PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:
    [0] .adminApplicationDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications/Utilities
    [1] .allApplicationsDirectory: 
        /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications
        /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications/Utilities
        /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Developer/Applications
        /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications/Demos
    [2] .allLibrariesDirectory: 
        /private/var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Library
        /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Developer
    [3] .applicationDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications
    [4] .applicationSupportDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Library/Application Support
    [5] .cachesDirectory: /private/var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Library/Caches
    [6] .coreServiceDirectory: <nil>
    [7] .demoApplicationDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Applications/Demos
    [8] .desktopDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Desktop
    [9] .developerApplicationDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Developer/Applications
    [10] .developerDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Developer
    [11] .documentationDirectory: /var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Library/Documentation

    [12] .documentDirectory: /private/var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Documents
    [13] .libraryDirectory: /private/var/mobile/Containers/Data/Application/4A6915B7-3598-4D10-9BFC-140586F7B374/Library
    [14] .userDirectory: <nil>

Bundle.main.debugSummary:
    description: NSBundle </private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app> (loaded)
    bundleIdentifier: co.z2k.CameraPreviewUI
    bundleURL file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/
    resourceURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/
    executableURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/CameraPreviewUI
    privateFrameworksURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/Frameworks/
    sharedFrameworksURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/SharedFrameworks/
    sharedSupportURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/SharedSupport/
    builtInPlugInsURL? file:///private/var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/PlugIns/
    appStoreReceiptURL? file:///private/var/mobile/Containers/Data/Application/DE66ABF6-E995-4D44-8CFE-95820C32FA4D/StoreKit/sandboxReceipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleExecutable]: CameraPreviewUI
        [3] infoDictionary[CFBundleIdentifier]: co.z2k.CameraPreviewUI
        [4] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [5] infoDictionary[CFBundleName]: CameraPreviewUI
        [6] infoDictionary[CFBundleNumericVersion]: 16809984
        [7] infoDictionary[CFBundlePackageType]: APPL
        [8] infoDictionary[CFBundleShortVersionString]: 1.0
        [9] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneOS
        )
        [10] infoDictionary[CFBundleVersion]: 1
        [11] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [12] infoDictionary[DTPlatformBuild]: 22C146
        [13] infoDictionary[DTPlatformName]: iphoneos
        [14] infoDictionary[DTPlatformVersion]: 18.2
        [15] infoDictionary[DTSDKBuild]: 22C146
        [16] infoDictionary[DTSDKName]: iphoneos18.2
        [17] infoDictionary[DTXcode]: 1620
        [18] infoDictionary[DTXcodeBuild]: 16C5032a
        [19] infoDictionary[LSRequiresIPhoneOS]: 1
        [20] infoDictionary[MinimumOSVersion]: 18
        [21] infoDictionary[NSCameraUsageDescription]: Gimme da camera
        [22] infoDictionary[NSMicrophoneUsageDescription]: Gimme da microphone
        [23] infoDictionary[UIApplicationSceneManifest]: {
            UIApplicationSupportsMultipleScenes = 1;
            UISceneConfigurations =     {
            };
        }
        [24] infoDictionary[UIApplicationSupportsIndirectInputEvents]: 1
        [25] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
        [26] infoDictionary[UILaunchScreen]: {
            UILaunchScreen =     {
            };
        }
        [27] infoDictionary[UIRequiredDeviceCapabilities]: (
            arm64
        )
        [28] infoDictionary[UIStatusBarStyle]: UIStatusBarStyleDefault
        [29] infoDictionary[UISupportedInterfaceOrientations]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [30] infoDictionary[UISupportedInterfaceOrientations~iphone]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )

Bundle.module.debugSummary:
    description: NSBundle </var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle> (not yet loaded)
    bundleIdentifier: vwwutility.BaseUtility.resources
    bundleURL file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    resourceURL? file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    executableURL? <nil>
    privateFrameworksURL? file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/Frameworks/
    sharedFrameworksURL? file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedFrameworks/
    sharedSupportURL? file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedSupport/
    builtInPlugInsURL? file:///var/containers/Bundle/Application/9E9DA66E-8BA1-4DFA-BB55-A6944698C1AC/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/PlugIns/
    appStoreReceiptURL? <nil>
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleIdentifier]: vwwutility.BaseUtility.resources
        [3] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [4] infoDictionary[CFBundleName]: VWWUtility_BaseUtility
        [5] infoDictionary[CFBundlePackageType]: BNDL
        [6] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneOS
        )
        [7] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [8] infoDictionary[DTPlatformBuild]: 22C146
        [9] infoDictionary[DTPlatformName]: iphoneos
        [10] infoDictionary[DTPlatformVersion]: 18.2
        [11] infoDictionary[DTSDKBuild]: 22C146
        [12] infoDictionary[DTSDKName]: iphoneos18.2
        [13] infoDictionary[DTXcode]: 1620
        [14] infoDictionary[DTXcodeBuild]: 16C5032a
        [15] infoDictionary[MinimumOSVersion]: 17.0
        [16] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
        [17] infoDictionary[UIRequiredDeviceCapabilities]: (
            arm64
        )
```

## iOSSimulator

An iOS app running on an iOS Simulator on macOS


```log
#if os(macOS): false
#if canImport(AppKit): false
#if os(iOS): true
#if canImport(UIKit): true
#if targetEnvironment(simulator): true
#if targetEnvironment(macCatalyst): false

ProcessInfo.processInfo.isiOSAppOnMac: false
ProcessInfo.processInfo.isMacCatalystApp: false
ProcessInfo.processInfo.hostName: zakkbookmax.local
ProcessInfo.processInfo.processName: CameraPreviewUI
ProcessInfo.processInfo.processIdentifier: 68557
ProcessInfo.processInfo.globallyUniqueString: 7ED7FD77-FCF4-41F1-A2AF-E3E625079A8B-68557-00000EDF82F8782E
ProcessInfo.processInfo.processorCount: 12
ProcessInfo.processInfo.activeProcessorCount: 12
ProcessInfo.processInfo.physicalMemory: 103079215104
ProcessInfo.processInfo.systemUptime: 681380.742551
ProcessInfo.processInfo.operatingSystem(): 5
ProcessInfo.processInfo.operatingSystemName(): NSMACHOperatingSystem
ProcessInfo.processInfo.operatingSystemVersionString: Version 18.2 (Build 22C150)
ProcessInfo.processInfo.operatingSystemVersion: 18.2.0
ProcessInfo.processInfo.thermalState: nominal
ProcessInfo.processInfo.isLowPowerModeEnabled: false

URLService.applicationDirURL.path: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD
URLService.applicationDirectoryURL.path: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications
URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test").path: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Shared/AppGroup/80F347C8-897F-4153-88D5-1710D54C184C
PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:
    [0] .adminApplicationDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications/Utilities
    [1] .allApplicationsDirectory: 
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications/Utilities
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Developer/Applications
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications/Demos
    [2] .allLibrariesDirectory: 
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Library
        /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Developer
    [3] .applicationDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications
    [4] .applicationSupportDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Library/Application Support
    [5] .cachesDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Library/Caches
    [6] .coreServiceDirectory: <nil>
    [7] .demoApplicationDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Applications/Demos
    [8] .desktopDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Desktop
    [9] .developerApplicationDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Developer/Applications
    [10] .developerDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Developer
    [11] .documentationDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Library/Documentation
    [12] .documentDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Documents
    [13] .libraryDirectory: /Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD/Library
    [14] .userDirectory: <nil>

Bundle.main.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app> (loaded)
    bundleIdentifier: co.z2k.CameraPreviewUI
    bundleURL file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/
    executableURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/CameraPreviewUI
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/B93DFB61-71CA-46E6-B317-F9213CC51F32/StoreKit/receipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleExecutable]: CameraPreviewUI
        [3] infoDictionary[CFBundleIdentifier]: co.z2k.CameraPreviewUI
        [4] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [5] infoDictionary[CFBundleName]: CameraPreviewUI
        [6] infoDictionary[CFBundleNumericVersion]: 16809984
        [7] infoDictionary[CFBundlePackageType]: APPL
        [8] infoDictionary[CFBundleShortVersionString]: 1.0
        [9] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneSimulator
        )
        [10] infoDictionary[CFBundleVersion]: 1
        [11] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [12] infoDictionary[DTPlatformBuild]: 22C146
        [13] infoDictionary[DTPlatformName]: iphonesimulator
        [14] infoDictionary[DTPlatformVersion]: 18.2
        [15] infoDictionary[DTSDKBuild]: 22C146
        [16] infoDictionary[DTSDKName]: iphonesimulator18.2
        [17] infoDictionary[DTXcode]: 1620
        [18] infoDictionary[DTXcodeBuild]: 16C5032a
        [19] infoDictionary[LSRequiresIPhoneOS]: 1
        [20] infoDictionary[MinimumOSVersion]: 18
        [21] infoDictionary[NSCameraUsageDescription]: Gimme da camera
        [22] infoDictionary[NSMicrophoneUsageDescription]: Gimme da microphone
        [23] infoDictionary[UIApplicationSceneManifest]: {
            UIApplicationSupportsMultipleScenes = 1;
            UISceneConfigurations =     {
            };
        }
        [24] infoDictionary[UIApplicationSupportsIndirectInputEvents]: 1
        [25] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
        [26] infoDictionary[UILaunchScreen]: {
            UILaunchScreen =     {
            };
        }
        [27] infoDictionary[UIStatusBarStyle]: UIStatusBarStyleDefault
        [28] infoDictionary[UISupportedInterfaceOrientations]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [29] infoDictionary[UISupportedInterfaceOrientations~iphone]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )

Bundle.module.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle> (not yet loaded)
    bundleIdentifier: vwwutility.BaseUtility.resources
    bundleURL file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    executableURL? <nil>
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/0CC27185-EEF9-499E-B2A0-9ABB23FC06F5/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/PlugIns/
    appStoreReceiptURL? <nil>
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleIdentifier]: vwwutility.BaseUtility.resources
        [3] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [4] infoDictionary[CFBundleName]: VWWUtility_BaseUtility
        [5] infoDictionary[CFBundlePackageType]: BNDL
        [6] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneSimulator
        )
        [7] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [8] infoDictionary[DTPlatformBuild]: 22C146
        [9] infoDictionary[DTPlatformName]: iphonesimulator
        [10] infoDictionary[DTPlatformVersion]: 18.2
        [11] infoDictionary[DTSDKBuild]: 22C146
        [12] infoDictionary[DTSDKName]: iphonesimulator18.2
        [13] infoDictionary[DTXcode]: 1620
        [14] infoDictionary[DTXcodeBuild]: 16C5032a
        [15] infoDictionary[MinimumOSVersion]: 17.0
        [16] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
```

## macDesignedForIPhoneIPad

An iOS app running in a window on macOS (comiled to run on iOS. No separate compile needed)

```log
#if os(macOS): false
#if canImport(AppKit): false
#if os(iOS): true
#if canImport(UIKit): true
#if targetEnvironment(simulator): false
#if targetEnvironment(macCatalyst): false

ProcessInfo.processInfo.isiOSAppOnMac: true
ProcessInfo.processInfo.isMacCatalystApp: true
ProcessInfo.processInfo.hostName: zakkbookmax.local
ProcessInfo.processInfo.processName: CameraPreviewUI
ProcessInfo.processInfo.processIdentifier: 68471
ProcessInfo.processInfo.globallyUniqueString: 9E26C049-7E1F-4A5E-B120-1AB823A36239-68471-00000EDF3000F5AD
ProcessInfo.processInfo.processorCount: 12
ProcessInfo.processInfo.activeProcessorCount: 12
ProcessInfo.processInfo.physicalMemory: 103079215104
ProcessInfo.processInfo.systemUptime: 681322.744447
ProcessInfo.processInfo.operatingSystem(): 5
ProcessInfo.processInfo.operatingSystemName(): NSMACHOperatingSystem
ProcessInfo.processInfo.operatingSystemVersionString: Version 15.1 (Build 24B5055e)
ProcessInfo.processInfo.operatingSystemVersion: 18.1.0
ProcessInfo.processInfo.thermalState: nominal
ProcessInfo.processInfo.isLowPowerModeEnabled: false

URLService.applicationDirURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data
URLService.applicationDirectoryURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test").path: /Users/zakkhoyt/Library/GroupContainersAlias/group.co.z2k.test
PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:
    [0] .adminApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
    [1] .allApplicationsDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [2] .allLibrariesDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [3] .applicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
    [4] .applicationSupportDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Application Support
    [5] .cachesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Caches
    [6] .coreServiceDirectory: <nil>
    [7] .demoApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [8] .desktopDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Desktop
    [9] .developerApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
    [10] .developerDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [11] .documentationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Documentation
    [12] .documentDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Documents
    [13] .libraryDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
    [14] .userDirectory: <nil>

Bundle.main.debugSummary:
    description: NSBundle </private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app> (loaded)
    bundleIdentifier: co.z2k.CameraPreviewUI
    bundleURL file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/
    resourceURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/
    executableURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/CameraPreviewUI
    privateFrameworksURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/Frameworks/
    sharedFrameworksURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/SharedFrameworks/
    sharedSupportURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/SharedSupport/
    builtInPlugInsURL? file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/StoreKit/sandboxReceipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleExecutable]: CameraPreviewUI
        [3] infoDictionary[CFBundleIdentifier]: co.z2k.CameraPreviewUI
        [4] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [5] infoDictionary[CFBundleName]: CameraPreviewUI
        [6] infoDictionary[CFBundleNumericVersion]: 16809984
        [7] infoDictionary[CFBundlePackageType]: APPL
        [8] infoDictionary[CFBundleShortVersionString]: 1.0
        [9] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneOS
        )
        [10] infoDictionary[CFBundleVersion]: 1
        [11] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [12] infoDictionary[DTPlatformBuild]: 22C146
        [13] infoDictionary[DTPlatformName]: iphoneos
        [14] infoDictionary[DTPlatformVersion]: 18.2
        [15] infoDictionary[DTSDKBuild]: 22C146
        [16] infoDictionary[DTSDKName]: iphoneos18.2
        [17] infoDictionary[DTXcode]: 1620
        [18] infoDictionary[DTXcodeBuild]: 16C5032a
        [19] infoDictionary[LSRequiresIPhoneOS]: 1
        [20] infoDictionary[MinimumOSVersion]: 18
        [21] infoDictionary[NSCameraUsageDescription]: Gimme da camera
        [22] infoDictionary[NSMicrophoneUsageDescription]: Gimme da microphone
        [23] infoDictionary[UIApplicationSceneManifest]: {
            UIApplicationSupportsMultipleScenes = 1;
            UISceneConfigurations =     {
            };
        }
        [24] infoDictionary[UIApplicationSupportsIndirectInputEvents]: 1
        [25] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
        [26] infoDictionary[UILaunchScreen]: {
            UILaunchScreen =     {
            };
        }
        [27] infoDictionary[UIRequiredDeviceCapabilities]: (
            arm64
        )
        [28] infoDictionary[UIStatusBarStyle]: UIStatusBarStyleDefault
        [29] infoDictionary[UISupportedInterfaceOrientations]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationPortraitUpsideDown,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [30] infoDictionary[UISupportedInterfaceOrientations~ipad]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationPortraitUpsideDown,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [31] infoDictionary[UISupportedInterfaceOrientations~iphone]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )

Bundle.module.debugSummary:
    description: NSBundle </var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle> (not yet loaded)
    bundleIdentifier: vwwutility.BaseUtility.resources
    bundleURL file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    resourceURL? file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/
    executableURL? <nil>
    privateFrameworksURL? file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/Frameworks/
    sharedFrameworksURL? file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedFrameworks/
    sharedSupportURL? file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/SharedSupport/
    builtInPlugInsURL? file:///var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/2E20D72B-1993-59A7-86FF-00056410DF7D/d/Wrapper/CameraPreviewUI.app/VWWUtility_BaseUtility.bundle/PlugIns/
    appStoreReceiptURL? <nil>
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleIdentifier]: vwwutility.BaseUtility.resources
        [3] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [4] infoDictionary[CFBundleName]: VWWUtility_BaseUtility
        [5] infoDictionary[CFBundlePackageType]: BNDL
        [6] infoDictionary[CFBundleSupportedPlatforms]: (
            iPhoneOS
        )
        [7] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [8] infoDictionary[DTPlatformBuild]: 22C146
        [9] infoDictionary[DTPlatformName]: iphoneos
        [10] infoDictionary[DTPlatformVersion]: 18.2
        [11] infoDictionary[DTSDKBuild]: 22C146
        [12] infoDictionary[DTSDKName]: iphoneos18.2
        [13] infoDictionary[DTXcode]: 1620
        [14] infoDictionary[DTXcodeBuild]: 16C5032a
        [15] infoDictionary[MinimumOSVersion]: 17.0
        [16] infoDictionary[UIDeviceFamily]: (
            1,
            2
        )
        [17] infoDictionary[UIRequiredDeviceCapabilities]: (
            arm64
        )
```

## macCatalyst

An iOS app running in a window on macOS (but recompiled to run on macOS)


```log
#if os(macOS): false
#if canImport(AppKit): true
#if os(iOS): true
#if canImport(UIKit): true
#if targetEnvironment(simulator): false
#if targetEnvironment(macCatalyst): true

ProcessInfo.processInfo.isiOSAppOnMac: false
ProcessInfo.processInfo.isMacCatalystApp: true
ProcessInfo.processInfo.hostName: zakkbookmax.local
ProcessInfo.processInfo.processName: CameraPreviewUI
ProcessInfo.processInfo.processIdentifier: 68441
ProcessInfo.processInfo.globallyUniqueString: 2505B801-31A1-4FB6-BDE1-694669D0036A-68441-00000EDF1A585F22
ProcessInfo.processInfo.processorCount: 12
ProcessInfo.processInfo.activeProcessorCount: 12
ProcessInfo.processInfo.physicalMemory: 103079215104
ProcessInfo.processInfo.systemUptime: 681307.604000
ProcessInfo.processInfo.operatingSystem(): 5
ProcessInfo.processInfo.operatingSystemName(): NSMACHOperatingSystem
ProcessInfo.processInfo.operatingSystemVersionString: Version 15.1 (Build 24B5055e)
ProcessInfo.processInfo.operatingSystemVersion: 15.1.0
ProcessInfo.processInfo.thermalState: nominal
ProcessInfo.processInfo.isLowPowerModeEnabled: false

URLService.applicationDirURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data
URLService.applicationDirectoryURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test").path: /Users/zakkhoyt/Library/Group Containers/group.co.z2k.test
PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:
    [0] .adminApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
    [1] .allApplicationsDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [2] .allLibrariesDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [3] .applicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
    [4] .applicationSupportDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Application Support
    [5] .cachesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Caches
    [6] .coreServiceDirectory: <nil>
    [7] .demoApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [8] .desktopDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Desktop
    [9] .developerApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
    [10] .developerDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [11] .documentationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Documentation
    [12] .documentDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Documents
    [13] .libraryDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
    [14] .userDirectory: <nil>

Bundle.main.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app> (loaded)
    bundleIdentifier: co.z2k.CameraPreviewUI
    bundleURL file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/
    executableURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/MacOS/CameraPreviewUI
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/_MASReceipt/receipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleExecutable]: CameraPreviewUI
        [3] infoDictionary[CFBundleIdentifier]: co.z2k.CameraPreviewUI
        [4] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [5] infoDictionary[CFBundleName]: CameraPreviewUI
        [6] infoDictionary[CFBundleNumericVersion]: 16809984
        [7] infoDictionary[CFBundlePackageType]: APPL
        [8] infoDictionary[CFBundleShortVersionString]: 1.0
        [9] infoDictionary[CFBundleSupportedPlatforms]: (
            MacOSX
        )
        [10] infoDictionary[CFBundleVersion]: 1
        [11] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [12] infoDictionary[DTPlatformBuild]: 24C94
        [13] infoDictionary[DTPlatformName]: macosx
        [14] infoDictionary[DTPlatformVersion]: 15.2
        [15] infoDictionary[DTSDKBuild]: 24C94
        [16] infoDictionary[DTSDKName]: macosx15.2
        [17] infoDictionary[DTXcode]: 1620
        [18] infoDictionary[DTXcodeBuild]: 16C5032a
        [19] infoDictionary[LSMinimumSystemVersion]: 15.0
        [20] infoDictionary[NSCameraUsageDescription]: Gimme da camera
        [21] infoDictionary[NSMicrophoneUsageDescription]: Gimme da microphone
        [22] infoDictionary[NSSupportsAutomaticTermination]: 1
        [23] infoDictionary[NSSupportsSuddenTermination]: 1
        [24] infoDictionary[UIApplicationSupportsIndirectInputEvents]: 0
        [25] infoDictionary[UIDeviceFamily]: (
            2
        )
        [26] infoDictionary[UIStatusBarStyle]: 
        [27] infoDictionary[UISupportedInterfaceOrientations]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationPortraitUpsideDown,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [28] infoDictionary[UISupportedInterfaceOrientations~ipad]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationPortraitUpsideDown,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [29] infoDictionary[UISupportedInterfaceOrientations~iphone]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )

Bundle.module.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle> (not yet loaded)
    bundleIdentifier: vwwutility.BaseUtility.resources
    bundleURL file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/Resources/
    executableURL? <nil>
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug-maccatalyst/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/_MASReceipt/receipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleIdentifier]: vwwutility.BaseUtility.resources
        [3] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [4] infoDictionary[CFBundleName]: VWWUtility_BaseUtility
        [5] infoDictionary[CFBundlePackageType]: BNDL
        [6] infoDictionary[CFBundleSupportedPlatforms]: (
            MacOSX
        )
        [7] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [8] infoDictionary[DTPlatformBuild]: 24C94
        [9] infoDictionary[DTPlatformName]: macosx
        [10] infoDictionary[DTPlatformVersion]: 15.2
        [11] infoDictionary[DTSDKBuild]: 24C94
        [12] infoDictionary[DTSDKName]: macosx15.2
        [13] infoDictionary[DTXcode]: 1620
        [14] infoDictionary[DTXcodeBuild]: 16C5032a
        [15] infoDictionary[LSMinimumSystemVersion]: 14.0
        [16] infoDictionary[UIDeviceFamily]: (
            2,
            6
        )
```

## macNative

A macOS app running on macOS.

```log
#if os(macOS): true
#if canImport(AppKit): true
#if os(iOS): false
#if canImport(UIKit): false
#if targetEnvironment(simulator): false
#if targetEnvironment(macCatalyst): false

ProcessInfo.processInfo.isiOSAppOnMac: false
ProcessInfo.processInfo.isMacCatalystApp: false
ProcessInfo.processInfo.hostName: zakkbookmax.local
ProcessInfo.processInfo.processName: CameraPreviewUI
ProcessInfo.processInfo.processIdentifier: 68293
ProcessInfo.processInfo.globallyUniqueString: B754CBE2-2D76-487F-8F76-21D8C9F76295-68293-00000EDE6885F504
ProcessInfo.processInfo.processorCount: 12
ProcessInfo.processInfo.activeProcessorCount: 12
ProcessInfo.processInfo.physicalMemory: 103079215104
ProcessInfo.processInfo.systemUptime: 681183.297468
ProcessInfo.processInfo.operatingSystem(): 5
ProcessInfo.processInfo.operatingSystemName(): NSMACHOperatingSystem
ProcessInfo.processInfo.operatingSystemVersionString: Version 15.1 (Build 24B5055e)
ProcessInfo.processInfo.operatingSystemVersion: 15.1.0
ProcessInfo.processInfo.thermalState: nominal
ProcessInfo.processInfo.isLowPowerModeEnabled: false

URLService.applicationDirURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data
URLService.applicationDirectoryURL.path: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test").path: /Users/zakkhoyt/Library/Group Containers/group.co.z2k.test
PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:
    [0] .adminApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
    [1] .allApplicationsDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Utilities
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [2] .allLibrariesDirectory: 
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
        /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [3] .applicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications
    [4] .applicationSupportDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Application Support
    [5] .cachesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Caches
    [6] .coreServiceDirectory: <nil>
    [7] .demoApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Applications/Demos
    [8] .desktopDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Desktop
    [9] .developerApplicationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer/Applications
    [10] .developerDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Developer
    [11] .documentationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Documentation
    [12] .documentDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Documents
    [13] .libraryDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library
    [14] .userDirectory: <nil>
    [15] .applicationScriptsDirectory: /Users/zakkhoyt/Library/Application Scripts/co.z2k.CameraPreviewUI
    [16] .autosavedInformationDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Autosave Information
    [17] .downloadsDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Downloads
    [18] .inputMethodsDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/Input Methods
    [19] .itemReplacementDirectory: <nil>
    [20] .moviesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Movies
    [21] .musicDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Music
    [22] .picturesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Pictures
    [23] .preferencePanesDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Library/PreferencePanes
    [24] .printerDescriptionDirectory: <nil>
    [25] .sharedPublicDirectory: /Users/zakkhoyt/Library/Containers/co.z2k.CameraPreviewUI/Data/Public
    [26] .trashDirectory: /Users/zakkhoyt/.Trash

Bundle.main.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app> (loaded)
    bundleIdentifier: co.z2k.CameraPreviewUI
    bundleURL file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/
    executableURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/MacOS/CameraPreviewUI
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/_MASReceipt/receipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleExecutable]: CameraPreviewUI
        [3] infoDictionary[CFBundleIdentifier]: co.z2k.CameraPreviewUI
        [4] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [5] infoDictionary[CFBundleName]: CameraPreviewUI
        [6] infoDictionary[CFBundleNumericVersion]: 16809984
        [7] infoDictionary[CFBundlePackageType]: APPL
        [8] infoDictionary[CFBundleShortVersionString]: 1.0
        [9] infoDictionary[CFBundleSupportedPlatforms]: (
            MacOSX
        )
        [10] infoDictionary[CFBundleVersion]: 1
        [11] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [12] infoDictionary[DTPlatformBuild]: 24C94
        [13] infoDictionary[DTPlatformName]: macosx
        [14] infoDictionary[DTPlatformVersion]: 15.2
        [15] infoDictionary[DTSDKBuild]: 24C94
        [16] infoDictionary[DTSDKName]: macosx15.2
        [17] infoDictionary[DTXcode]: 1620
        [18] infoDictionary[DTXcodeBuild]: 16C5032a
        [19] infoDictionary[LSMinimumSystemVersion]: 15.1
        [20] infoDictionary[NSCameraUsageDescription]: Gimme da camera
        [21] infoDictionary[NSMicrophoneUsageDescription]: Gimme da microphone
        [22] infoDictionary[UIApplicationSupportsIndirectInputEvents]: 0
        [23] infoDictionary[UIStatusBarStyle]: 
        [24] infoDictionary[UISupportedInterfaceOrientations~ipad]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationPortraitUpsideDown,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )
        [25] infoDictionary[UISupportedInterfaceOrientations~iphone]: (
            UIInterfaceOrientationPortrait,
            UIInterfaceOrientationLandscapeLeft,
            UIInterfaceOrientationLandscapeRight
        )

Bundle.module.debugSummary:
    description: NSBundle </Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle> (not yet loaded)
    bundleIdentifier: vwwutility.BaseUtility.resources
    bundleURL file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/
    resourceURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/Resources/
    executableURL? <nil>
    privateFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/Frameworks/
    sharedFrameworksURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/SharedFrameworks/
    sharedSupportURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/SharedSupport/
    builtInPlugInsURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/PlugIns/
    appStoreReceiptURL? file:///Users/zakkhoyt/Library/Developer/Xcode/DerivedData/FileVault-crrtlmaoibqaywdlzhfjgxpxixmm/Build/Products/Debug/CameraPreviewUI.app/Contents/Resources/VWWUtility_BaseUtility.bundle/Contents/_MASReceipt/receipt
    infoDictionary:
        [0] infoDictionary[BuildMachineOSBuild]: 24B5055e
        [1] infoDictionary[CFBundleDevelopmentRegion]: en
        [2] infoDictionary[CFBundleIdentifier]: vwwutility.BaseUtility.resources
        [3] infoDictionary[CFBundleInfoDictionaryVersion]: 6.0
        [4] infoDictionary[CFBundleName]: VWWUtility_BaseUtility
        [5] infoDictionary[CFBundlePackageType]: BNDL
        [6] infoDictionary[CFBundleSupportedPlatforms]: (
            MacOSX
        )
        [7] infoDictionary[DTCompiler]: com.apple.compilers.llvm.clang.1_0
        [8] infoDictionary[DTPlatformBuild]: 24C94
        [9] infoDictionary[DTPlatformName]: macosx
        [10] infoDictionary[DTPlatformVersion]: 15.2
        [11] infoDictionary[DTSDKBuild]: 24C94
        [12] infoDictionary[DTSDKName]: macosx15.2
        [13] infoDictionary[DTXcode]: 1620
        [14] infoDictionary[DTXcodeBuild]: 16C5032a
        [15] infoDictionary[LSMinimumSystemVersion]: 14.0
```









