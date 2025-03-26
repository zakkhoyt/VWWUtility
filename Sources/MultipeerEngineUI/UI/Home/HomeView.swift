//
//  HomeView.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/2/23.
//

import MultipeerEngine
public import SwiftUI

public struct ServiceName {
    public static let testService = "vww-mpdev"
}

public struct HomeView: View {
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public enum MPFunction {
        case browser
        case advertiser
    }

    @State
    public var viewModel: HomeViewModel
    
    public var body: some View {
        NavigationStack {
            VStack {
                List {
                    Button(
                        action: {
                            Task {
                                logger.debug("On Tap: Advertise")
                                await viewModel.startAdvertising()
                            }
                        },
                        label: {
                            Text("Advertise")
                        }
                    )
                    
                    Button(
                        action: {
                            logger.debug("On Tap: Browse")
                            viewModel.startBrowsing()
                        },
                        label: {
                            Text("Browse")
                        }
                    )
                }
                .navigationDestination(isPresented: $viewModel.isPresentingAdvertiser) {
                    if viewModel.isPresentingAdvertiser,
                       case .advertiser(let advertiser) = viewModel.navigationDestinationData {
                        AdvertiserView(
                            viewModel: AdvertiserViewModel(
                                engine: viewModel.engine,
                                advertiser: advertiser
                            )
                        )
                    }
                }
                .navigationDestination(isPresented: $viewModel.isPresentingBrowser) {
                    if viewModel.isPresentingBrowser,
                       case .browser(let browser) = viewModel.navigationDestinationData {
                        BrowserView(
                            viewModel: BrowserViewModel(
                                engine: viewModel.engine,
                                browser: browser
                            )
                        )
                    }
                }
                .navigationTitle("Mode")
            }
            
            Spacer()
            Text(viewModel.versionAndBuild)
                .font(.caption2)
        }
        
        .padding()
        .task {
            if ProcessInfo.processInfo.arguments.contains("--mode=browser") {
                viewModel.startBrowsing()
            } else if ProcessInfo.processInfo.arguments.contains("--mode=advertiser") {
                viewModel.startAdvertising()
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(engine: .preview)
    )
}
