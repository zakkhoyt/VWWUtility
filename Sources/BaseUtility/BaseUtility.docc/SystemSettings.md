# SystemSettings


TODO: This Article is WIP (incomplete)


# iOS

TODO: This section is WIP (incomplete)

Navigating the user to public settings (not app specific)
I (zakkhoyt) tested [this](https://stackoverflow.com/a/61383270/80388) and it works
(if using the syntax in one of the comments)
I have also same issue with iOS 14 but in my case it is resolved when i remove root prefix.
For example instead of
`"prefs:root=Privacy&path=LOCATION"`
I used
`"App-prefs:Privacy&path=LOCATION"`
and it works in iOS 14.

IE: `prefs:root=` -> `App-prefs:`## (Research)
```swift
guard let url = URL(string: "prefs:root=Bluetooth") else {
guard let url = URL(string: "prefs:root=Bluetooth") else { // short ulong warning //
guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { // ulog warning // https://stackoverflow.com/a/43090019/803882
guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI") else { // main settings app
guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI/\(bundleId)") else { // main settings app
guard let url = URL(string: "prefs:root=WIFI/\(bundleId)") else { // nothing
// iOS 14 comment https://stackoverflow.com/a/61383270/803882
// iOS 15 tested. Takes to general location services (apps listed as siblings)
//    guard let url = URL(string: "App-prefs:Privacy&path=LOCATION") else {
// iOS 15 tested. Takes to app specific locatoin service underneat general location services (not in the app settings directly)
guard let url = URL(string: "App-prefs:Privacy&path=LOCATION/\(bundleId)") else {
    preconditionFailure()
}
```
# macOS

TODO: This section is WIP (incomplete)

## Mining

> All this is possible thanks to key in Info.plist in preferencePane + CFBundleURLTypes (CFBundleURLSchemes) x-apple.systempreferences (Info.plist) in System Preferences.app

The `*.prefPane` bundles can be found under `/System/Library/PreferencePanes/`.
The Settings app: `/System/Applications/System Settings.app/`
## Opening

Open `*.prefPane` files on command line:

```sh
/usr/bin/open -b com.apple.systempreferences /System/Library/PreferencePanes/Security.prefPane
```

## References

* [URL Mining](https://stackoverflow.com/questions/6652598/cocoa-button-opens-a-system-preference-page/48139877#48139877)
* [Opening pref panes](https://forum.xojo.com/t/how-do-i-open-the-system-preferences-panel-on-a-particular-tab/70238/4)
* [gist listing pref panes and urls](https://gist.github.com/rmcdongit/f66ff91e0dad78d4d6346a75ded4b751#security--privacy-pane)
* [ventura settings list](https://github.com/piarasj/piarasj.github.io/blob/master/ventura_settings.md#ventura-system-settings)
* [10.10](https://www.mbsplugins.de/archive/2020-04-05/MacOS_System_Preference_Links)
* [scripting preferences](https://www.macosadventures.com/2022/02/06/scripting-system-preferences-panes/)
* [mining pref panes using apple script](https://www.macosadventures.com/2022/02/10/identifying-system-preferences-panes/)
## Example

```applescript
-- Open System Preferences.app and click into desired pane/setting. Then, run this script to find out name (Pane ID) and any anchors.

on mapAnchors(prefix, anchors)
	set newList to {}
	repeat with i from 1 to count of anchors
		set anchor to item i of anchors
		set newAnchor to "case " & anchor & " = " & "\"" & prefix & "&" & anchor & "\""
		set end of newList to newAnchor
	end repeat
	return newList
end mapAnchors

tell application "System Settings"
	set AppleScript's text item delimiters to ", "
	set CurrentPane to the id of the current pane
	display dialog CurrentPane
	-- log (CurrentPane)
	-- do shell script "echo The value: " & CurrentPane
	get the name of every anchor of pane id CurrentPane
	set CurrentAnchors to get the name of every anchor of pane id CurrentPane
	set prefix to "x-apple.systempreferences:" & CurrentPane
	set CurrentAnchors to my mapAnchors(prefix, CurrentAnchors)
	set the clipboard to prefix & "
" & CurrentAnchors
	display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "Current Anchors: " & return & (CurrentAnchors as string)
end tell



```
