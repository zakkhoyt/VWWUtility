//
//  SessionView.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/2/23.
//

import MultipeerEngine
import SwiftUI

struct SessionView: View {
    @State var viewModel: SessionViewModel
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.connectedPeers.keys) { peerID in
                        HStack {
                            Text("\(peerID.name)")
                            Spacer()
                            Button(
                                action: {
                                    try? viewModel.engine.send(text: "\(UInt8.random(in: 0..<UInt8.max))")
//                                    try? viewModel.engine.send(codable: User.testUser)
                                },
                                label: {
                                    Text("Send")
                                        .font(.caption2)
                                }
                            )
                        }
                    }
                } header: {
                    Text("Connected Peers: \(viewModel.connectedPeers.count)")
                }

                Section {
                    ForEach(viewModel.payloadWrappers) { payload in
                        if payload.isMine {
                            VStack {
                                HStack {
                                    Text("\(payload.time)")
                                        .font(.caption2)
                                    Spacer()
                                    Text("Me (\(payload.connectedPeer.name))")
                                        .font(.caption2)
                                }
                                Group {
                                    HStack {
                                        Spacer()
                                        Text(payload.text)
                                    }
                                    .padding([.top, .bottom, .leading, .trailing], 4)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(.blue)
                                )
                            }
                        } else {
                            VStack {
                                HStack {
                                    Text("\(payload.time) \(payload.connectedPeer.name)")
                                        .font(.caption2)
                                    Spacer()
                                }
                                Group {
                                    HStack {
                                        Text(payload.text)
                                        Spacer()
                                    }
                                    .padding([.top, .bottom, .leading, .trailing], 4)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(.green)
                                )
                            }
                        }
                    }
                } header: {
                    Text("Payloads: \(viewModel.payloadWrappers.count)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    SessionView(
        viewModel: SessionViewModel(
            engine: .preview
        )
    )
}
