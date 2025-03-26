//
//  BrowserView.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/2/23.
//

import MultipeerEngine
import SwiftUI

struct BrowserView: View {
    @State var viewModel: BrowserViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Discovered Services")
            List(viewModel.advertisedServices) { service in
                HStack {
                    Text("\(service.peerID.displayName)")
                    if let activity = service.discoveryInfo?[MPEngine.Advertiser.DiscoveryInfo.activityKey] {
                        Text("\(activity)").font(.smallCaps(Font.caption2)())
                    }
                    
                    Spacer()
                    
                    switch service.invitationState {
                    case .notSent:
                        Button(
                            action: {
                                logger.debug("On Tap: Send invite to service: \(service)")
                                viewModel.engine.invite(service: service, timeout: 10)
                            },
                            label: {
                                Text("➕ Join")
                                    .font(.caption2)
                            }
                        )
                    
                    case .invitationSent,
                         .invitationAccepted,
                         .invitationRejected,
                         .invitationTimedOut:
                        Text("\(service.invitationState.description)")
                            .font(.caption2)
                    }
                }
            }
            
            Spacer()
            
            Button(
                action: {
                    logger.debug("On Tap: Browser -> Session")
                    viewModel.pushSession()
                },
                label: {
                    Text("Session -> ")
                }
            )
        }
        .navigationTitle("Browser (Client)")
        .navigationDestination(isPresented: $viewModel.isPresentingSession) {
            if viewModel.isPresentingSession {
                SessionView(
                    viewModel: SessionViewModel(
                        engine: viewModel.engine
                    )
                )
            }
        }

        .padding()
    }
}

#Preview {
    BrowserView(
        viewModel: BrowserViewModel(
            engine: .preview,
            browser: MPEngine.preview.startBrowsing(serviceName: ServiceName.testService)
        )
    )
}
