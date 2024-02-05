
// https://stackoverflow.com/a/35987082/803882
// https://stackoverflow.com/a/8246814/803882



// https://www.macstories.net/ios/a-comprehensive-guide-to-all-120-settings-urls-supported-by-ios-and-ipados-13-1/
// https://forums.macrumors.com/threads/manually-creating-settings-launchers-in-app-launching-apps.2037291/
// https://developer.apple.com/documentation/uikit/uiapplication/4013180-opennotificationsettingsurlstrin

// https://www.icloud.com/shortcuts/381d0ab479dc4808bf16f47b738cc526

#if os(iOS)
import Foundation
import UIKit

public struct SettingsDestination: Identifiable {
    public init(name: String, urlString: String) {
        self.name = name
        self.urlString = urlString
    }
    
    public let name: String
    public let urlString: String
    public var id: String { urlString }
}


public enum SystemSettings {
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
    
    @MainActor
    public static func open(
        _ destination: SettingsDestination,
        appSpecific: Bool = false
    ) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            preconditionFailure()
        }
        
        //        guard let url = URL(string: "prefs:root=Bluetooth") else {
        //        guard let url = URL(string: "prefs:root=Bluetooth") else { // short ulong warning //
        //        guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { // ulog warning // https://stackoverflow.com/a/43090019/803882
        //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI") else { // main settings app
        //        guard let url = URL(string: "\(UIApplication.openSettingsURLString)&prefs:root=WIFI/\(bundleId)") else { // main settings app
        //        guard let url = URL(string: "prefs:root=WIFI/\(bundleId)") else { // nothing
        
        // iOS 14 comment https://stackoverflow.com/a/61383270/803882
        // iOS 15 tested. Takes to general location services (apps listed as siblings)
        //        guard let url = URL(string: "App-prefs:Privacy&path=LOCATION") else {
        // iOS 15 tested. Takes to app specific locatoin service underneat general location services (not in the app settings directly)
        let urlString: String = if appSpecific {
            "\(destination.urlString)/\(bundleId)"
        } else {
            destination.urlString
        }
        guard let url = URL(
            string: urlString
        ) else {
            assertionFailure("Failed to instantiate a URL from urlString: \(urlString)")
            return
        }

        logger.debug("canOpenURL? \(UIApplication.shared.canOpenURL(url)) (\(url.absoluteString))")
        logger.debug("Opening url \(url.absoluteString)")
        UIApplication.shared.open(url)
        // Even though the settings are being opened, we are getting warnings from com.apple.launchservices
        //    `Failed to open URL App-prefs:Privacy&path=LOCATION: Error Domain=FBSOpenApplicationServiceErrorDomain Code=1 "The request to open "com.apple.Preferences" failed." UserInfo={BSErrorCodeDescription=RequestDenied, NSUnderlyingError=0x282002130 {Error Domain=FBSOpenApplicationErrorDomain Code=3 "Application com.vaporwarewolf.SystemSettingsExerciser is neither visible nor entitled, so may not perform un-trusted user actions." UserInfo={BSErrorCodeDescription=Security, NSLocalizedFailureReason=Application com.vaporwarewolf.SystemSettingsExerciser is neither visible nor entitled, so may not perform un-trusted user actions.}}, NSLocalizedDescription=The request to open "com.apple.Preferences" failed., FBSOpenApplicationRequestID=0xabee, NSLocalizedFailureReason=The request was denied by service delegate (SBMainWorkspace) for reason: Security ("Application com.vaporwarewolf.SystemSettingsExerciser is neither visible nor entitled, so may not perform un-trusted user actions").}`
    }
}

extension SettingsDestination {
    public static let all: [SettingsDestination] = [
        SettingsDestination(
            name: "iCloud",
            urlString: "App-prefs:CASTLE"
        ),
        SettingsDestination(
            name: "iCloudBackup",
            urlString: "App-prefs:CASTLE&path=BACKUP"
        ),
        SettingsDestination(
            name: "wifi",
            urlString: "App-prefs:WIFI"
        ),
        SettingsDestination(
            name: "bluetooth",
            urlString: "App-prefs:Bluetooth"
        ),
        SettingsDestination(
            name: "cellular",
            urlString: "App-prefs:MOBILE_DATA_SETTINGS_ID"
        ),
        SettingsDestination(
            name: "tethering",
            urlString: "App-prefs:INTERNET_TETHERING"
        ),
        SettingsDestination(
            name: "familySharing",
            urlString: "App-prefs:INTERNET_TETHERING&path=Family%20Sharing"
        ),
        SettingsDestination(
            name: "wifiPassword",
            urlString: "App-prefs:INTERNET_TETHERING&path=Wi-Fi%20Password"
        ),
        SettingsDestination(
            name: "vpn",
            urlString: "App-prefs:General&path=VPN"
        ),
        SettingsDestination(
            name: "dns",
            urlString: "App-prefs:General&path=VPN/DNS"
        ),
        SettingsDestination(
            name: "notifications",
            urlString: "App-prefs:NOTIFICATIONS_ID"
        ),
        SettingsDestination(
            name: "notificationsSriSuggestions",
            urlString: "App-prefs:NOTIFICATIONS_ID&path=Siri%20Suggestions"
        ),
        SettingsDestination(
            name: "sounds",
            urlString: "App-prefs:Sounds"
        ),
        SettingsDestination(
            name: "soundsRingtone",
            urlString: "App-prefs:Sounds&path=Ringtone"
        ),
        SettingsDestination(
            name: "doNotDisturb",
            urlString: "App-prefs:DO_NOT_DISTURB"
        ),
        SettingsDestination(
            name: "doNotDisturbAllowCallsFrom",
            urlString: "App-prefs:DO_NOT_DISTURB&path=Allow%20Calls%20From"
        ),
        SettingsDestination(
            name: "screenTime",
            urlString: "App-prefs:SCREEN_TIME"
        ),
        SettingsDestination(
            name: "screenTimeDowntime",
            urlString: "App-prefs:SCREEN_TIME&path=DOWNTIME"
        ),
        SettingsDestination(
            name: "screenTimeAppLimits",
            urlString: "App-prefs:SCREEN_TIME&path=APP_LIMITS"
        ),
        SettingsDestination(
            name: "screenTimeAlwaysAllowed",
            urlString: "App-prefs:SCREEN_TIME&path=ALWAYS_ALLOWED"
        ),
        SettingsDestination(
            name: "general",
            urlString: "App-prefs:General"
        ),
        SettingsDestination(
            name: "generalAbout",
            urlString: "App-prefs:General&path=About"
        ),
        SettingsDestination(
            name: "generalSoftwareUpdate",
            urlString: "App-prefs:General&path=SOFTWARE_UPDATE_LINK"
        ),
        SettingsDestination(
            name: "generalCarPlay",
            urlString: "App-prefs:General&path=CARPLAY"
        ),
        SettingsDestination(
            name: "generalBackgroundAppRefresh",
            urlString: "App-prefs:General&path=AUTO_CONTENT_DOWNLOAD"
        ),
        SettingsDestination(
            name: "generalMultitasking",
            urlString: "App-prefs:General&path=MULTITASKING"
        ),  // iPad-only
        SettingsDestination(
            name: "generalDateTime",
            urlString: "App-prefs:General&path=DATE_AND_TIME"
        ),
        SettingsDestination(
            name: "generalKeyboard",
            urlString: "App-prefs:General&path=Keyboard"
        ),
        SettingsDestination(
            name: "generalKeyboardKeyboards",
            urlString: "App-prefs:General&path=Keyboard/KEYBOARDS"
        ),
        SettingsDestination(
            name: "generalKeyboardHardwareKeyboard",
            urlString: "App-prefs:General&path=Keyboard/Hardware%20Keyboard"
        ),
        SettingsDestination(
            name: "generalKeyboardTextReplacement",
            urlString: "App-prefs:General&path=Keyboard/USER_DICTIONARY"
        ),
        SettingsDestination(
            name: "generalKeyboardOneHandedKeyboard",
            urlString: "App-prefs:General&path=Keyboard/ReachableKeyboard"
        ),
        SettingsDestination(
            name: "generalLanguageRegion",
            urlString: "App-prefs:General&path=INTERNATIONAL"
        ),
        SettingsDestination(
            name: "generalDictionary",
            urlString: "App-prefs:General&path=DICTIONARY"
        ),
        SettingsDestination(
            name: "generalProfiles",
            urlString: "App-prefs:General&path=ManagedConfigurationList"
        ),
        SettingsDestination(
            name: "generalReset",
            urlString: "App-prefs:General&path=Reset"
        ),
        SettingsDestination(
            name: "controlCenter",
            urlString: "App-prefs:ControlCenter"
        ),
        SettingsDestination(
            name: "controlCenterCustomizeControls",
            urlString: "App-prefs:ControlCenter&path=CUSTOMIZE_CONTROLS"
        ),
        SettingsDestination(
            name: "display",
            urlString: "App-prefs:DISPLAY"
        ),
        SettingsDestination(
            name: "displayAutoLock",
            urlString: "App-prefs:DISPLAY&path=AUTOLOCK"
        ),
        SettingsDestination(
            name: "displayTextSize",
            urlString: "App-prefs:DISPLAY&path=TEXT_SIZE"
        ),
        SettingsDestination(
            name: "accessibility",
            urlString: "App-prefs:ACCESSIBILITY"
        ),
        SettingsDestination(
            name: "wallpaper",
            urlString: "App-prefs:Wallpaper"
        ),
        SettingsDestination(
            name: "siri",
            urlString: "App-prefs:SIRI"
        ),
        SettingsDestination(
            name: "applePencil",
            urlString: "App-prefs:Pencil"
        ), // iPad-only
        SettingsDestination(
            name: "faceID",
            urlString: "App-prefs:PASSCODE"
        ),
        SettingsDestination(
            name: "emergencySOS",
            urlString: "App-prefs:EMERGENCY_SOS"
        ),
        SettingsDestination(
            name: "batteryUsage",
            urlString: "App-prefs:BATTERY_USAGE"
        ),
        SettingsDestination(
            name: "batteryUsageHealth",
            urlString: "App-prefs:BATTERY_USAGE&path=BATTERY_HEALTH"
        ), // iPhone-only
        SettingsDestination(
            name: "privacy",
            urlString: "App-prefs:Privacy"
        ),
        SettingsDestination(
            name: "privacyLocationServices",
            urlString: "App-prefs:Privacy&path=LOCATION"
        ),
        SettingsDestination(
            name: "privacyContacts",
            urlString: "App-prefs:Privacy&path=CONTACTS"
        ),
        SettingsDestination(
            name: "privacyCalendars",
            urlString: "App-prefs:Privacy&path=CALENDARS"
        ),
        SettingsDestination(
            name: "privacyReminders",
            urlString: "App-prefs:Privacy&path=REMINDERS"
        ),
        SettingsDestination(
            name: "privacyPhotos",
            urlString: "App-prefs:Privacy&path=PHOTOS"
        ),
        SettingsDestination(
            name: "privacyMicrophone",
            urlString: "App-prefs:Privacy&path=MICROPHONE"
        ),
        SettingsDestination(
            name: "privacySpeechRecognition",
            urlString: "App-prefs:Privacy&path=SPEECH_RECOGNITION"
        ),
        SettingsDestination(
            name: "privacyCamera",
            urlString: "App-prefs:Privacy&path=CAMERA"
        ),
        SettingsDestination(
            name: "privacyMotion",
            urlString: "App-prefs:Privacy&path=MOTION"
        ),
        SettingsDestination(
            name: "privacyAnalyticsImprovements",
            urlString: "App-prefs:Privacy&path=PROBLEM_REPORTING"
        ),
        SettingsDestination(
            name: "privacyAppleAdvertising",
            urlString: "App-prefs:Privacy&path=ADVERTISING"
        ),
        SettingsDestination(
            name: "appStore",
            urlString: "App-prefs:STORE"
        ),
        SettingsDestination(
            name: "appStoreAppDownloads",
            urlString: "App-prefs:STORE&path=App%20Downloads"
        ),
        SettingsDestination(
            name: "appStoreVideoAutoplay",
            urlString: "App-prefs:STORE&path=Video%20Autoplay"
        ),
        SettingsDestination(
            name: "wallet",
            urlString: "App-prefs:PASSBOOK"
        ),
        SettingsDestination(
            name: "passwords",
            urlString: "App-prefs:PASSWORDS"
        ),
        SettingsDestination(
            name: "mail",
            urlString: "App-prefs:MAIL"
        ),
        SettingsDestination(
            name: "mailAccounts",
            urlString: "App-prefs:ACCOUNTS_AND_PASSWORDS&path=ACCOUNTS"
        ),
        SettingsDestination(
            name: "mailAccountsFetchNewData",
            urlString: "App-prefs:ACCOUNTS_AND_PASSWORDS&path=FETCH_NEW_DATA"
        ),
        SettingsDestination(
            name: "mailAccountsAddAccount",
            urlString: "App-prefs:ACCOUNTS_AND_PASSWORDS&path=ADD_ACCOUNT"
        ),
        SettingsDestination(
            name: "mailPreview",
            urlString: "App-prefs:MAIL&path=Preview"
        ),
        SettingsDestination(
            name: "mailSwipeOptions",
            urlString: "App-prefs:MAIL&path=Swipe%20Options"
        ),
        SettingsDestination(
            name: "mailNotifications",
            urlString: "App-prefs:MAIL&path=NOTIFICATIONS"
        ),
        SettingsDestination(
            name: "mailBlocked",
            urlString: "App-prefs:MAIL&path=Blocked"
        ),
        SettingsDestination(
            name: "mailMutedThreadAction",
            urlString: "App-prefs:MAIL&path=Muted%20Thread%20Action"
        ),
        SettingsDestination(
            name: "mailBlockedSenderOptions",
            urlString: "App-prefs:MAIL&path=Blocked%20Sender%20Options"
        ),
        SettingsDestination(
            name: "mailMarkAddresses",
            urlString: "App-prefs:MAIL&path=Mark%20Addresses"
        ),
        SettingsDestination(
            name: "mailIncreaseQuoteLevel",
            urlString: "App-prefs:MAIL&path=Increase%20Quote%20Level"
        ),
        SettingsDestination(
            name: "mailIncludeAttachmentsWithReplies",
            urlString: "App-prefs:MAIL&path=Include%20Attachments%20with%20Replies"
        ),
        SettingsDestination(
            name: "mailSignature",
            urlString: "App-prefs:MAIL&path=Signature"
        ),
        SettingsDestination(
            name: "mailDefaultAccount",
            urlString: "App-prefs:MAIL&path=Default%20Account"
        ),
        SettingsDestination(
            name: "contacts",
            urlString: "App-prefs:CONTACTS"
        ),
        SettingsDestination(
            name: "calendar",
            urlString: "App-prefs:CALENDAR"
        ),
        SettingsDestination(
            name: "calendarAlternateCalendars",
            urlString: "App-prefs:CALENDAR&path=Alternate%20Calendars"
        ),
        SettingsDestination(
            name: "calendarSync",
            urlString: "App-prefs:CALENDAR&path=Sync"
        ),
        SettingsDestination(
            name: "calendarDefaultAlertTimes",
            urlString: "App-prefs:CALENDAR&path=Default%20Alert%20Times"
        ),
        SettingsDestination(
            name: "calendarDefaultCalendar",
            urlString: "App-prefs:CALENDAR&path=Default%20Calendar"
        ),
        SettingsDestination(
            name: "notes",
            urlString: "App-prefs:NOTES"
        ),
        SettingsDestination(
            name: "notesDefaultAccount",
            urlString: "App-prefs:NOTES&path=Default%20Account"
        ),
        SettingsDestination(
            name: "notesPassword",
            urlString: "App-prefs:NOTES&path=Password"
        ),
        SettingsDestination(
            name: "notesSortNotesBy",
            urlString: "App-prefs:NOTES&path=Sort%20Notes%20By"
        ),
        SettingsDestination(
            name: "notesNewNotesStartWith",
            urlString: "App-prefs:NOTES&path=New%20Notes%20Start%20With"
        ),
        SettingsDestination(
            name: "notesSortCheckedItems",
            urlString: "App-prefs:NOTES&path=Sort%20Checked%20Items"
        ),
        SettingsDestination(
            name: "notesLinesGrids",
            urlString: "App-prefs:NOTES&path=Lines%20%26%20Grids"
        ),
        SettingsDestination(
            name: "notesAccessNotesFromLockScreen",
            urlString: "App-prefs:NOTES&path=Access%20Notes%20from%20Lock%20Screen"
        ),
        SettingsDestination(
            name: "reminders",
            urlString: "App-prefs:REMINDERS"
        ),
        SettingsDestination(
            name: "remindersDefaultList",
            urlString: "App-prefs:REMINDERS&path=DEFAULT_LIST"
        ),
        SettingsDestination(
            name: "voiceMemos",
            urlString: "App-prefs:VOICE_MEMOS"
        ),
        SettingsDestination(
            name: "phone",
            urlString: "App-prefs:Phone"
        ),
        SettingsDestination(
            name: "messages",
            urlString: "App-prefs:MESSAGES"
        ),
        SettingsDestination(
            name: "faceTime",
            urlString: "App-prefs:FACETIME"
        ),
        SettingsDestination(
            name: "maps",
            urlString: "App-prefs:MAPS"
        ),
        SettingsDestination(
            name: "mapsDrivingNavigation",
            urlString: "App-prefs:MAPS&path=Driving%20%26%20Navigation"
        ),
        SettingsDestination(
            name: "mapsTransit",
            urlString: "App-prefs:MAPS&path=Transit"
        ),
        SettingsDestination(
            name: "compass",
            urlString: "App-prefs:COMPASS"
        ),
        SettingsDestination(
            name: "measure",
            urlString: "App-prefs:MEASURE"
        ),
        SettingsDestination(
            name: "safari",
            urlString: "App-prefs:SAFARI"
        ),
        SettingsDestination(
            name: "safariContentBlockers",
            urlString: "App-prefs:SAFARI&path=Content%20Blockers"
        ),
        SettingsDestination(
            name: "safariDownloads",
            urlString: "App-prefs:SAFARI&path=DOWNLOADS"
        ),
        SettingsDestination(
            name: "safariCloseTabs",
            urlString: "App-prefs:SAFARI&path=Close%20Tabs"
        ),
        SettingsDestination(
            name: "safariClearHistoryData",
            urlString: "App-prefs:SAFARI&path=CLEAR_HISTORY_AND_DATA"
        ),
        SettingsDestination(
            name: "safariPageZoom",
            urlString: "App-prefs:SAFARI&path=Page%20Zoom"
        ),
        SettingsDestination(
            name: "safariRequestDesktopWebsite",
            urlString: "App-prefs:SAFARI&path=Request%20Desktop%20Website"
        ),
        SettingsDestination(
            name: "safariReader",
            urlString: "App-prefs:SAFARI&path=Reader"
        ),
        SettingsDestination(
            name: "safariCamera",
            urlString: "App-prefs:SAFARI&path=Camera"
        ),
        SettingsDestination(
            name: "safariMicrophone",
            urlString: "App-prefs:SAFARI&path=Microphone"
        ),
        SettingsDestination(
            name: "safariLocation",
            urlString: "App-prefs:SAFARI&path=Location"
        ),
        SettingsDestination(
            name: "safariAdvanced",
            urlString: "App-prefs:SAFARI&path=ADVANCED"
        ),
        SettingsDestination(
            name: "news",
            urlString: "App-prefs:NEWS"
        ),
        SettingsDestination(
            name: "health",
            urlString: "App-prefs:HEALTH"
        ),
        SettingsDestination(
            name: "shortcuts",
            urlString: "App-prefs:SHORTCUTS"
        ),
        SettingsDestination(
            name: "music",
            urlString: "App-prefs:MUSIC"
        ),
        SettingsDestination(
            name: "musicCellularData",
            urlString: "App-prefs:MUSIC&path=com.apple.Music:CellularData"
        ),
        SettingsDestination(
            name: "musicOptimizeStorage",
            urlString: "App-prefs:MUSIC&path=com.apple.Music:OptimizeStorage"
        ),
        SettingsDestination(
            name: "musicEQ",
            urlString: "App-prefs:MUSIC&path=com.apple.Music:EQ"
        ),
        SettingsDestination(
            name: "musicVolumeLimit",
            urlString: "App-prefs:MUSIC&path=com.apple.Music:VolumeLimit"
        ),
        SettingsDestination(
            name: "tv",
            urlString: "App-prefs:TVAPP"
        ),
        SettingsDestination(
            name: "photos",
            urlString: "App-prefs:Photos"
        ),
        SettingsDestination(
            name: "camera",
            urlString: "App-prefs:CAMERA"
        ),
        SettingsDestination(
            name: "cameraRecordVideo",
            urlString: "App-prefs:CAMERA&path=Record%20Video"
        ),
        SettingsDestination(
            name: "cameraRecordSlowMotion",
            urlString: "App-prefs:CAMERA&path=Record%20Slo-mo"
        ),
        SettingsDestination(
            name: "books",
            urlString: "App-prefs:IBOOKS"
        ),
        SettingsDestination(
            name: "gameCenter",
            urlString: "App-prefs:GAMECENTER"
        )
    ]
}
#endif
