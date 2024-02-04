//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 2/3/24.
//

import AppKit
import Foundation

class HIDNSEventListener {
    // MARK: Nested Types
    
    enum Error: Swift.Error {
        case failedToStartEventMonitor
    }
    
    private var monitors = [Any]()
    
    func start(
        mask: NSEvent.EventTypeMask,
        scope: HIDEventScope,
        handler: @escaping (NSEvent) -> NSEvent?
    ) throws {
        guard let localKeyDownMonitor = NSEvent.addLocalMonitorForEvents(
            matching: mask,
            handler: handler
        ) else {
            throw Error.failedToStartEventMonitor
        }
        monitors.append(localKeyDownMonitor)
    }
    
    func stop() {
        monitors.forEach {
            NSEvent.removeMonitor($0)
        }
        monitors.removeAll()
    }
}

//
//class GlobalNSEventMonitor {
//    // MARK: Nested Types
//    
//    enum Error: Swift.Error {
//        case failedToStartEventMonitor
//    }
//    
//    private var monitors = [Any]()
//    
//    func start(
//        mask: NSEvent.EventTypeMask,
//        handler: @escaping (NSEvent) -> Void
//    ) throws {
//        guard let globalKeyDownMonitor = NSEvent.addGlobalMonitorForEvents(
//            matching: [.keyDown, .keyUp, .flagsChanged],
//            handler: {
//                handler($0)
//            }
//        ) else {
//            throw Error.failedToStartEventMonitor
//        }
//        monitors.append(globalKeyDownMonitor)
//    }
//    
//    func stop() {
//        monitors.forEach {
//            NSEvent.removeMonitor($0)
//        }
//        monitors.removeAll()
//    }
//}
//
