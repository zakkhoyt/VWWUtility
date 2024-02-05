
// https://stackoverflow.com/a/35987082/803882
// https://stackoverflow.com/a/8246814/803882



// https://www.macstories.net/ios/a-comprehensive-guide-to-all-120-settings-urls-supported-by-ios-and-ipados-13-1/
// https://forums.macrumors.com/threads/manually-creating-settings-launchers-in-app-launching-apps.2037291/
// https://developer.apple.com/documentation/uikit/uiapplication/4013180-opennotificationsettingsurlstrin

// https://www.icloud.com/shortcuts/381d0ab479dc4808bf16f47b738cc526


import Foundation

public struct SettingsDestination: Identifiable {
    public let name: String
    public let urlString: String
    public var id: String { urlString }
}

extension SettingsDestination {
    public static let all: [SettingsDestination] = [
        SettingsDestination(
            name: "iCloud", 
            urlString: "prefs:root=CASTLE"
        ),
        SettingsDestination(
            name: "iCloudBackup", 
            urlString: "prefs:root=CASTLE&path=BACKUP"
        ),
        SettingsDestination(
            name: "wifi", 
            urlString: "prefs:root=WIFI"
        ),
        SettingsDestination(
            name: "bluetooth", 
            urlString: "prefs:root=Bluetooth"
        ),
        SettingsDestination(
            name: "cellular", 
            urlString: "prefs:root=MOBILE_DATA_SETTINGS_ID"
        ),
        SettingsDestination(
            name: "tethering", 
            urlString: "prefs:root=INTERNET_TETHERING"
        ),
        SettingsDestination(
            name: "familySharing", 
            urlString: "prefs:root=INTERNET_TETHERING&path=Family%20Sharing"
        ),
        SettingsDestination(
            name: "wifiPassword", 
            urlString: "prefs:root=INTERNET_TETHERING&path=Wi-Fi%20Password"
        ),
        SettingsDestination(
            name: "vpn", 
            urlString: "prefs:root=General&path=VPN"
        ),
        SettingsDestination(
            name: "dns", 
            urlString: "prefs:root=General&path=VPN/DNS"
        ),
        SettingsDestination(
            name: "notifications", 
            urlString: "prefs:root=NOTIFICATIONS_ID"
        ),
        SettingsDestination(
            name: "notificationsSriSuggestions", 
            urlString: "prefs:root=NOTIFICATIONS_ID&path=Siri%20Suggestions"
        ),
        SettingsDestination(
            name: "sounds", 
            urlString: "prefs:root=Sounds"
        ),
        SettingsDestination(
            name: "soundsRingtone", 
            urlString: "prefs:root=Sounds&path=Ringtone"
        ),
        SettingsDestination(
            name: "doNotDisturb", 
            urlString: "prefs:root=DO_NOT_DISTURB"
        ),
        SettingsDestination(
            name: "doNotDisturbAllowCallsFrom", 
            urlString: "prefs:root=DO_NOT_DISTURB&path=Allow%20Calls%20From"
        ),
        SettingsDestination(
            name: "screenTime", 
            urlString: "prefs:root=SCREEN_TIME"
        ),
        SettingsDestination(
            name: "screenTimeDowntime", 
            urlString: "prefs:root=SCREEN_TIME&path=DOWNTIME"
        ),
        SettingsDestination(
            name: "screenTimeAppLimits", 
            urlString: "prefs:root=SCREEN_TIME&path=APP_LIMITS"
        ),
        SettingsDestination(
            name: "screenTimeAlwaysAllowed", 
            urlString: "prefs:root=SCREEN_TIME&path=ALWAYS_ALLOWED"
        ),
        SettingsDestination(
            name: "general", 
            urlString: "prefs:root=General"
        ),
        SettingsDestination(
            name: "generalAbout", 
            urlString: "prefs:root=General&path=About"
        ),
        SettingsDestination(
            name: "generalSoftwareUpdate", 
            urlString: "prefs:root=General&path=SOFTWARE_UPDATE_LINK"
        ),
        SettingsDestination(
            name: "generalCarPlay", 
            urlString: "prefs:root=General&path=CARPLAY"
        ),
        SettingsDestination(
            name: "generalBackgroundAppRefresh", 
            urlString: "prefs:root=General&path=AUTO_CONTENT_DOWNLOAD"
        ),
        SettingsDestination(
            name: "generalMultitasking", 
            urlString: "prefs:root=General&path=MULTITASKING"
        ),  // iPad-only
        SettingsDestination(
            name: "generalDateTime", 
            urlString: "prefs:root=General&path=DATE_AND_TIME"
        ),
        SettingsDestination(
            name: "generalKeyboard", 
            urlString: "prefs:root=General&path=Keyboard"
        ),
        SettingsDestination(
            name: "generalKeyboardKeyboards", 
            urlString: "prefs:root=General&path=Keyboard/KEYBOARDS"
        ),
        SettingsDestination(
            name: "generalKeyboardHardwareKeyboard", 
            urlString: "prefs:root=General&path=Keyboard/Hardware%20Keyboard"
        ),
        SettingsDestination(
            name: "generalKeyboardTextReplacement", 
            urlString: "prefs:root=General&path=Keyboard/USER_DICTIONARY"
        ),
        SettingsDestination(
            name: "generalKeyboardOneHandedKeyboard", 
            urlString: "prefs:root=General&path=Keyboard/ReachableKeyboard"
        ),
        SettingsDestination(
            name: "generalLanguageRegion", 
            urlString: "prefs:root=General&path=INTERNATIONAL"
        ),
        SettingsDestination(
            name: "generalDictionary", 
            urlString: "prefs:root=General&path=DICTIONARY"
        ),
        SettingsDestination(
            name: "generalProfiles", 
            urlString: "prefs:root=General&path=ManagedConfigurationList"
        ),
        SettingsDestination(
            name: "generalReset", 
            urlString: "prefs:root=General&path=Reset"
        ),
        SettingsDestination(
            name: "controlCenter", 
            urlString: "prefs:root=ControlCenter"
        ),
        SettingsDestination(
            name: "controlCenterCustomizeControls", 
            urlString: "prefs:root=ControlCenter&path=CUSTOMIZE_CONTROLS"
        ),
        SettingsDestination(
            name: "display", 
            urlString: "prefs:root=DISPLAY"
        ),
        SettingsDestination(
            name: "displayAutoLock", 
            urlString: "prefs:root=DISPLAY&path=AUTOLOCK"
        ),
        SettingsDestination(
            name: "displayTextSize", 
            urlString: "prefs:root=DISPLAY&path=TEXT_SIZE"
        ),
        SettingsDestination(
            name: "accessibility", 
            urlString: "prefs:root=ACCESSIBILITY"
        ),
        SettingsDestination(
            name: "wallpaper", 
            urlString: "prefs:root=Wallpaper"
        ),
        SettingsDestination(
            name: "siri", 
            urlString: "prefs:root=SIRI"
        ),
        SettingsDestination(
            name: "applePencil", 
            urlString: "prefs:root=Pencil"
        ), // iPad-only
        SettingsDestination(
            name: "faceID", 
            urlString: "prefs:root=PASSCODE"
        ),
        SettingsDestination(
            name: "emergencySOS", 
            urlString: "prefs:root=EMERGENCY_SOS"
        ),
        SettingsDestination(
            name: "batteryUsage", 
            urlString: "prefs:root=BATTERY_USAGE"
        ),
        SettingsDestination(
            name: "batteryUsageHealth", 
            urlString: "prefs:root=BATTERY_USAGE&path=BATTERY_HEALTH"
        ), // iPhone-only
        SettingsDestination(
            name: "privacy", 
            urlString: "prefs:root=Privacy"
        ),
        SettingsDestination(
            name: "privacyLocationServices", 
            urlString: "prefs:root=Privacy&path=LOCATION"
        ),
        SettingsDestination(
            name: "privacyContacts", 
            urlString: "prefs:root=Privacy&path=CONTACTS"
        ),
        SettingsDestination(
            name: "privacyCalendars", 
            urlString: "prefs:root=Privacy&path=CALENDARS"
        ),
        SettingsDestination(
            name: "privacyReminders", 
            urlString: "prefs:root=Privacy&path=REMINDERS"
        ),
        SettingsDestination(
            name: "privacyPhotos", 
            urlString: "prefs:root=Privacy&path=PHOTOS"
        ),
        SettingsDestination(
            name: "privacyMicrophone", 
            urlString: "prefs:root=Privacy&path=MICROPHONE"
        ),
        SettingsDestination(
            name: "privacySpeechRecognition", 
            urlString: "prefs:root=Privacy&path=SPEECH_RECOGNITION"
        ),
        SettingsDestination(
            name: "privacyCamera", 
            urlString: "prefs:root=Privacy&path=CAMERA"
        ),
        SettingsDestination(
            name: "privacyMotion", 
            urlString: "prefs:root=Privacy&path=MOTION"
        ),
        SettingsDestination(
            name: "privacyAnalyticsImprovements", 
            urlString: "prefs:root=Privacy&path=PROBLEM_REPORTING"
        ),
        SettingsDestination(
            name: "privacyAppleAdvertising", 
            urlString: "prefs:root=Privacy&path=ADVERTISING"
        ),
        SettingsDestination(
            name: "appStore", 
            urlString: "prefs:root=STORE"
        ),
        SettingsDestination(
            name: "appStoreAppDownloads", 
            urlString: "prefs:root=STORE&path=App%20Downloads"
        ),
        SettingsDestination(
            name: "appStoreVideoAutoplay", 
            urlString: "prefs:root=STORE&path=Video%20Autoplay"
        ),
        SettingsDestination(
            name: "wallet", 
            urlString: "prefs:root=PASSBOOK"
        ),
        SettingsDestination(
            name: "passwords", 
            urlString: "prefs:root=PASSWORDS"
        ),
        SettingsDestination(
            name: "mail", 
            urlString: "prefs:root=MAIL"
        ),
        SettingsDestination(
            name: "mailAccounts", 
            urlString: "prefs:root=ACCOUNTS_AND_PASSWORDS&path=ACCOUNTS"
        ),
        SettingsDestination(
            name: "mailAccountsFetchNewData", 
            urlString: "prefs:root=ACCOUNTS_AND_PASSWORDS&path=FETCH_NEW_DATA"
        ),
        SettingsDestination(
            name: "mailAccountsAddAccount", 
            urlString: "prefs:root=ACCOUNTS_AND_PASSWORDS&path=ADD_ACCOUNT"
        ),
        SettingsDestination(
            name: "mailPreview", 
            urlString: "prefs:root=MAIL&path=Preview"
        ),
        SettingsDestination(
            name: "mailSwipeOptions", 
            urlString: "prefs:root=MAIL&path=Swipe%20Options"
        ),
        SettingsDestination(
            name: "mailNotifications", 
            urlString: "prefs:root=MAIL&path=NOTIFICATIONS"
        ),
        SettingsDestination(
            name: "mailBlocked", 
            urlString: "prefs:root=MAIL&path=Blocked"
        ),
        SettingsDestination(
            name: "mailMutedThreadAction", 
            urlString: "prefs:root=MAIL&path=Muted%20Thread%20Action"
        ),
        SettingsDestination(
            name: "mailBlockedSenderOptions", 
            urlString: "prefs:root=MAIL&path=Blocked%20Sender%20Options"
        ),
        SettingsDestination(
            name: "mailMarkAddresses", 
            urlString: "prefs:root=MAIL&path=Mark%20Addresses"
        ),
        SettingsDestination(
            name: "mailIncreaseQuoteLevel", 
            urlString: "prefs:root=MAIL&path=Increase%20Quote%20Level"
        ),
        SettingsDestination(
            name: "mailIncludeAttachmentsWithReplies", 
            urlString: "prefs:root=MAIL&path=Include%20Attachments%20with%20Replies"
        ),
        SettingsDestination(
            name: "mailSignature", 
            urlString: "prefs:root=MAIL&path=Signature"
        ),
        SettingsDestination(
            name: "mailDefaultAccount", 
            urlString: "prefs:root=MAIL&path=Default%20Account"
        ),
        SettingsDestination(
            name: "contacts", 
            urlString: "prefs:root=CONTACTS"
        ),
        SettingsDestination(
            name: "calendar", 
            urlString: "prefs:root=CALENDAR"
        ),
        SettingsDestination(
            name: "calendarAlternateCalendars", 
            urlString: "prefs:root=CALENDAR&path=Alternate%20Calendars"
        ),
        SettingsDestination(
            name: "calendarSync", 
            urlString: "prefs:root=CALENDAR&path=Sync"
        ),
        SettingsDestination(
            name: "calendarDefaultAlertTimes", 
            urlString: "prefs:root=CALENDAR&path=Default%20Alert%20Times"
        ),
        SettingsDestination(
            name: "calendarDefaultCalendar", 
            urlString: "prefs:root=CALENDAR&path=Default%20Calendar"
        ),
        SettingsDestination(
            name: "notes", 
            urlString: "prefs:root=NOTES"
        ),
        SettingsDestination(
            name: "notesDefaultAccount", 
            urlString: "prefs:root=NOTES&path=Default%20Account"
        ),
        SettingsDestination(
            name: "notesPassword", 
            urlString: "prefs:root=NOTES&path=Password"
        ),
        SettingsDestination(
            name: "notesSortNotesBy", 
            urlString: "prefs:root=NOTES&path=Sort%20Notes%20By"
        ),
        SettingsDestination(
            name: "notesNewNotesStartWith", 
            urlString: "prefs:root=NOTES&path=New%20Notes%20Start%20With"
        ),
        SettingsDestination(
            name: "notesSortCheckedItems", 
            urlString: "prefs:root=NOTES&path=Sort%20Checked%20Items"
        ),
        SettingsDestination(
            name: "notesLinesGrids", 
            urlString: "prefs:root=NOTES&path=Lines%20%26%20Grids"
        ),
        SettingsDestination(
            name: "notesAccessNotesFromLockScreen", 
            urlString: "prefs:root=NOTES&path=Access%20Notes%20from%20Lock%20Screen"
        ),
        SettingsDestination(
            name: "reminders", 
            urlString: "prefs:root=REMINDERS"
        ),
        SettingsDestination(
            name: "remindersDefaultList", 
            urlString: "prefs:root=REMINDERS&path=DEFAULT_LIST"
        ),
        SettingsDestination(
            name: "voiceMemos", 
            urlString: "prefs:root=VOICE_MEMOS"
        ),
        SettingsDestination(
            name: "phone", 
            urlString: "prefs:root=Phone"
        ),
        SettingsDestination(
            name: "messages", 
            urlString: "prefs:root=MESSAGES"
        ),
        SettingsDestination(
            name: "faceTime", 
            urlString: "prefs:root=FACETIME"
        ),
        SettingsDestination(
            name: "maps", 
            urlString: "prefs:root=MAPS"
        ),
        SettingsDestination(
            name: "mapsDrivingNavigation", 
            urlString: "prefs:root=MAPS&path=Driving%20%26%20Navigation"
        ),
        SettingsDestination(
            name: "mapsTransit", 
            urlString: "prefs:root=MAPS&path=Transit"
        ),
        SettingsDestination(
            name: "compass", 
            urlString: "prefs:root=COMPASS"
        ),
        SettingsDestination(
            name: "measure", 
            urlString: "prefs:root=MEASURE"
        ),
        SettingsDestination(
            name: "safari", 
            urlString: "prefs:root=SAFARI"
        ),
        SettingsDestination(
            name: "safariContentBlockers", 
            urlString: "prefs:root=SAFARI&path=Content%20Blockers"
        ),
        SettingsDestination(
            name: "safariDownloads", 
            urlString: "prefs:root=SAFARI&path=DOWNLOADS"
        ),
        SettingsDestination(
            name: "safariCloseTabs", 
            urlString: "prefs:root=SAFARI&path=Close%20Tabs"
        ),
        SettingsDestination(
            name: "safariClearHistoryData", 
            urlString: "prefs:root=SAFARI&path=CLEAR_HISTORY_AND_DATA"
        ),
        SettingsDestination(
            name: "safariPageZoom", 
            urlString: "prefs:root=SAFARI&path=Page%20Zoom"
        ),
        SettingsDestination(
            name: "safariRequestDesktopWebsite", 
            urlString: "prefs:root=SAFARI&path=Request%20Desktop%20Website"
        ),
        SettingsDestination(
            name: "safariReader", 
            urlString: "prefs:root=SAFARI&path=Reader"
        ),
        SettingsDestination(
            name: "safariCamera", 
            urlString: "prefs:root=SAFARI&path=Camera"
        ),
        SettingsDestination(
            name: "safariMicrophone", 
            urlString: "prefs:root=SAFARI&path=Microphone"
        ),
        SettingsDestination(
            name: "safariLocation", 
            urlString: "prefs:root=SAFARI&path=Location"
        ),
        SettingsDestination(
            name: "safariAdvanced", 
            urlString: "prefs:root=SAFARI&path=ADVANCED"
        ),
        SettingsDestination(
            name: "news", 
            urlString: "prefs:root=NEWS"
        ),
        SettingsDestination(
            name: "health", 
            urlString: "prefs:root=HEALTH"
        ),
        SettingsDestination(
            name: "shortcuts", 
            urlString: "prefs:root=SHORTCUTS"
        ),
        SettingsDestination(
            name: "music", 
            urlString: "prefs:root=MUSIC"
        ),
        SettingsDestination(
            name: "musicCellularData", 
            urlString: "prefs:root=MUSIC&path=com.apple.Music:CellularData"
        ),
        SettingsDestination(
            name: "musicOptimizeStorage", 
            urlString: "prefs:root=MUSIC&path=com.apple.Music:OptimizeStorage"
        ),
        SettingsDestination(
            name: "musicEQ", 
            urlString: "prefs:root=MUSIC&path=com.apple.Music:EQ"
        ),
        SettingsDestination(
            name: "musicVolumeLimit", 
            urlString: "prefs:root=MUSIC&path=com.apple.Music:VolumeLimit"
        ),
        SettingsDestination(
            name: "tv", 
            urlString: "prefs:root=TVAPP"
        ),
        SettingsDestination(
            name: "photos", 
            urlString: "prefs:root=Photos"
        ),
        SettingsDestination(
            name: "camera", 
            urlString: "prefs:root=CAMERA"
        ),
        SettingsDestination(
            name: "cameraRecordVideo", 
            urlString: "prefs:root=CAMERA&path=Record%20Video"
        ),
        SettingsDestination(
            name: "cameraRecordSlowMotion", 
            urlString: "prefs:root=CAMERA&path=Record%20Slo-mo"
        ),
        SettingsDestination(
            name: "books", 
            urlString: "prefs:root=IBOOKS"
        ),
        SettingsDestination(
            name: "gameCenter", 
            urlString: "prefs:root=GAMECENTER"
        )
    ]
}
