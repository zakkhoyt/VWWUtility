//
//  SystemSettings+macOS.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//
//  https://apple.stackexchange.com/a/372303/270042
//  https://developer.apple.com/documentation/devicemanagement/systempreferences

#if os(macOS)
import AppKit
import ApplicationServices
import Foundation

public enum SystemSettings: SystemSettingsURLParticipant {
    @MainActor
    public static func open(
        _ provider: any SystemSettingsURLProvider,
        appSpecific: Bool = false
    ) {
        func open(
            url: URL
        ) {
            logger.debug("Opening url \(url.absoluteString)")
            NSWorkspace.shared.open(url)
        }
        open(
            url: appSpecific ? provider.appSpecificUrl : provider.url
        )
    }
    
    /// Represents enums nested under this namespace to represent "sections" of settings.
    public static var categories: [
        any SystemSettingsURLProvider.Type
    ] {
        [
            ControlCenter.self,
            Network.self,
            WiFi.self,
            SoftwareUpdate.self,
            Accessibility.self,
            PrivacyAndSecurity.self,
            Dictation.self,
            Sharing.self
        ]
    }
}

// MARK: - Nested types

#warning(
    """
    TODO: zakkhoyt - Document the struggle to validate
    * How to inspect values for myself? See SO posts.
    * How to modernize this list?
    * How to test these?
        * Document OSLog warnings/output
    * Different settings: General vs General (under app leaf) vs App Settings
    * Post back on forums to share work
    * Copy documentation to DocC Article
    """
)

/// # Mining
///
/// > All this is possible thanks to key in Info.plist in preferencePane + CFBundleURLTypes (CFBundleURLSchemes) x-apple.systempreferences (Info.plist) in System Preferences.app
///
/// The `*.prefPane` bundles can be found under `/System/Library/PreferencePanes/`.
/// The Settings app: `/System/Applications/System Settings.app/`
///
/// # Opening
///
/// Open `*.prefPane` files on command line:
///
/// ```sh
/// /usr/bin/open -b com.apple.systempreferences /System/Library/PreferencePanes/Security.prefPane
/// ```
///
///
/// ## References
///
/// * [URL Mining](https://stackoverflow.com/questions/6652598/cocoa-button-opens-a-system-preference-page/48139877#48139877)
/// * [Opening pref panes](https://forum.xojo.com/t/how-do-i-open-the-system-preferences-panel-on-a-particular-tab/70238/4)
/// * [gist listing pref panes and urls](https://gist.github.com/rmcdongit/f66ff91e0dad78d4d6346a75ded4b751#security--privacy-pane)
/// * [ventura settings list](https://github.com/piarasj/piarasj.github.io/blob/master/ventura_settings.md#ventura-system-settings)
/// * [10.10](https://www.mbsplugins.de/archive/2020-04-05/MacOS_System_Preference_Links)
/// * [scripting preferences](https://www.macosadventures.com/2022/02/06/scripting-system-preferences-panes/)
/// * [mining pref panes using apple script](https://www.macosadventures.com/2022/02/10/identifying-system-preferences-panes/)
///
/// ## Example
///
/// ```applescript
/// -- Open System Preferences.app and click into desired pane/setting. Then, run this script to find out name (Pane ID) and any anchors.
///
/// tell application "System Settings"
/// set AppleScript's text item delimiters to ", "
/// set CurrentPane to the id of the current pane
/// get the name of every anchor of pane id CurrentPane
/// set CurrentAnchors to get the name of every anchor of pane id CurrentPane
/// set the clipboard to "x-apple.systempreferences:" & CurrentPane & "
///     " & CurrentAnchors
/// display dialog "Current Pane ID: " & CurrentPane & return & return & "Pane ID has been copied to the clipboard." & return & return & "Current Anchors: " & return & (CurrentAnchors as string)
/// end tell
/// ```
extension SystemSettings {
    public enum ControlCenter: String, SystemSettingsURLProvider {
        case accessibilityShortcuts = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&AccessibilityShortcuts"
        case airDrop = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&AirDrop"
        case battery = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Battery"
        case bluetooth = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Bluetooth"
        case clock = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Clock"
        case display = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Display"
        case doNotDisturb = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&DoNotDisturb"
        case focusModes = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&FocusModes"
        case hearing = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Hearing"
        case keyboardBrightness = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&KeyboardBrightness"
        case menuBar = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&MenuBar"
        case musicRecognition = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&MusicRecognition"
        case nowPlaying = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&NowPlaying"
        case screenMirroring = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&ScreenMirroring"
        case siri = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Siri"
        case sound = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Sound"
        case spotlight = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&Spotlight"
        case stageManager = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&StageManager"
        case timeMachine = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&TimeMachine"
        case userSwitcher = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&UserSwitcher"
        case vpn = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&VPN"
        case wiFi = "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension&WiFi"
    }

    public enum SoftwareUpdate: String, SystemSettingsURLProvider {
        case softwareUpdate = "x-apple.systempreferences:com.apple.preferences.softwareupdate?client=softwareupdateapp"
    }
    
    // Accessibility Preference Pane
    public enum Accessibility: String, SystemSettingsURLProvider {
//        case zoom0 = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?AX_HOVER_TEXT_BG_COLOR" // no, root.
//        case zoom1 = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?AX_FEATURE_ZOOM" // works
//        case fullkeyboardAccess = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?fullKeyboardAccessOptions" // works
        
        case main = "x-apple.systempreferences:com.apple.preference.universalaccess"
        case display = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Display"
        case zoom = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Zoom"
        case voiceOver = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_VoiceOver"
        case descriptions = "x-apple.systempreferences:com.apple.preference.universalaccess?Media_Descriptions"
        case captions = "x-apple.systempreferences:com.apple.preference.universalaccess?Captioning"
        case audio = "x-apple.systempreferences:com.apple.preference.universalaccess?Hearing"
        case keyboard = "x-apple.systempreferences:com.apple.preference.universalaccess?Keyboard"
        case mouseTrackpad = "x-apple.systempreferences:com.apple.preference.universalaccess?Mouse"
        case switchControl = "x-apple.systempreferences:com.apple.preference.universalaccess?Switch"
        case dictation = "x-apple.systempreferences:com.apple.preference.universalaccess?SpeakableItems"
    }
    
    // Security & Privacy Preference Pane
    public enum PrivacyAndSecurity: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.preference.security"
        case general = "x-apple.systempreferences:com.apple.preference.security?General"
        case fileVault = "x-apple.systempreferences:com.apple.preference.security?FDE"
        case firewall = "x-apple.systempreferences:com.apple.preference.security?Firewall"
        case advanced = "x-apple.systempreferences:com.apple.preference.security?Advanced"
        case privacy = "x-apple.systempreferences:com.apple.preference.security?Privacy"
//        case privacyCamera = "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"
//        case privacyMicrophone = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
        case privacyAutomation = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
//        case privacyAllFiles = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        case privacyAccessibility = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        case privacyAssistive = "x-apple.systempreferences:com.apple.preference.security?Privacy_Assistive"
        case privacyLocationServices = "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
        case privacySystemServices = "x-apple.systempreferences:com.apple.preference.security?Privacy_SystemServices"
        case privacyAdvertising = "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"
//        case privacyContacts = "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
        case privacyDiagnosticsUsage = "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"
//        case privacyCalendars = "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
//        case privacyReminders = "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
        case privacyFacebook = "x-apple.systempreferences:com.apple.preference.security?Privacy_Facebook"
        case privacyLinkedIn = "x-apple.systempreferences:com.apple.preference.security?Privacy_LinkedIn"
        case privacyTwitter = "x-apple.systempreferences:com.apple.preference.security?Privacy_Twitter"
        case privacyWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_Weibo"
        case privacyTencentWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_TencentWeibo"
        
        // macOS Catalina 10.15:
//        case privacyScreenCapture = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
//        case privacyDevTools = "x-apple.systempreferences:com.apple.preference.security?Privacy_DevTools"
//        case privacyInputMonitoring = "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
        case privacyDesktopFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DesktopFolder"
        case privacyDocumentsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DocumentsFolder"
        case privacyDownloadsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DownloadsFolder"
        case privacyNetworkVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_NetworkVolume"
        case privacyRemovableVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_RemovableVolume"
//        case privacySpeechRecognition = "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition"
        
        // Mined in 14.2
        case privacyAllFiles = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        case privacyAppBundles = "x-apple.systempreferences:com.apple.preference.security?Privacy_AppBundles"
        case privacyBluetooth = "x-apple.systempreferences:com.apple.preference.security?Privacy_Bluetooth"
        case privacyCalendars = "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
        case privacyCamera = "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"
        case privacyContacts = "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
        case privacyDevTools = "x-apple.systempreferences:com.apple.preference.security?Privacy_DevTools"
        case privacyFocus = "x-apple.systempreferences:com.apple.preference.security?Privacy_Focus"
        case privacyHomeKit = "x-apple.systempreferences:com.apple.preference.security?Privacy_HomeKit"
        // AKA privacyListenEvent
        case privacyInputMonitoring = "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
        case privacyMedia = "x-apple.systempreferences:com.apple.preference.security?Privacy_Media"
        case privacyMicrophone = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
        case privacyReminders = "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
        case privacyScreenCapture = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
        case privacySpeechRecognition = "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition"
    }
    
    // Dictation & Speech Preference Pane
    public enum Dictation: String, SystemSettingsURLProvider {
        case dictation = "x-apple.systempreferences:com.apple.preference.speech?Dictation"
        case textToSpeech = "x-apple.systempreferences:com.apple.preference.speech?TTS"
    }
    
    public enum Network: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.Network-Settings.extension"
        case wifi0 = "x-apple.systempreferences:com.apple.Network-Settings.extension?Advanced Wi-Fi"
        case wifi1 = "x-apple.systempreferences:com.apple.Network-Settings.extension?Advanced_Wi-Fi"
        case firewall = "x-apple.systempreferences:com.apple.Network-Settings.extension?Firewall"
        case bluetooth = "x-apple.systempreferences:com.apple.Network-Settings.extension?Bluetooth"
    }

    public enum WiFi: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.wifi-settings-extension"
        case advanced = "x-apple.systempreferences:com.apple.wifi-settings-extension?Advanced"
        case generalDetails = "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Details"
        case generalJoin = "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Join"
        case generalMain = "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Main"
    }
    
    // Sharing Preference Pane
    public enum Sharing: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.preferences.sharing"
        case screenSharing = "x-apple.systempreferences:com.apple.preferences.sharing?Services_ScreenSharing"
        case fileSharing = "x-apple.systempreferences:com.apple.preferences.sharing?Services_PersonalFileSharing"
        case printerSharing = "x-apple.systempreferences:com.apple.preferences.sharing?Services_PrinterSharing"
        case remoteLogin = "x-apple.systempreferences:com.apple.preferences.sharing?Services_RemoteLogin"
        case remoteManagement = "x-apple.systempreferences:com.apple.preferences.sharing?Services_ARDService"
        case remoteAppleEvents = "x-apple.systempreferences:com.apple.preferences.sharing?Services_RemoteAppleEvent"
        case internetSharing = "x-apple.systempreferences:com.apple.preferences.sharing?Internet"
        case bluetoothSharing = "x-apple.systempreferences:com.apple.preferences.sharing?Services_BluetoothSharing"
    }
}

extension SystemSettings {
    public enum Error: Swift.Error {
        case noGlobalAuthorization
    }
    
    static func validateGlobalInputCapturable() throws {
        logger.debug("AXIsProcessTrusted: \(AXIsProcessTrusted())")
        guard AXIsProcessTrusted() else {
            //                let accessibilityUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            //                let inputMonitoringUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!
            //                NSWorkspace.shared.open(accessibilityUrl)
            
            logger.debug("TODO: Get user to add this app to accessibilty and input monitoring")
            throw Error.noGlobalAuthorization
            
            #warning("TODO: zakkhoyt - https://developer.apple.com/documentation/swiftui/settingslink")
            #warning("TODO: zakkhoyt - https://stackoverflow.com/questions/65355696/how-to-programatically-open-settings-preferences-window-in-a-macos-swiftui-app/72803389#72803389")
            // https://support.apple.com/guide/mac-help/change-privacy-security-settings-on-mac-mchl211c911f/mac
        }
        
        //                logger.debug("AXIsProcessTrusted: \(AXIsProcessTrusted())")
        //                guard AXIsProcessTrusted() else {
        //                    logger.debug("TODO: Get user to add this app to accessibilty and input monitoring")
        //                    throw Error.noGlobalAuthorization
        //
        // #warning("TODO: zakkhoyt - https://developer.apple.com/documentation/swiftui/settingslink")
        // #warning("TODO: zakkhoyt - https://stackoverflow.com/questions/65355696/how-to-programatically-open-settings-preferences-window-in-a-macos-swiftui-app/72803389#72803389")
        //                    // https://support.apple.com/guide/mac-help/change-privacy-security-settings-on-mac-mchl211c911f/mac
        //                }
        
        /// `NSEvent.addGlobalMonitorForEvents` will not work unless `AXIsProcessTrusted()` returns true
        /// `AXIsProcessTrusted()` will not return true unless the user adds this app to `Accessibilty` privacy list
        /// Finally `NSEvent.addGlobalMonitorForEvents` also needs the user to add this app to `Input Monitorying` privacy list.
    }

    //
    // #import "MJAccessibilityUtils.h"
    // #import "HSLogger.h"
//
    // extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
    // extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));
//
//
    // BOOL MJAccessibilityIsEnabled(void) {
//    BOOL isEnabled = NO;
//    if (AXIsProcessTrustedWithOptions != NULL)
//        isEnabled = AXIsProcessTrustedWithOptions(NULL);
//    else
//        #pragma clang diagnostic push
//        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        isEnabled = AXAPIEnabled();
//    #pragma clang diagnostic pop
//
//    HSNSLOG(@"Accessibility is: %@", isEnabled ? @"ENABLED" : @"DISABLED");
//    return isEnabled;
    // }
//
    // void MJAccessibilityOpenPanel(void) {
//    if (AXIsProcessTrustedWithOptions != NULL) {
//        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge id)kAXTrustedCheckOptionPrompt: @YES});
//    }
//    else {
//        static NSString* script = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell";
//        [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
//    }
    // }
}
#endif
