//
//  ContentView.swift
//  ComputerVisionPets
//
//  Created by Zakk Hoyt on 2/27/24.
//

import AVFoundation
import SwiftUI
import UIKit

@available(macCatalyst 17.0, *)
public struct CameraView: View {
    let captureService: CaptureService
    let captureSessionView: CaptureVideoPreviewView
    @State var isCameraSettingsPickerActive: Bool = false
//    private let captureDeviceSettingsViewModel = CaptureDeviceSettingsViewModel()
    
    public init(
        captureService: CaptureService
    ) {
        logger.debug("\(#file) \(#function) \(#line)")
        self.captureService = captureService
        #warning("FIXME: zakkhoyt - avoid exposing CaptureService directly")
        self.captureSessionView = CaptureVideoPreviewView(source: captureService.previewSource)
    }
    
    public var body: some View {
        ZStack {
            captureSessionView
//            // Overlay a toolbar type view
//            VStack {
//                Spacer()
//                ZStack {
//                    Rectangle()
//                        .fill(Color.red.opacity(0.25))
//                        .frame(height: 100)
//                    HStack {
//                        Spacer()
//                        Button {
//                            isCameraSettingsPickerActive = true
//                        } label: {
//                            Text("Capture\nSettings")
//                        }
//                        .padding()
//                    }
//                }
//            }
//        }
//        .sheet(
//            isPresented: $isCameraSettingsPickerActive
//        ) {
//            CaptureDeviceSettingsView(
//                isPresented: $isCameraSettingsPickerActive,
//                viewModel: captureDeviceSettingsViewModel
//            )
//        }
//        .onAppear {
//            captureDeviceSettingsViewModel.didCollectNewSettings = {
//                guard let format = $0.captureFormat?.format else { return }
//                guard let captureDevice = $0.captureDevice?.captureDevice else { return }
//                Task {
//                    await captureService.setCaptureFormat(format, captureDevice: captureDevice)
//                }
//            }
        }
    }
}

#Preview {
    if #available(macCatalyst 17.0, *) {
        CameraView(captureService: CaptureService())
    } else {
        // Fallback on earlier versions
    }
}
