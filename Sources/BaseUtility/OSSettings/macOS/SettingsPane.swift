//
//  AccessibilitySettings.swift
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

public protocol SettingsPaneURLProvider: CaseIterable, RawRepresentable where RawValue == String {
    associatedtype rawValue = String
}

extension SettingsPaneURLProvider where RawValue == String {
    public var urlString: String {
        self.rawValue
    }
    
    public var url: URL {
        guard let url = URL(string: urlString) else {
            preconditionFailure("Failed to create URL from \(urlString)")
        }
        return url
    }
}

//func t() {
//    SettingsPane.navigateTo(SettingsPane.SoftwareUpdate.softwareUpdate)
//    //SettingsPane.navigateTo(SettingsPane.PrivacyAndSecurity.privacyInputMonitoring)
//}

public enum SettingsPane {
    public static func navigateTo(
        _ pane: any SettingsPaneURLProvider
    ) {
        NSWorkspace.shared.open(pane.url)
    }

    public enum SoftwareUpdate: String, SettingsPaneURLProvider {
        case softwareUpdate = "x-apple.systempreferences:com.apple.preferences.softwareupdate?client=softwareupdateapp"
    }
    
    // Accessibility Preference Pane
    public enum Accessibility: String, SettingsPaneURLProvider {
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
    public enum PrivacyAndSecurity: String, SettingsPaneURLProvider {
        case main = "x-apple.systempreferences:com.apple.preference.security"
        case general = "x-apple.systempreferences:com.apple.preference.security?General"
        case fileVault = "x-apple.systempreferences:com.apple.preference.security?FDE"
        case firewall = "x-apple.systempreferences:com.apple.preference.security?Firewall"
        case advanced = "x-apple.systempreferences:com.apple.preference.security?Advanced"
        case privacy = "x-apple.systempreferences:com.apple.preference.security?Privacy"
        case privacyCamera = "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"
        case privacyMicrophone = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
        case privacyAutomation = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
        case privacyAllFiles = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        case privacyAccessibility = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        case privacyAssistive = "x-apple.systempreferences:com.apple.preference.security?Privacy_Assistive"
        case privacyLocationServices = "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
        case privacySystemServices = "x-apple.systempreferences:com.apple.preference.security?Privacy_SystemServices"
        case privacyAdvertising = "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"
        case privacyContacts = "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
        case privacyDiagnosticsUsage = "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"
        case privacyCalendars = "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
        case privacyReminders = "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
        case privacyFacebook = "x-apple.systempreferences:com.apple.preference.security?Privacy_Facebook"
        case privacyLinkedIn = "x-apple.systempreferences:com.apple.preference.security?Privacy_LinkedIn"
        case privacyTwitter = "x-apple.systempreferences:com.apple.preference.security?Privacy_Twitter"
        case privacyWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_Weibo"
        case privacyTencentWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_TencentWeibo"
        
        // macOS Catalina 10.15:
        case privacyScreenCapture = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
        case privacyDevTools = "x-apple.systempreferences:com.apple.preference.security?Privacy_DevTools"
        case privacyInputMonitoring = "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
        case privacyDesktopFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DesktopFolder"
        case privacyDocumentsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DocumentsFolder"
        case privacyDownloadsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DownloadsFolder"
        case privacyNetworkVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_NetworkVolume"
        case privacyRemovableVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_RemovableVolume"
        case privacySpeechRecognition = "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition"
    }
    
    // Dictation & Speech Preference Pane
    public enum Dictation: String, SettingsPaneURLProvider {
        case dictation = "x-apple.systempreferences:com.apple.preference.speech?Dictation"
        case textToSpeech = "x-apple.systempreferences:com.apple.preference.speech?TTS"
    }
    
    // Sharing Preference Pane
    public enum Sharing: String, SettingsPaneURLProvider {
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

extension SettingsPane {
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
        //#warning("TODO: zakkhoyt - https://developer.apple.com/documentation/swiftui/settingslink")
        //#warning("TODO: zakkhoyt - https://stackoverflow.com/questions/65355696/how-to-programatically-open-settings-preferences-window-in-a-macos-swiftui-app/72803389#72803389")
        //                    // https://support.apple.com/guide/mac-help/change-privacy-security-settings-on-mac-mchl211c911f/mac
        //                }
        

        
        
        /// `NSEvent.addGlobalMonitorForEvents` will not work unless `AXIsProcessTrusted()` returns true
        /// `AXIsProcessTrusted()` will not return true unless the user adds this app to `Accessibilty` privacy list
        /// Finally `NSEvent.addGlobalMonitorForEvents` also needs the user to add this app to `Input Monitorying` privacy list.

    }

    //
//#import "MJAccessibilityUtils.h"
//#import "HSLogger.h"
//
//extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));
//extern CFStringRef kAXTrustedCheckOptionPrompt __attribute__((weak_import));
//
//
//BOOL MJAccessibilityIsEnabled(void) {
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
//}
//
//void MJAccessibilityOpenPanel(void) {
//    if (AXIsProcessTrustedWithOptions != NULL) {
//        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{(__bridge id)kAXTrustedCheckOptionPrompt: @YES});
//    }
//    else {
//        static NSString* script = @"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell";
//        [[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
//    }
//}
}
#endif
