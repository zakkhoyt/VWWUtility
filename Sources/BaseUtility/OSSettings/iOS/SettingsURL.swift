
// https://stackoverflow.com/a/35987082/803882
// https://stackoverflow.com/a/8246814/803882



// https://www.macstories.net/ios/a-comprehensive-guide-to-all-120-settings-urls-supported-by-ios-and-ipados-13-1/
// https://forums.macrumors.com/threads/manually-creating-settings-launchers-in-app-launching-apps.2037291/
// https://developer.apple.com/documentation/uikit/uiapplication/4013180-opennotificationsettingsurlstrin

// https://www.icloud.com/shortcuts/381d0ab479dc4808bf16f47b738cc526

#if os(iOS)
import Foundation
import UIKit

public protocol SettingsURLSuffixProvider: CaseIterable, RawRepresentable where RawValue == String {
    associatedtype rawValue = String
    var suffix: String { get }
}

extension SettingsURLSuffixProvider {
    public var suffix: String {
        self.rawValue
    }
    
    public var url: URL {

        guard let bundleId = Bundle.main.bundleIdentifier,
            //  let url = URL(string: "\(UIApplication.openSettingsURLString)&\(self.rawValue)/\(bundleId)")
             let url = URL(string: "\(self.rawValue)/\(bundleId)")
            //   let url = URL(string: "\(self.rawValue)")
        else {
            preconditionFailure("Must be able to get app settings url")
        }
        
        // prefs:root=Privacy&path=LOCATION
        return url

    }
}

public enum SettingsApp {
    public static func open(
        _ provider: any SettingsURLSuffixProvider
    ) {
//        guard let bundleId = Bundle.main.bundleIdentifier,
//              let url = URL(string: "\(UIApplication.openSettingsURLString)&\(provider.suffix)/\(bundleId)")
//        else {
//            assertionFailure("Must be able to get app settings url")
//            return
//        }
        
        UIApplication.shared.open(provider.url)
    }
}    

extension URL {
    public enum Settings {
        public enum iCloud: String, SettingsURLSuffixProvider {
            case root = "prefs:root=CASTLE"
            case backup = "prefs:root=CASTLE&path=BACKUP"
        }
        
        public enum WirelessRadios: String, SettingsURLSuffixProvider {
            case wifi = "prefs:root=WIFI"
            case bluetooth = "prefs:root=Bluetooth"
            case cellular = "prefs:root=MOBILE_DATA_SETTINGS_ID"
        }
        
        public enum PersonalHotspot: String, SettingsURLSuffixProvider {
            case tethering = "prefs:root=INTERNET_TETHERING"
            case familySharing = "prefs:root=INTERNET_TETHERING&path=Family%20Sharing"
            case wifiPassword = "prefs:root=INTERNET_TETHERING&path=Wi-Fi%20Password"
        }
        
        public enum VPN: String, SettingsURLSuffixProvider {
            case vpn = "prefs:root=General&path=VPN"
            case dns = "prefs:root=General&path=VPN/DNS"
        }
        
        public enum Notifications: String, SettingsURLSuffixProvider {
            case root = "prefs:root=NOTIFICATIONS_ID"
            case siriSuggestions = "prefs:root=NOTIFICATIONS_ID&path=Siri%20Suggestions"
        }
        
        public enum Sounds: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Sounds"
            case ringtone = "prefs:root=Sounds&path=Ringtone"
        }
        
        public enum DoNotDisturb: String, SettingsURLSuffixProvider {
            case root = "prefs:root=DO_NOT_DISTURB"
            case allowCallsFrom = "prefs:root=DO_NOT_DISTURB&path=Allow%20Calls%20From"
        }
        
        public enum ScreenTime: String, SettingsURLSuffixProvider {
            case root = "prefs:root=SCREEN_TIME"
            case downtime = "prefs:root=SCREEN_TIME&path=DOWNTIME"
            case appLimits = "prefs:root=SCREEN_TIME&path=APP_LIMITS"
            case alwaysAllowed = "prefs:root=SCREEN_TIME&path=ALWAYS_ALLOWED"
        }
        
        public enum General: String, SettingsURLSuffixProvider {
            case root = "prefs:root=General"
            case about = "prefs:root=General&path=About"
            case softwareUpdate = "prefs:root=General&path=SOFTWARE_UPDATE_LINK"
            case carPlay = "prefs:root=General&path=CARPLAY"
            case backgroundAppRefresh = "prefs:root=General&path=AUTO_CONTENT_DOWNLOAD"
            case multitasking = "prefs:root=General&path=MULTITASKING" // iPad-only
            case dateTime = "prefs:root=General&path=DATE_AND_TIME"
            case keyboard = "prefs:root=General&path=Keyboard"
            case keyboardKeyboards = "prefs:root=General&path=Keyboard/KEYBOARDS"
            case keyboardHardwareKeyboard = "prefs:root=General&path=Keyboard/Hardware%20Keyboard"
            case keyboardTextReplacement = "prefs:root=General&path=Keyboard/USER_DICTIONARY"
            case keyboardOneHandedKeyboard = "prefs:root=General&path=Keyboard/ReachableKeyboard"
            case languageRegion = "prefs:root=General&path=INTERNATIONAL"
            case dictionary = "prefs:root=General&path=DICTIONARY"
            case profiles = "prefs:root=General&path=ManagedConfigurationList"
            case reset = "prefs:root=General&path=Reset"
        }
        
        public enum ControlCenter: String, SettingsURLSuffixProvider {
            case root = "prefs:root=ControlCenter"
            case customizeControls = "prefs:root=ControlCenter&path=CUSTOMIZE_CONTROLS"
        }
        
        public enum Display: String, SettingsURLSuffixProvider {
            case root = "prefs:root=DISPLAY"
            case autoLock = "prefs:root=DISPLAY&path=AUTOLOCK"
            case textSize = "prefs:root=DISPLAY&path=TEXT_SIZE"
        }
        
        public enum Accessibility: String, SettingsURLSuffixProvider {
            case root = "prefs:root=ACCESSIBILITY"
        }
        
        public enum Wallpaper: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Wallpaper"
        }
        
        public enum Siri: String, SettingsURLSuffixProvider {
            case root = "prefs:root=SIRI"
        }
        
        public enum ApplePencil: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Pencil" // iPad-only
        }
        
        public enum FaceID: String, SettingsURLSuffixProvider {
            case root = "prefs:root=PASSCODE"
        }
        
        public enum EmergencySOS: String, SettingsURLSuffixProvider {
            case root = "prefs:root=EMERGENCY_SOS"
        }
        
        public enum BatteryUsage: String, SettingsURLSuffixProvider {
            case root = "prefs:root=BATTERY_USAGE"
            case health = "prefs:root=BATTERY_USAGE&path=BATTERY_HEALTH" // iPhone-only
        }
        
        public enum Privacy: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Privacy"
                                 
            case locationServices = "prefs:root=Privacy&path=LOCATION"
            case contacts = "prefs:root=Privacy&path=CONTACTS"
            case calendars = "prefs:root=Privacy&path=CALENDARS"
            case reminders = "prefs:root=Privacy&path=REMINDERS"
            case photos = "prefs:root=Privacy&path=PHOTOS"
            case microphone = "prefs:root=Privacy&path=MICROPHONE"
            case speechRecognition = "prefs:root=Privacy&path=SPEECH_RECOGNITION"
            case camera = "prefs:root=Privacy&path=CAMERA"
            case motion = "prefs:root=Privacy&path=MOTION"
            case analyticsImprovements = "prefs:root=Privacy&path=PROBLEM_REPORTING"
            case appleAdvertising = "prefs:root=Privacy&path=ADVERTISING"
        }
        
        public enum AppStore: String, SettingsURLSuffixProvider {
            case root = "prefs:root=STORE"
            case appDownloads = "prefs:root=STORE&path=App%20Downloads"
            case videoAutoplay = "prefs:root=STORE&path=Video%20Autoplay"
        }
        
        public enum Wallet: String, SettingsURLSuffixProvider {
            case root = "prefs:root=PASSBOOK"
        }
        
        public enum Passwords: String, SettingsURLSuffixProvider {
            case root = "prefs:root=PASSWORDS"
        }
        
        public enum Mail: String, SettingsURLSuffixProvider {
            case root = "prefs:root=MAIL"
            case accounts = "prefs:root=ACCOUNTS_AND_PASSWORDS&path=ACCOUNTS"
            case accountsFetchNewData = "prefs:root=ACCOUNTS_AND_PASSWORDS&path=FETCH_NEW_DATA"
            case accountsAddAccount = "prefs:root=ACCOUNTS_AND_PASSWORDS&path=ADD_ACCOUNT"
            case preview = "prefs:root=MAIL&path=Preview"
            case swipeOptions = "prefs:root=MAIL&path=Swipe%20Options"
            case notifications = "prefs:root=MAIL&path=NOTIFICATIONS"
            case blocked = "prefs:root=MAIL&path=Blocked"
            case mutedThreadAction = "prefs:root=MAIL&path=Muted%20Thread%20Action"
            case blockedSenderOptions = "prefs:root=MAIL&path=Blocked%20Sender%20Options"
            case markAddresses = "prefs:root=MAIL&path=Mark%20Addresses"
            case increaseQuoteLevel = "prefs:root=MAIL&path=Increase%20Quote%20Level"
            case includeAttachmentsWithReplies = "prefs:root=MAIL&path=Include%20Attachments%20with%20Replies"
            case signature = "prefs:root=MAIL&path=Signature"
            case defaultAccount = "prefs:root=MAIL&path=Default%20Account"
        }
        
        public enum Contacts: String, SettingsURLSuffixProvider {
            case root = "prefs:root=CONTACTS"
        }
        
        public enum Calendar: String, SettingsURLSuffixProvider {
            case root = "prefs:root=CALENDAR"
            case alternateCalendars = "prefs:root=CALENDAR&path=Alternate%20Calendars"
            case sync = "prefs:root=CALENDAR&path=Sync"
            case defaultAlertTimes = "prefs:root=CALENDAR&path=Default%20Alert%20Times"
            case defaultCalendar = "prefs:root=CALENDAR&path=Default%20Calendar"
        }
        
        public enum Notes: String, SettingsURLSuffixProvider {
            case root = "prefs:root=NOTES"
            case defaultAccount = "prefs:root=NOTES&path=Default%20Account"
            case password = "prefs:root=NOTES&path=Password"
            case sortNotesBy = "prefs:root=NOTES&path=Sort%20Notes%20By"
            case newNotesStartWith = "prefs:root=NOTES&path=New%20Notes%20Start%20With"
            case sortCheckedItems = "prefs:root=NOTES&path=Sort%20Checked%20Items"
            case linesGrids = "prefs:root=NOTES&path=Lines%20%26%20Grids"
            case accessNotesFromLockScreen = "prefs:root=NOTES&path=Access%20Notes%20from%20Lock%20Screen"
        }
        
        public enum Reminders: String, SettingsURLSuffixProvider {
            case root = "prefs:root=REMINDERS"
            case defaultList = "prefs:root=REMINDERS&path=DEFAULT_LIST"
        }
        
        public enum VoiceMemos: String, SettingsURLSuffixProvider {
            case root = "prefs:root=VOICE_MEMOS"
        }
        
        public enum Phone: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Phone"
        }
        
        public enum Messages: String, SettingsURLSuffixProvider {
            case root = "prefs:root=MESSAGES"
        }
        
        public enum FaceTime: String, SettingsURLSuffixProvider {
            case root = "prefs:root=FACETIME"
        }
        
        public enum Maps: String, SettingsURLSuffixProvider {
            case root = "prefs:root=MAPS"
            case drivingNavigation = "prefs:root=MAPS&path=Driving%20%26%20Navigation"
            case transit = "prefs:root=MAPS&path=Transit"
        }
        
        public enum Compass: String, SettingsURLSuffixProvider {
            case root = "prefs:root=COMPASS"
        }
        
        public enum Measure: String, SettingsURLSuffixProvider {
            case root = "prefs:root=MEASURE"
        }
        
        public enum Safari: String, SettingsURLSuffixProvider {
            case root = "prefs:root=SAFARI"
            case contentBlockers = "prefs:root=SAFARI&path=Content%20Blockers"
            case downloads = "prefs:root=SAFARI&path=DOWNLOADS"
            case closeTabs = "prefs:root=SAFARI&path=Close%20Tabs"
            case clearHistoryData = "prefs:root=SAFARI&path=CLEAR_HISTORY_AND_DATA"
            case pageZoom = "prefs:root=SAFARI&path=Page%20Zoom"
            case requestDesktopWebsite = "prefs:root=SAFARI&path=Request%20Desktop%20Website"
            case reader = "prefs:root=SAFARI&path=Reader"
            case camera = "prefs:root=SAFARI&path=Camera"
            case microphone = "prefs:root=SAFARI&path=Microphone"
            case location = "prefs:root=SAFARI&path=Location"
            case advanced = "prefs:root=SAFARI&path=ADVANCED"
        }
        
        public enum News: String, SettingsURLSuffixProvider {
            case root = "prefs:root=NEWS"
        }
        
        public enum Health: String, SettingsURLSuffixProvider {
            case root = "prefs:root=HEALTH"
        }
        
        public enum Shortcuts: String, SettingsURLSuffixProvider {
            case root = "prefs:root=SHORTCUTS"
        }
        
        public enum Music: String, SettingsURLSuffixProvider {
            case root = "prefs:root=MUSIC"
            case cellularData = "prefs:root=MUSIC&path=com.apple.Music:CellularData"
            case optimizeStorage = "prefs:root=MUSIC&path=com.apple.Music:OptimizeStorage"
            case eQ = "prefs:root=MUSIC&path=com.apple.Music:EQ"
            case volumeLimit = "prefs:root=MUSIC&path=com.apple.Music:VolumeLimit"
        }
        
        public enum TV: String, SettingsURLSuffixProvider {
            case root = "prefs:root=TVAPP"
        }
        
        public enum Photos: String, SettingsURLSuffixProvider {
            case root = "prefs:root=Photos"
        }
        
        public enum Camera: String, SettingsURLSuffixProvider {
            case root = "prefs:root=CAMERA"
            case recordVideo = "prefs:root=CAMERA&path=Record%20Video"
            case recordSlowMotion = "prefs:root=CAMERA&path=Record%20Slo-mo"
        }
        
        public enum Books: String, SettingsURLSuffixProvider {
            case root = "prefs:root=IBOOKS"
        }
        
        public enum GameCenter: String, SettingsURLSuffixProvider {
            case root = "prefs:root=GAMECENTER"
        }
        
    }
}

#endif
