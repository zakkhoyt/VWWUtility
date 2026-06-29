# Files and Directories on iOS

## Using Files and Directories in iOS
Applications and application extensions generally read/write files to/from 2 places:
* Application Sandbox
* A Shared App Group






## Application Sandbox

An application stores its files in a directory known as the ***application sandbox***. This is a directory which is private to the app itself.
```
.
├── Documents/ # Log files, any other files you might want to write directly (json, xml, yaml, etc...)
├── Library/ # Caches, Preferences, etc... UserDefaults are stored under here
├── StoreKit/ # system
├── SystemData/ # system
└── tmp/ # system
```

### Directories by Platform
The directory path for ***application sandbox*** varies by platform. Here are some examples:
* iOS Hardware: `/var/mobile/Containers/Data/Application/\(UUID)`
* iOS Simulator: `~/Library/Developer/CoreSimulator/Devices/\(UUID)/data/Containers/Data/Application/\(UUID)`
* Mac (iOS App): `~/Library/Containers/\(UUID)/Data`

### Files
A few examples of files stored in the ***application sandbox***:
* `UserDefaults.standard` data is stored in the ***application sandbox*** under `\(appSandboxURL)/Library/Preferences/\(Bundle.main.bundleIdentifier!).plist`
* `Logger` log files are stored in the ***application sandbox*** under: `\(appSandboxURL)/Documents/\(dateStamp).log`










## App Group (Shared)

Sometimes it may be useful for apps/extensions to share data. Apps cannot read data each others sandboxes but they *can* read from a shared `App Group`. This is a directory which is similar to an application sandbox with more open permission.

### Directories by Platform
Again, the directory path for an ***app group*** varies by platform. Here are some examples:
* iOS Hardware: `/private/var/mobile/Containers/Shared/AppGroup/\(UUID)`
* iOS Simulator: `~/Library/Developer/CoreSimulator/Devices/\(UUID)/data/Containers/Shared/AppGroup/\(UUID)`
* Mac iOS App: ` ~/Library/GroupContainersAlias/group.\(Bundle.main.bundleIdentifier!)`

### Files
A few examples of files stored in the ***app group***:
* `UserDefaults.appGroup` stores data in a shared ***app group*** under `\(appGroupURL)/Library/Preferences/group.\(Bundle.main.bundleIdentifier!).plist`
* `CoreDataService` stores its data in a shared ***app group*** under: `\(appGroupURL)/Nightlight.sqlite`

