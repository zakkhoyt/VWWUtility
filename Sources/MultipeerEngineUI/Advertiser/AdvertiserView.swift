//
//  AdvertiserView.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/2/23.
//

import MultipeerEngine
import SwiftUI

struct AdvertiserView: View {
    @State var viewModel: AdvertiserViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Invites")
           // List(viewModel.invitations) { invitation in
            ForEach(viewModel.invitations) { invitation in
                HStack {
                    Text("\(invitation.peerID.displayName)")
                    
                    Spacer()
                    
                    switch invitation.response {
                    case .noResponse:
                        Button(
                            action: {
                                logger.debug("On Tap: Accept invite: \(invitation)")
                                viewModel.engine.respond(invitation: invitation, accept: true)
                            },
                            label: {
                                Text("👍 Accept")
                                    .font(.caption2)
                            }
                        )
                        .border(Color.green)

#warning("""
FIXME: zakkhoyt - These two buttons get Z stacked somehow.
* Tapping on accept fires the reject action 
""")
                        Button(
                            action: {
                                logger.debug("On Tap: Reject invite: \(invitation)")
                                viewModel.engine.respond(invitation: invitation, accept: false)
                            },
                            label: {
                                Text("👎🏻 Reject")
                                    .font(.caption2)
                            }
                        )
                        .border(Color.red)

                    case .accepted:
                        Text("Accepted")
                            .font(.caption2)
                    case .rejected:
                        Text("Rejected")
                            .font(.caption2)
                    }
                }
            }
            Spacer()
            
            Button(
                action: {
                    logger.debug("On Tap: Browser -> Session")
                    viewModel.isPresentingSession = true
                },
                label: {
                    Text("Session -> ")
                }
            )
        }
        .navigationTitle("Advertiser (Host)")
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
    AdvertiserView(
        viewModel: AdvertiserViewModel(
            engine: .preview,
            advertiser: MPEngine.preview.startAdvertising(
                serviceName: ServiceName.testService,
                discoveryInfo: [
                    MPEngine.Advertiser.DiscoveryInfo.activityKey: "Tic Tac Toe"
                ]
            )
        )
    )
}
