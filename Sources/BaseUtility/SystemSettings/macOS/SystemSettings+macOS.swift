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
            WiFi.self,
            Bluetooth.self,
            Network.self,
            Notifications.self,
            Sound.self,
            Focus.self,
            ScreenTime.self,
//            General.self,
            Appearance.self,
            Accessibility.self,
            ControlCenter.self,
            SiriSpotlight.self,
            PrivacySecurity.self,
            DesktopDock.self,
            Displays.self,
            Wallpaper.self,
            ScreenSaver.self,
            Battery.self,
            LockScreen.self,
            TouchIdPassword.self,
            UsersGroups.self,
            Passwords.self,
            InternetAccounts.self,
            GameCenter.self,
            WalletApplePay.self,
            Keyboard.self,
            Trackpad.self,
            GameControllers.self,
            PrintersScanners.self,
            
            Legacy.ControlCenter.self,
            Legacy.Network.self,
            Legacy.WiFi.self,
            Legacy.SoftwareUpdate.self,
            Legacy.Accessibility.self,
            Legacy.PrivacyAndSecurity.self,
            Legacy.Dictation.self,
            Legacy.Sharing.self

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
/// on mapAnchors(prefix, anchors)
///     set newList to {}
///     repeat with i from 1 to count of anchors
///         set anchor to item i of anchors
///         set newAnchor to "case " & anchor & " = " & "\"" & prefix & "&" & anchor & "\""
///         set end of newList to newAnchor
///     end repeat
///     return newList
/// end mapAnchors
///
/// tell application "System Settings"
///     set AppleScript's text item delimiters to return
///     set CurrentPaneName to the name of the current pane
///     set CurrentPane to the id of the current pane
///     get the name of every anchor of pane id CurrentPane
///     set CurrentAnchors to get the name of every anchor of pane id CurrentPane
///     set prefix to "x-apple.systempreferences:" & CurrentPane
///     set CurrentAnchors to my mapAnchors(prefix, CurrentAnchors)
///     set SwiftEnum to "enum " & CurrentPaneName & ": String, SystemSettingsURLProvider {" & return & CurrentAnchors & return & "}"
///     set the clipboard to SwiftEnum
///     display dialog "Swift enum copied to clipbaord" & return & return & SwiftEnum
/// end tell
/// ```
extension SystemSettings {
    public enum Legacy {
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
    
    enum WiFi: String, SystemSettingsURLProvider {
        case advanced = "x-apple.systempreferences:com.apple.wifi-settings-extension&Advanced"
        case generalDetails = "x-apple.systempreferences:com.apple.wifi-settings-extension&General_Details"
        case generalJoin = "x-apple.systempreferences:com.apple.wifi-settings-extension&General_Join"
        case generalMain = "x-apple.systempreferences:com.apple.wifi-settings-extension&General_Main"
    }
    
    enum Bluetooth: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.BluetoothSettings&Main"
    }
    
    enum Network: String, SystemSettingsURLProvider {
        case _6to4 = "x-apple.systempreferences:com.apple.Network-Settings.extension&6to4"
        case _802_1X = "x-apple.systempreferences:com.apple.Network-Settings.extension&802.1X"
        case advancedEthernet = "x-apple.systempreferences:com.apple.Network-Settings.extension&Advanced Ethernet"
        case advancedModem = "x-apple.systempreferences:com.apple.Network-Settings.extension&Advanced Modem"
        case advancedVpn = "x-apple.systempreferences:com.apple.Network-Settings.extension&Advanced VPN"
        case advancedWiFi = "x-apple.systempreferences:com.apple.Network-Settings.extension&Advanced Wi-Fi"
        case bluetooth = "x-apple.systempreferences:com.apple.Network-Settings.extension&Bluetooth"
        case bond = "x-apple.systempreferences:com.apple.Network-Settings.extension&Bond"
        case dns = "x-apple.systempreferences:com.apple.Network-Settings.extension&DNS"
        case ethernet = "x-apple.systempreferences:com.apple.Network-Settings.extension&Ethernet"
        case firewall = "x-apple.systempreferences:com.apple.Network-Settings.extension&Firewall"
        case modem = "x-apple.systempreferences:com.apple.Network-Settings.extension&Modem"
        case network = "x-apple.systempreferences:com.apple.Network-Settings.extension&Network"
        case ppp = "x-apple.systempreferences:com.apple.Network-Settings.extension&PPP"
        case ppPoE = "x-apple.systempreferences:com.apple.Network-Settings.extension&PPPoE"
        case proxies = "x-apple.systempreferences:com.apple.Network-Settings.extension&Proxies"
        case tcpIp = "x-apple.systempreferences:com.apple.Network-Settings.extension&TCP/IP"
        case thunderbolt = "x-apple.systempreferences:com.apple.Network-Settings.extension&Thunderbolt"
        case vlan = "x-apple.systempreferences:com.apple.Network-Settings.extension&VLAN"
        case vpn = "x-apple.systempreferences:com.apple.Network-Settings.extension&VPN"
        case vpnOnDemand = "x-apple.systempreferences:com.apple.Network-Settings.extension&VPN on Demand"
        case virtualInterfaces = "x-apple.systempreferences:com.apple.Network-Settings.extension&VirtualInterfaces"
        case wins = "x-apple.systempreferences:com.apple.Network-Settings.extension&WINS"
        case wwan = "x-apple.systempreferences:com.apple.Network-Settings.extension&WWAN"
    }
    
    enum Notifications: String, SystemSettingsURLProvider {
        case notifications = "x-apple.systempreferences:com.apple.Notifications-Settings.extension&Notifications"
    }
    
    enum Sound: String, SystemSettingsURLProvider {
        case balance = "x-apple.systempreferences:com.apple.Sound-Settings.extension&balance"
        case effects = "x-apple.systempreferences:com.apple.Sound-Settings.extension&effects"
        case input = "x-apple.systempreferences:com.apple.Sound-Settings.extension&input"
        case mute = "x-apple.systempreferences:com.apple.Sound-Settings.extension&mute"
        case output = "x-apple.systempreferences:com.apple.Sound-Settings.extension&output"
        case volume = "x-apple.systempreferences:com.apple.Sound-Settings.extension&volume"
    }
    
    enum Focus: String, SystemSettingsURLProvider {
        case focus = "x-apple.systempreferences:com.apple.Focus-Settings.extension&Focus"
    }
    
    enum ScreenTime: String, SystemSettingsURLProvider {
        case pathAlwaysAllowed = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=always-allowed"
        case pathAppLimits = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=app-limits"
        case pathAppUsage = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=app-usage"
        case pathCommunicationLimits = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=communication-limits"
        case pathContentAndPrivacy = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=content-and-privacy"
        case pathDowntime = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=downtime"
        case pathNotifications = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=notifications"
        case pathPickups = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=pickups"
        case pathRequests = "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension&path=requests"
    }
    
//    enum General: String, SystemSettingsURLProvider {
//        
//    }
    
    enum Appearance: String, SystemSettingsURLProvider {
        case main = "x-apple.systempreferences:com.apple.Appearance-Settings.extension&Main"
    }
    
    enum Accessibility: String, SystemSettingsURLProvider {
        case axAltMouseButtons = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_BUTTONS"
        case axAltMouseEnableSounds = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_ENABLE_SOUNDS"
        case axAltMouseEnableVisuals = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ALT_MOUSE_ENABLE_VISUALS"
        case axAnimatedImages = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ANIMATED_IMAGES"
        case axBackgroundSounds = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BACKGROUND_SOUNDS"
        case axBackgroundSoundsLockScreen = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BACKGROUND_SOUNDS_LOCK_SCREEN"
        case axBackgroundSoundsVolume = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BACKGROUND_SOUNDS_VOLUME"
        case axBgSoundSelectHeader = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_BG_SOUND_SELECT_HEADER"
        case axCaptioningPreferSdh = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_CAPTIONING_PREFER_SDH"
        case axConfigureCamera = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_CONFIGURE_CAMERA"
        case axCursorSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_CURSOR_SIZE"
        case axDifferentiateWithoutColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DIFFERENTIATE_WITHOUT_COLOR"
        case axDimFlashing = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DIM_FLASHING"
        case axDisplayFilterEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DISPLAY_FILTER_ENABLED"
        case axDisplayFilterIntensity = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DISPLAY_FILTER_INTENSITY"
        case axDisplayFilterTintColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DISPLAY_FILTER_TINT_COLOR"
        case axDisplayFilterType = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DISPLAY_FILTER_TYPE"
        case axDwellAction = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_ACTION"
        case axDwellAutoRevert = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_AUTO_REVERT"
        case axDwellCursorColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_CURSOR_COLOR"
        case axDwellInPanels = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_IN_PANELS"
        case axDwellProgressIndicator = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_PROGRESS_INDICATOR"
        case axDwellRetriggerTolerance = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_RETRIGGER_TOLERANCE"
        case axDwellTolerance = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_TOLERANCE"
        case axDwellWaitTime = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_WAIT_TIME"
        case axDwellWaitTimeHome = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_WAIT_TIME_HOME"
        case axDwellZoom = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_ZOOM"
        case axDwellZoomWait = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_DWELL_ZOOM_WAIT"
        case axEnhanceContrast = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ENHANCE_CONTRAST"
        case axFacetimeTranscriptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FACETIME_TRANSCRIPTIONS"
        case axFeatureAudio = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_AUDIO"
        case axFeatureCaptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_CAPTIONS"
        case axFeatureDescriptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_DESCRIPTIONS"
        case axFeatureHearingaids = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_HEARINGAIDS"
        case axFeatureKeyboard = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_KEYBOARD"
        case axFeaturePersonalvoice = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_PERSONALVOICE"
        case axFeaturePointercontrol = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_POINTERCONTROL"
        case axFeatureShortcut = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_SHORTCUT"
        case axFeatureSiri = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_SIRI"
        case axFeatureSpokencontent = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_SPOKENCONTENT"
        case axFeatureZoom = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FEATURE_ZOOM"
        case axFindCursor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FIND_CURSOR"
        case axFkaAutoHideCheckbox = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_AUTO_HIDE_CHECKBOX"
        case axFkaColorPopUp = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_COLOR_POP_UP"
        case axFkaCommandsRestoreDefaults = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_COMMANDS_RESTORE_DEFAULTS"
        case axFkaEnableCheckbox = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_ENABLE_CHECKBOX"
        case axFkaHighContrastCheckbox = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_HIGH_CONTRAST_CHECKBOX"
        case axFkaIncreaseSizeCheckbox = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FKA_INCREASE_SIZE_CHECKBOX"
        case axFlashScreen = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FLASH_SCREEN"
        case axFontSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_FONT_SIZE"
        case axHeadphoneHoldDuration = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEADPHONE_HOLD_DURATION"
        case axHeadphoneNoiseCancel = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEADPHONE_NOISE_CANCEL"
        case axHeadphonePressSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEADPHONE_PRESS_SPEED"
        case axHeadphoneToneVolume = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEADPHONE_TONE_VOLUME"
        case axHeadMouse = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE"
        case axHeadMouseButton = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_BUTTON"
        case axHeadMouseMode = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_MODE"
        case axHeadMousePauseResume = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_PAUSE_RESUME"
        case axHeadMouseRecalibrate = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_RECALIBRATE"
        case axHeadMouseSensitivity = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_SENSITIVITY"
        case axHeadMouseTolerance = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HEAD_MOUSE_TOLERANCE"
        case axHomePanelDwellActions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOME_PANEL_DWELL_ACTIONS"
        case axHoverTextActivationLockMode = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_ACTIVATION_LOCK_MODE"
        case axHoverTextBgColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_BG_COLOR"
        case axHoverTextBorderColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_BORDER_COLOR"
        case axHoverTextElementColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_ELEMENT_COLOR"
        case axHoverTextEnable = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_ENABLE"
        case axHoverTextEntryLocation = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_ENTRY_LOCATION"
        case axHoverTextFgColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_FG_COLOR"
        case axHoverTextFontFamily = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_FONT_FAMILY"
        case axHoverTextFontSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_FONT_SIZE"
        case axHoverTextInsertionColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_INSERTION_COLOR"
        case axHoverTextModifier = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_HOVER_TEXT_MODIFIER"
        case axIgnoreTrackpad = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_IGNORE_TRACKPAD"
        case axIncreaseContrast = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_INCREASE_CONTRAST"
        case axInvertColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_INVERT_COLOR"
        case axInvertColorMode = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_INVERT_COLOR_MODE"
        case axInApp = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_IN_APP"
        case axKbAppearanceType = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_APPEARANCE_TYPE"
        case axKbAutoCapitalization = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_AUTO_CAPITALIZATION"
        case axKbAutoSpacing = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_AUTO_SPACING"
        case axKbHide = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_HIDE"
        case axKbHideStepper = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_HIDE_STEPPER"
        case axKbHideTransparency = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_HIDE_TRANSPARENCY"
        case axKbKeyAcceptedMouse = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_KEY_ACCEPTED_MOUSE"
        case axKbRightClick = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_RIGHT_CLICK"
        case axKbUseClickSounds = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_KB_USE_CLICK_SOUNDS"
        case axLiveSpeechEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_LIVE_SPEECH_ENABLED"
        case axLiveSpeechFontSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_LIVE_SPEECH_FONT_SIZE"
        case axLiveSpeechPreferredLanguage = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_LIVE_SPEECH_PREFERRED_LANGUAGE"
        case axLiveSpeechSavedPhrases = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_LIVE_SPEECH_SAVED_PHRASES"
        case axLiveSpeechVoiceSelection = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_LIVE_SPEECH_VOICE_SELECTION"
        case axMenubarDwellActions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MENUBAR_DWELL_ACTIONS"
        case axMenuFontSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MENU_FONT_SIZE"
        case axMonoAudio = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MONO_AUDIO"
        case axMouseDoubleClickSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_DOUBLE_CLICK_SPEED"
        case axMouseKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_KEYS"
        case axMouseKeysDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_KEYS_DELAY"
        case axMouseKeysIgnoreTrackpad = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_KEYS_IGNORE_TRACKPAD"
        case axMouseKeysShortcut = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_KEYS_SHORTCUT"
        case axMouseKeysSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_KEYS_SPEED"
        case axMouseOptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_OPTIONS"
        case axMouseScroll = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_SCROLL"
        case axMouseScrollBehavior = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_SCROLL_BEHAVIOR"
        case axMouseScrollSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_MOUSE_SCROLL_SPEED"
        case axNavigationTiming = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_NAVIGATION_TIMING"
        case axPlaySystemSounds = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_PLAY_SYSTEM_SOUNDS"
        case axPointerFillColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_POINTER_FILL_COLOR"
        case axPointerOutlineColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_POINTER_OUTLINE_COLOR"
        case axPointerResetColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_POINTER_RESET_COLOR"
        case axPrefersHorizTextLayout = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_PREFERS_HORIZ_TEXT_LAYOUT"
        case axReduceMotion = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_REDUCE_MOTION"
        case axReduceTransparency = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_REDUCE_TRANSPARENCY"
        case axRttEnable = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_RTT_ENABLE"
        case axRttRelayNumber = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_RTT_RELAY_NUMBER"
        case axRttSendImmediately = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_RTT_SEND_IMMEDIATELY"
        case axShowToolbarButtonShapes = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SHOW_TOOLBAR_BUTTON_SHAPES"
        case axShowWindowTitlebarIcons = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SHOW_WINDOW_TITLEBAR_ICONS"
        case axSlowKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SLOW_KEYS"
        case axSlowKeysDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SLOW_KEYS_DELAY"
        case axSlowKeysSound = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SLOW_KEYS_SOUND"
        case axSoundBrownNoise = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.BrownNoise"
        case axSoundOcean = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.Ocean"
        case axSoundPinkNoise = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.PinkNoise"
        case axSoundRain = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.Rain"
        case axSoundStream = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.Stream"
        case axSoundWhiteNoise = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SOUND.WhiteNoise"
        case axSpatialAudioFollowsHead = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPATIAL_AUDIO_FOLLOWS_HEAD"
        case axSpeechDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPEECH_DELAY"
        case axSpeechPhrase = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPEECH_PHRASE"
        case axSpeechTest = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPEECH_TEST"
        case axSpeechVoices = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPEECH_VOICES"
        case axSpokenAlerts = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_ALERTS"
        case axSpokenHotkey = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_HOTKEY"
        case axSpokenLanguage = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_LANGUAGE"
        case axSpokenPlay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_PLAY"
        case axSpokenPointerElement = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_POINTER_ELEMENT"
        case axSpokenPointerElementDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_POINTER_ELEMENT_DELAY"
        case axSpokenPointerElementMode = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_POINTER_ELEMENT_MODE"
        case axSpokenPointerElementVerbosity = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_POINTER_ELEMENT_VERBOSITY"
        case axSpokenRate = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_RATE"
        case axSpokenSelectionHighlightContent = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_HIGHLIGHT_CONTENT"
        case axSpokenSelectionHighlightSentenceColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_HIGHLIGHT_SENTENCE_COLOR"
        case axSpokenSelectionHighlightSentenceStyle = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_HIGHLIGHT_SENTENCE_STYLE"
        case axSpokenSelectionHighlightWordColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_HIGHLIGHT_WORD_COLOR"
        case axSpokenSelectionHotkey = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_HOTKEY"
        case axSpokenSelectionShowController = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_SELECTION_SHOW_CONTROLLER"
        case axSpokenTypingEcho = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_TYPING_ECHO"
        case axSpokenTypingEchoChars = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_TYPING_ECHO_CHARS"
        case axSpokenTypingEchoModifierKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_TYPING_ECHO_MODIFIER_KEYS"
        case axSpokenTypingEchoSelection = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_TYPING_ECHO_SELECTION"
        case axSpokenTypingEchoWords = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_TYPING_ECHO_WORDS"
        case axSpokenVoice = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_VOICE"
        case axSpokenVolume = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPOKEN_VOLUME"
        case axSpringLoading = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPRING_LOADING"
        case axSpringLoadingDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SPRING_LOADING_DELAY"
        case axStickyKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_STICKY_KEYS"
        case axStickyKeysBeep = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_STICKY_KEYS_BEEP"
        case axStickyKeysDisplay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_STICKY_KEYS_DISPLAY"
        case axStickyKeysDisplayLocation = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_STICKY_KEYS_DISPLAY_LOCATION"
        case axStickyKeysShortcut = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_STICKY_KEYS_SHORTCUT"
        case axSwitchAutoscan = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_AUTOSCAN"
        case axSwitchAutoCapitalization = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_AUTO_CAPITALIZATION"
        case axSwitchAutoSpacing = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_AUTO_SPACING"
        case axSwitchCoalesce = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_COALESCE"
        case axSwitchControlAppearanceType = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_CONTROL_APPEARANCE_TYPE"
        case axSwitchControlEnable = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_CONTROL_ENABLE"
        case axSwitchControlPlatformSwitching = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_CONTROL_PLATFORM_SWITCHING"
        case axSwitchCursorSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_CURSOR_SIZE"
        case axSwitchCursorSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_CURSOR_SPEED"
        case axSwitchElementSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_ELEMENT_SPEED"
        case axSwitchFirstItemDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_FIRST_ITEM_DELAY"
        case axSwitchHideAfterDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_HIDE_AFTER_DELAY"
        case axSwitchHideAfterDelayAmount = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_HIDE_AFTER_DELAY_AMOUNT"
        case axSwitchHoverTextToolbar = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_HOVER_TEXT_TOOLBAR"
        case axSwitchMinDuration = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_MIN_DURATION"
        case axSwitchMouseCursorEdge = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_MOUSE_CURSOR_EDGE"
        case axSwitchMouseMoveStyle = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_MOUSE_MOVE_STYLE"
        case axSwitchNavFeedback = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_NAV_FEEDBACK"
        case axSwitchPanelEditor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_PANEL_EDITOR"
        case axSwitchRepeatHold = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_REPEAT_HOLD"
        case axSwitchResumeAutoScanning = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_RESUME_AUTO_SCANNING"
        case axSwitchScanCycle = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_SCAN_CYCLE"
        case axSwitchScanRestart = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_SCAN_RESTART"
        case axSwitchScanSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_SCAN_SPEED"
        case axSwitchTiming = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SWITCH_TIMING"
        case axSystemTranscriptionBackgroundColorMain = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SYSTEM_TRANSCRIPTION_BACKGROUND_COLOR_MAIN"
        case axSystemTranscriptionEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SYSTEM_TRANSCRIPTION_ENABLED"
        case axSystemTranscriptionTextColorMain = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SYSTEM_TRANSCRIPTION_TEXT_COLOR_MAIN"
        case axSystemTranscriptionTextFontFamilyMain = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SYSTEM_TRANSCRIPTION_TEXT_FONT_FAMILY_MAIN"
        case axSystemTranscriptionTextFontSizeMain = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_SYSTEM_TRANSCRIPTION_TEXT_FONT_SIZE_MAIN"
        case axTouchBarZoomEnable = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TOUCH_BAR_ZOOM_ENABLE"
        case axTrackpadDragging = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_DRAGGING"
        case axTrackpadDraggingBehavior = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_DRAGGING_BEHAVIOR"
        case axTrackpadOptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_OPTIONS"
        case axTrackpadScroll = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_SCROLL"
        case axTrackpadScrollBehavior = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_SCROLL_BEHAVIOR"
        case axTrackpadScrollSpeed = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TRACKPAD_SCROLL_SPEED"
        case axTypeToSiriEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_TYPE_TO_SIRI_ENABLED"
        case axVirtualKeyboard = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VIRTUAL_KEYBOARD"
        case axVirtualKeyboardPanelEditor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VIRTUAL_KEYBOARD_PANEL_EDITOR"
        case axVoiceoverEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICEOVER_ENABLED"
        case axVoiceControlCommands = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_COMMANDS"
        case axVoiceControlEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_ENABLED"
        case axVoiceControlLanguage = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_LANGUAGE"
        case axVoiceControlMic = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_MIC"
        case axVoiceControlOpenTraining = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_OPEN_TRAINING"
        case axVoiceControlOverlay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_OVERLAY"
        case axVoiceControlOverlayFadingEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_OVERLAY_FADING_ENABLED"
        case axVoiceControlPlaySoundEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_PLAY_SOUND_ENABLED"
        case axVoiceControlShowHintsEnabled = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_SHOW_HINTS_ENABLED"
        case axVoiceControlVocabulary = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_CONTROL_VOCABULARY"
        case axVoiceOptionCommandsDeleteAll = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_COMMANDS_DELETE_ALL"
        case axVoiceOptionCommandsExport = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_COMMANDS_EXPORT"
        case axVoiceOptionCommandsImport = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_COMMANDS_IMPORT"
        case axVoiceOptionVocabDeleteAll = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_VOCAB_DELETE_ALL"
        case axVoiceOptionVocabExport = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_VOCAB_EXPORT"
        case axVoiceOptionVocabImport = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VOICE_OPTION_VOCAB_IMPORT"
        case axVoOpenTraining = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VO_OPEN_TRAINING"
        case axVoOpenUtility = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_VO_OPEN_UTILITY"
        case axZoomAdjustSize = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_ADJUST_SIZE"
        case axZoomChooseDisplay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_CHOOSE_DISPLAY"
        case axZoomDisableUniversalControl = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_DISABLE_UNIVERSAL_CONTROL"
        case axZoomEnableGesture = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_ENABLE_GESTURE"
        case axZoomEnableHotkeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_ENABLE_HOTKEYS"
        case axZoomFlash = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FLASH"
        case axZoomFocusMovement = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FOCUS_MOVEMENT"
        case axZoomFocusMovementDelay = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FOCUS_MOVEMENT_DELAY"
        case axZoomFollowFocusActivation = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FOLLOW_FOCUS_ACTIVATION"
        case axZoomFollowFocusMode = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FOLLOW_FOCUS_MODE"
        case axZoomFreezePanning = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_FREEZE_PANNING"
        case axZoomGestureField = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_GESTURE_FIELD"
        case axZoomInvert = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_INVERT"
        case axZoomKeepStationary = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_KEEP_STATIONARY"
        case axZoomMaxFactor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_MAX_FACTOR"
        case axZoomMinFactor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_MIN_FACTOR"
        case axZoomMonitorSelection = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_MONITOR_SELECTION"
        case axZoomMonitorSelectionTrackpad = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_MONITOR_SELECTION_TRACKPAD"
        case axZoomMove = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_MOVE"
        case axZoomRapid = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_RAPID"
        case axZoomResizeShortcuts = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_RESIZE_SHORTCUTS"
        case axZoomRestore = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_RESTORE"
        case axZoomRestoreShortcut = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_RESTORE_SHORTCUT"
        case axZoomSmooth = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_SMOOTH"
        case axZoomStylePopup = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_STYLE_POPUP"
        case axZoomTempDetach = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_TEMP_DETACH"
        case axZoomTempToggle = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_TEMP_TOGGLE"
        case axZoomToggleFsAndPip = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_TOGGLE_FS_AND_PIP"
        case axZoomTrackpad = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_ZOOM_TRACKPAD"
        case axFeatureAlternateMouseButtons = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.alternateMouseButtons"
        case axFeatureDisplayFilters = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.displayFilters"
        case axFeatureFullKeyboardAccess = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.fullKeyboardAccess"
        case axFeatureHeadMouse = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.headMouse"
        case axFeatureIncreaseContrast = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.increaseContrast"
        case axFeatureInvertDisplayColor = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.invertDisplayColor"
        case axFeatureLiveSpeech = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.liveSpeech"
        case axFeatureMouseKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.mouseKeys"
        case axFeatureReduceTransparency = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.reduceTransparency"
        case axFeatureSlowKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.slowKeys"
        case axFeatureStickyKeys = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.stickyKeys"
        case axFeatureSwitchControl = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.switchControl"
        case axFeatureSystemTranscriptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.systemTranscriptions"
        case axFeatureVirtualKeyboard = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.virtualKeyboard"
        case axFeatureVoiceControl = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.voiceControl"
        case axFeatureVoiceOver = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.voiceOver"
        case axFeatureZoom2 = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&AX_feature.zoom"
        case alternateControlMethods = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&alternateControlMethods"
        case display = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&display"
        case fullKeyboardAccessOptions = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&fullKeyboardAccessOptions"
        case headphones = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&headphones"
        case hoverTextColors = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&hoverTextColors"
        case hoverTextSettings = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&hoverTextSettings"
        case mouseAndTrackpad = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&mouseAndTrackpad"
        case pointer = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&pointer"
        case switchControlNavigation = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&switchControlNavigation"
        case switchControlSwitches = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&switchControlSwitches"
        case switchControlTyping = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&switchControlTyping"
        case virtualKeyboardDwell = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&virtualKeyboardDwell"
        case virtualKeyboardHotCorners = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&virtualKeyboardHotCorners"
        case zoomAppearance = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&zoomAppearance"
        case zoomControls = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&zoomControls"
        case zoomFollowFocus = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&zoomFollowFocus"
        case zoomHotkeyConfig = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&zoomHotkeyConfig"
        case zoomTempModifiersConfig = "x-apple.systempreferences:com.apple.Accessibility-Settings.extension&zoomTempModifiersConfig"
    }
    
    enum ControlCenter: String, SystemSettingsURLProvider {
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
    
    enum SiriSpotlight: String, SystemSettingsURLProvider {
        case siri = "x-apple.systempreferences:com.apple.Siri-Settings.extension&Siri"
        case privacy = "x-apple.systempreferences:com.apple.Siri-Settings.extension&privacy"
        case searchResults = "x-apple.systempreferences:com.apple.Siri-Settings.extension&searchResults"
    }
    
    enum PrivacySecurity: String, SystemSettingsURLProvider {
        case advanced = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Advanced"
        case fileVault = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&FileVault"
        case lockdownMode = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&LockdownMode"
        case privacyAccessibility = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Accessibility"
        case privacyAdvertising = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Advertising"
        case privacyAllFiles = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_AllFiles"
        case privacyAnalytics = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Analytics"
        case privacyAppBundles = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_AppBundles"
        case privacyAudioCapture = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_AudioCapture"
        case privacyAutomation = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Automation"
        case privacyBluetooth = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Bluetooth"
        case privacyCalendars = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Calendars"
        case privacyCamera = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Camera"
        case privacyContacts = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Contacts"
        case privacyDevTools = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_DevTools"
        case privacyFilesAndFolders = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_FilesAndFolders"
        case privacyFocus = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Focus"
        case privacyHomeKit = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_HomeKit"
        case privacyListenEvent = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_ListenEvent"
        case privacyLocationServices = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_LocationServices"
        case privacyMedia = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Media"
        case privacyMicrophone = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Microphone"
        case privacyMotion = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Motion"
        case privacyNudityDetection = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_NudityDetection"
        case privacyPasskeyAccess = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_PasskeyAccess"
        case privacyPhotos = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Photos"
        case privacyReminders = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_Reminders"
        case privacyRemoteDesktop = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_RemoteDesktop"
        case privacyScreenCapture = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_ScreenCapture"
        case privacySpeechRecognition = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_SpeechRecognition"
        case privacySystemServices = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Privacy_SystemServices"
        case security = "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension&Security"
    }
    
    enum DesktopDock: String, SystemSettingsURLProvider {
        case applications = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Applications"
        case desktop = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Desktop"
        case dock = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Dock"
        case hotCorners = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&HotCorners"
        case missionControl = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&MissionControl"
        case shortcuts = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Shortcuts"
        case stageManager = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&StageManager"
        case widgets = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Widgets"
        case windows = "x-apple.systempreferences:com.apple.Desktop-Settings.extension&Windows"
    }
    
    enum Displays: String, SystemSettingsURLProvider {
        case advancedSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&advancedSection"
        case ambienceSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&ambienceSection"
        case arrangementSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&arrangementSection"
        case characteristicSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&characteristicSection"
        case displaysSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&displaysSection"
        case miscellaneousSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&miscellaneousSection"
        case nightShiftSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&nightShiftSection"
        case profileSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&profileSection"
        case resolutionSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&resolutionSection"
        case sidecarSection = "x-apple.systempreferences:com.apple.Displays-Settings.extension&sidecarSection"
    }
    
    enum Wallpaper: String, SystemSettingsURLProvider {
        case wallpaper = "x-apple.systempreferences:com.apple.Wallpaper-Settings.extension&Wallpaper"
    }
    
    enum ScreenSaver: String, SystemSettingsURLProvider {
        case screenSaverPref = "x-apple.systempreferences:com.apple.ScreenSaver-Settings.extension&ScreenSaverPref"
    }
    
    enum Battery: String, SystemSettingsURLProvider {
        case batteryhealth = "x-apple.systempreferences:com.apple.Battery-Settings.extension*BatteryPreferences&batteryhealth"
        case currentSource = "x-apple.systempreferences:com.apple.Battery-Settings.extension*BatteryPreferences&currentSource"
        case options = "x-apple.systempreferences:com.apple.Battery-Settings.extension*BatteryPreferences&options"
    }
    
    enum LockScreen: String, SystemSettingsURLProvider {
        case displayOff = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&DisplayOff"
        case largeClock = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&LargeClock"
        case lockScreenMessage = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&LockScreenMessage"
        case loginWindow = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&LoginWindow"
        case password = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&Password"
        case screenSaver = "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension&ScreenSaver"
    }
    
    enum TouchIdPassword: String, SystemSettingsURLProvider {
        case password = "x-apple.systempreferences:com.apple.Touch-ID-Settings.extension*TouchIDPasswordPrefs&Password"
        case touchId = "x-apple.systempreferences:com.apple.Touch-ID-Settings.extension*TouchIDPasswordPrefs&TouchID"
        case watch = "x-apple.systempreferences:com.apple.Touch-ID-Settings.extension*TouchIDPasswordPrefs&Watch"
    }
    
    enum UsersGroups: String, SystemSettingsURLProvider {
        case loginOptionsPref = "x-apple.systempreferences:com.apple.Users-Groups-Settings.extension&loginOptionsPref"
        case passwordPref = "x-apple.systempreferences:com.apple.Users-Groups-Settings.extension&passwordPref"
    }
    
    enum Passwords: String, SystemSettingsURLProvider {
        case options = "x-apple.systempreferences:com.apple.Passwords-Settings.extension&Options"
        case passwords = "x-apple.systempreferences:com.apple.Passwords-Settings.extension&Passwords"
        case security = "x-apple.systempreferences:com.apple.Passwords-Settings.extension&Security"
    }
    
    enum InternetAccounts: String, SystemSettingsURLProvider {
        case internetAccounts = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&InternetAccounts"
        case comAppleAccount_126 = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.126"
        case comAppleAccount_163 = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.163"
        case comAppleAccountExchange = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.Exchange"
        case comAppleAccountGoogle = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.Google"
        case comAppleAccountYahoo = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.Yahoo"
        case comAppleAccountAol = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.aol"
        case comAppleAccountQq = "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension&com.apple.account.qq"
    }
    
    enum GameCenter: String, SystemSettingsURLProvider {
        case gameCenterPane = "x-apple.systempreferences:com.apple.Game-Center-Settings.extension&GameCenterPane"
    }
    
    enum WalletApplePay: String, SystemSettingsURLProvider {
        case wallet = "x-apple.systempreferences:com.apple.WalletSettingsExtension&Wallet"
    }
    
    enum Keyboard: String, SystemSettingsURLProvider {
        case capsLockInputSources = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&CapsLockInputSources"
        case customizeModifierKeys = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&CustomizeModifierKeys"
        case dictation = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&Dictation"
        case functionKeys = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&FunctionKeys"
        case inputSources = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&InputSources"
        case keyboard = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&Keyboard"
        case languageInputMethods = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&LanguageInputMethods"
        case modifierKeys = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&ModifierKeys"
        case shortcuts = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&Shortcuts"
        case spelling = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&Spelling"
        case textReplacements = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&TextReplacements"
        case touchBarSettings = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&TouchBarSettings"
        case useSmartQuotes = "x-apple.systempreferences:com.apple.Keyboard-Settings.extension&UseSmartQuotes"
    }
    
    enum Trackpad: String, SystemSettingsURLProvider {
        case trackpadTab = "x-apple.systempreferences:com.apple.Trackpad-Settings.extension&trackpadTab"
    }
    
    enum GameControllers: String, SystemSettingsURLProvider {
        case gameControllers = "x-apple.systempreferences:com.apple.Game-Controller-Settings.extension&Game Controllers"
    }
    
    enum PrintersScanners: String, SystemSettingsURLProvider {
        case fax = "x-apple.systempreferences:com.apple.Print-Scan-Settings.extension&fax"
        case print = "x-apple.systempreferences:com.apple.Print-Scan-Settings.extension&print"
        case scan = "x-apple.systempreferences:com.apple.Print-Scan-Settings.extension&scan"
        case share = "x-apple.systempreferences:com.apple.Print-Scan-Settings.extension&share"
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
