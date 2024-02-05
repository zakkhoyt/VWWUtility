



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
//    func openAppSettings() {
//        guard let bundleId = Bundle.main.bundleIdentifier else {
//            preconditionFailure()
//        }
//        
//        // iOS 14 comment https://stackoverflow.com/a/61383270/803882
//        guard let url = URL(string: "App-prefs:Privacy&path=LOCATION") else { // https://stackoverflow.com/a/61383270/803882
//            //        guard let url = URL(string: "prefs:root=Bluetooth") else {
//            //        guard let url = URL(string: "prefs:root=Bluetooth") else { // short ulong warning //
//            //        guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { // ulog warning // https://stackoverflow.com/a/43090019/803882
//            //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI") else { // main settings app
//            //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI/\(bundleId)") else { // main settings app
//            //        guard let url = URL(string: "prefs:root=WIFI/\(bundleId)") else { // nothing
//            preconditionFailure()
//        }
//        UIApplication.shared.open(url)
//    }

//    func openAppSettings() {
//        guard let bundleId = Bundle.main.bundleIdentifier else {
//            preconditionFailure()
//        }
//        
//        //        guard let url = URL(string: "prefs:root=Bluetooth") else {
//        //        guard let url = URL(string: "prefs:root=Bluetooth") else { // short ulong warning //
//        //        guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { // ulog warning // https://stackoverflow.com/a/43090019/803882
//        //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI") else { // main settings app
//        //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI/\(bundleId)") else { // main settings app
//        //        guard let url = URL(string: "prefs:root=WIFI/\(bundleId)") else { // nothing
//        
//        // iOS 14 comment https://stackoverflow.com/a/61383270/803882
//        // iOS 15 tested. Takes to general location services (apps listed as siblings)
//        //        guard let url = URL(string: "App-prefs:Privacy&path=LOCATION") else {
//        // iOS 15 tested. Takes to app specific locatoin service underneat general location services (not in the app settings directly)
//        guard let url = URL(string: "App-prefs:Privacy&path=LOCATION/\(bundleId)") else {
//            preconditionFailure()
//        }
//        //        if UIApplication.shared.canOpenURL(url) {
//        //
//        //        } else {
//        //
//        //        }
//        logger.debug("can open url? \(UIApplication.shared.canOpenURL(url)) (\(url.absoluteString))")
//        logger.debug("Opening url \(url.absoluteString)")
//        UIApplication.shared.open(url)
//        // Even though the settings are being opened, we are getting warnings from com.apple.launchservices
//        //    `Failed to open URL App-prefs:Privacy&path=LOCATION: Error Domain=FBSOpenApplicationServiceErrorDomain Code=1 "The request to open "com.apple.Preferences" failed." UserInfo={BSErrorCodeDescription=RequestDenied, NSUnderlyingError=0x282002130 {Error Domain=FBSOpenApplicationErrorDomain Code=3 "Application co.hatch.WiFiPropertiesApp is neither visible nor entitled, so may not perform un-trusted user actions." UserInfo={BSErrorCodeDescription=Security, NSLocalizedFailureReason=Application co.hatch.WiFiPropertiesApp is neither visible nor entitled, so may not perform un-trusted user actions.}}, NSLocalizedDescription=The request to open "com.apple.Preferences" failed., FBSOpenApplicationRequestID=0xabee, NSLocalizedFailureReason=The request was denied by service delegate (SBMainWorkspace) for reason: Security ("Application co.hatch.WiFiPropertiesApp is neither visible nor entitled, so may not perform un-trusted user actions").}`
//    }
    
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
    /// # Public Settings
    /// Navigating the user to public settings (not app specific)
    /// I (zakkhoyt) tested [this](https://stackoverflow.com/a/61383270/80388) and it works
    /// (if using the syntax in one of the comments)
    /// I have also same issue with iOS 14 but in my case it is resolved when i remove root prefix.
    /// For example instead of
    /// `"prefs:root=Privacy&path=LOCATION"`
    /// I used
    /// `"App-prefs:Privacy&path=LOCATION"`
    /// and it works in iOS 14.
    ///
    /// IE: `prefs:root=` -> `App-prefs:`
    public enum Settings {
        public enum iCloud: String, SettingsURLSuffixProvider {
            case root = "App-prefs:CASTLE"
            case backup = "App-prefs:CASTLE&path=BACKUP"
        }
        
        public enum WirelessRadios: String, SettingsURLSuffixProvider {
            case wifi = "App-prefs:WIFI"
            case bluetooth = "App-prefs:Bluetooth"
            case cellular = "App-prefs:MOBILE_DATA_SETTINGS_ID"
        }
        
        public enum PersonalHotspot: String, SettingsURLSuffixProvider {
            case tethering = "App-prefs:INTERNET_TETHERING"
            case familySharing = "App-prefs:INTERNET_TETHERING&path=Family%20Sharing"
            case wifiPassword = "App-prefs:INTERNET_TETHERING&path=Wi-Fi%20Password"
        }
        
        public enum VPN: String, SettingsURLSuffixProvider {
            case vpn = "App-prefs:General&path=VPN"
            case dns = "App-prefs:General&path=VPN/DNS"
        }
        
        public enum Notifications: String, SettingsURLSuffixProvider {
            case root = "App-prefs:NOTIFICATIONS_ID"
            case siriSuggestions = "App-prefs:NOTIFICATIONS_ID&path=Siri%20Suggestions"
        }
        
        public enum Sounds: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Sounds"
            case ringtone = "App-prefs:Sounds&path=Ringtone"
        }
        
        public enum DoNotDisturb: String, SettingsURLSuffixProvider {
            case root = "App-prefs:DO_NOT_DISTURB"
            case allowCallsFrom = "App-prefs:DO_NOT_DISTURB&path=Allow%20Calls%20From"
        }
        
        public enum ScreenTime: String, SettingsURLSuffixProvider {
            case root = "App-prefs:SCREEN_TIME"
            case downtime = "App-prefs:SCREEN_TIME&path=DOWNTIME"
            case appLimits = "App-prefs:SCREEN_TIME&path=APP_LIMITS"
            case alwaysAllowed = "App-prefs:SCREEN_TIME&path=ALWAYS_ALLOWED"
        }
        
        public enum General: String, SettingsURLSuffixProvider {
            case root = "App-prefs:General"
            case about = "App-prefs:General&path=About"
            case softwareUpdate = "App-prefs:General&path=SOFTWARE_UPDATE_LINK"
            case carPlay = "App-prefs:General&path=CARPLAY"
            case backgroundAppRefresh = "App-prefs:General&path=AUTO_CONTENT_DOWNLOAD"
            case multitasking = "App-prefs:General&path=MULTITASKING" // iPad-only
            case dateTime = "App-prefs:General&path=DATE_AND_TIME"
            case keyboard = "App-prefs:General&path=Keyboard"
            case keyboardKeyboards = "App-prefs:General&path=Keyboard/KEYBOARDS"
            case keyboardHardwareKeyboard = "App-prefs:General&path=Keyboard/Hardware%20Keyboard"
            case keyboardTextReplacement = "App-prefs:General&path=Keyboard/USER_DICTIONARY"
            case keyboardOneHandedKeyboard = "App-prefs:General&path=Keyboard/ReachableKeyboard"
            case languageRegion = "App-prefs:General&path=INTERNATIONAL"
            case dictionary = "App-prefs:General&path=DICTIONARY"
            case profiles = "App-prefs:General&path=ManagedConfigurationList"
            case reset = "App-prefs:General&path=Reset"
        }
        
        public enum ControlCenter: String, SettingsURLSuffixProvider {
            case root = "App-prefs:ControlCenter"
            case customizeControls = "App-prefs:ControlCenter&path=CUSTOMIZE_CONTROLS"
        }
        
        public enum Display: String, SettingsURLSuffixProvider {
            case root = "App-prefs:DISPLAY"
            case autoLock = "App-prefs:DISPLAY&path=AUTOLOCK"
            case textSize = "App-prefs:DISPLAY&path=TEXT_SIZE"
        }
        
        public enum Accessibility: String, SettingsURLSuffixProvider {
            case root = "App-prefs:ACCESSIBILITY"
        }
        
        public enum Wallpaper: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Wallpaper"
        }
        
        public enum Siri: String, SettingsURLSuffixProvider {
            case root = "App-prefs:SIRI"
        }
        
        public enum ApplePencil: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Pencil" // iPad-only
        }
        
        public enum FaceID: String, SettingsURLSuffixProvider {
            case root = "App-prefs:PASSCODE"
        }
        
        public enum EmergencySOS: String, SettingsURLSuffixProvider {
            case root = "App-prefs:EMERGENCY_SOS"
        }
        
        public enum BatteryUsage: String, SettingsURLSuffixProvider {
            case root = "App-prefs:BATTERY_USAGE"
            case health = "App-prefs:BATTERY_USAGE&path=BATTERY_HEALTH" // iPhone-only
        }
        
        public enum Privacy: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Privacy"
            
            case locationServices = "App-prefs:Privacy&path=LOCATION"
            case contacts = "App-prefs:Privacy&path=CONTACTS"
            case calendars = "App-prefs:Privacy&path=CALENDARS"
            case reminders = "App-prefs:Privacy&path=REMINDERS"
            case photos = "App-prefs:Privacy&path=PHOTOS"
            case microphone = "App-prefs:Privacy&path=MICROPHONE"
            case speechRecognition = "App-prefs:Privacy&path=SPEECH_RECOGNITION"
            case camera = "App-prefs:Privacy&path=CAMERA"
            case motion = "App-prefs:Privacy&path=MOTION"
            case analyticsImprovements = "App-prefs:Privacy&path=PROBLEM_REPORTING"
            case appleAdvertising = "App-prefs:Privacy&path=ADVERTISING"
        }
        
        public enum AppStore: String, SettingsURLSuffixProvider {
            case root = "App-prefs:STORE"
            case appDownloads = "App-prefs:STORE&path=App%20Downloads"
            case videoAutoplay = "App-prefs:STORE&path=Video%20Autoplay"
        }
        
        public enum Wallet: String, SettingsURLSuffixProvider {
            case root = "App-prefs:PASSBOOK"
        }
        
        public enum Passwords: String, SettingsURLSuffixProvider {
            case root = "App-prefs:PASSWORDS"
        }
        
        public enum Mail: String, SettingsURLSuffixProvider {
            case root = "App-prefs:MAIL"
            case accounts = "App-prefs:ACCOUNTS_AND_PASSWORDS&path=ACCOUNTS"
            case accountsFetchNewData = "App-prefs:ACCOUNTS_AND_PASSWORDS&path=FETCH_NEW_DATA"
            case accountsAddAccount = "App-prefs:ACCOUNTS_AND_PASSWORDS&path=ADD_ACCOUNT"
            case preview = "App-prefs:MAIL&path=Preview"
            case swipeOptions = "App-prefs:MAIL&path=Swipe%20Options"
            case notifications = "App-prefs:MAIL&path=NOTIFICATIONS"
            case blocked = "App-prefs:MAIL&path=Blocked"
            case mutedThreadAction = "App-prefs:MAIL&path=Muted%20Thread%20Action"
            case blockedSenderOptions = "App-prefs:MAIL&path=Blocked%20Sender%20Options"
            case markAddresses = "App-prefs:MAIL&path=Mark%20Addresses"
            case increaseQuoteLevel = "App-prefs:MAIL&path=Increase%20Quote%20Level"
            case includeAttachmentsWithReplies = "App-prefs:MAIL&path=Include%20Attachments%20with%20Replies"
            case signature = "App-prefs:MAIL&path=Signature"
            case defaultAccount = "App-prefs:MAIL&path=Default%20Account"
        }
        
        public enum Contacts: String, SettingsURLSuffixProvider {
            case root = "App-prefs:CONTACTS"
        }
        
        public enum Calendar: String, SettingsURLSuffixProvider {
            case root = "App-prefs:CALENDAR"
            case alternateCalendars = "App-prefs:CALENDAR&path=Alternate%20Calendars"
            case sync = "App-prefs:CALENDAR&path=Sync"
            case defaultAlertTimes = "App-prefs:CALENDAR&path=Default%20Alert%20Times"
            case defaultCalendar = "App-prefs:CALENDAR&path=Default%20Calendar"
        }
        
        public enum Notes: String, SettingsURLSuffixProvider {
            case root = "App-prefs:NOTES"
            case defaultAccount = "App-prefs:NOTES&path=Default%20Account"
            case password = "App-prefs:NOTES&path=Password"
            case sortNotesBy = "App-prefs:NOTES&path=Sort%20Notes%20By"
            case newNotesStartWith = "App-prefs:NOTES&path=New%20Notes%20Start%20With"
            case sortCheckedItems = "App-prefs:NOTES&path=Sort%20Checked%20Items"
            case linesGrids = "App-prefs:NOTES&path=Lines%20%26%20Grids"
            case accessNotesFromLockScreen = "App-prefs:NOTES&path=Access%20Notes%20from%20Lock%20Screen"
        }
        
        public enum Reminders: String, SettingsURLSuffixProvider {
            case root = "App-prefs:REMINDERS"
            case defaultList = "App-prefs:REMINDERS&path=DEFAULT_LIST"
        }
        
        public enum VoiceMemos: String, SettingsURLSuffixProvider {
            case root = "App-prefs:VOICE_MEMOS"
        }
        
        public enum Phone: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Phone"
        }
        
        public enum Messages: String, SettingsURLSuffixProvider {
            case root = "App-prefs:MESSAGES"
        }
        
        public enum FaceTime: String, SettingsURLSuffixProvider {
            case root = "App-prefs:FACETIME"
        }
        
        public enum Maps: String, SettingsURLSuffixProvider {
            case root = "App-prefs:MAPS"
            case drivingNavigation = "App-prefs:MAPS&path=Driving%20%26%20Navigation"
            case transit = "App-prefs:MAPS&path=Transit"
        }
        
        public enum Compass: String, SettingsURLSuffixProvider {
            case root = "App-prefs:COMPASS"
        }
        
        public enum Measure: String, SettingsURLSuffixProvider {
            case root = "App-prefs:MEASURE"
        }
        
        public enum Safari: String, SettingsURLSuffixProvider {
            case root = "App-prefs:SAFARI"
            case contentBlockers = "App-prefs:SAFARI&path=Content%20Blockers"
            case downloads = "App-prefs:SAFARI&path=DOWNLOADS"
            case closeTabs = "App-prefs:SAFARI&path=Close%20Tabs"
            case clearHistoryData = "App-prefs:SAFARI&path=CLEAR_HISTORY_AND_DATA"
            case pageZoom = "App-prefs:SAFARI&path=Page%20Zoom"
            case requestDesktopWebsite = "App-prefs:SAFARI&path=Request%20Desktop%20Website"
            case reader = "App-prefs:SAFARI&path=Reader"
            case camera = "App-prefs:SAFARI&path=Camera"
            case microphone = "App-prefs:SAFARI&path=Microphone"
            case location = "App-prefs:SAFARI&path=Location"
            case advanced = "App-prefs:SAFARI&path=ADVANCED"
        }
        
        public enum News: String, SettingsURLSuffixProvider {
            case root = "App-prefs:NEWS"
        }
        
        public enum Health: String, SettingsURLSuffixProvider {
            case root = "App-prefs:HEALTH"
        }
        
        public enum Shortcuts: String, SettingsURLSuffixProvider {
            case root = "App-prefs:SHORTCUTS"
        }
        
        public enum Music: String, SettingsURLSuffixProvider {
            case root = "App-prefs:MUSIC"
            case cellularData = "App-prefs:MUSIC&path=com.apple.Music:CellularData"
            case optimizeStorage = "App-prefs:MUSIC&path=com.apple.Music:OptimizeStorage"
            case eQ = "App-prefs:MUSIC&path=com.apple.Music:EQ"
            case volumeLimit = "App-prefs:MUSIC&path=com.apple.Music:VolumeLimit"
        }
        
        public enum TV: String, SettingsURLSuffixProvider {
            case root = "App-prefs:TVAPP"
        }
        
        public enum Photos: String, SettingsURLSuffixProvider {
            case root = "App-prefs:Photos"
        }
        
        public enum Camera: String, SettingsURLSuffixProvider {
            case root = "App-prefs:CAMERA"
            case recordVideo = "App-prefs:CAMERA&path=Record%20Video"
            case recordSlowMotion = "App-prefs:CAMERA&path=Record%20Slo-mo"
        }
        
        public enum Books: String, SettingsURLSuffixProvider {
            case root = "App-prefs:IBOOKS"
        }
        
        public enum GameCenter: String, SettingsURLSuffixProvider {
            case root = "App-prefs:GAMECENTER"
        }
        
    }
}
#endif
