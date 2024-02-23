//
//  SystemSettingsView.swift
//  VWWUtility.BaseUtility
//
//  Created by Zakk Hoyt on 2/4/24.
//

import SwiftUI

@available(iOS 17.0, *)
public struct SystemSettingsView: View {
    private var viewModel = SystemSettingsViewModel()
    @State private var isPermissionSheetPresented = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            List(viewModel.sections) { section in
                Section(section.title) {
                    ForEach(section.items) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            Button("", systemImage: "gear") {
                                SystemSettings.open(
                                    item.urlProvider,
                                    appSpecific: false
                                )
                            }
                            .buttonStyle(.plain)

                            Button("", systemImage: "app.badge") {
                                SystemSettings.open(
                                    item.urlProvider,
                                    appSpecific: true
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .onTapGesture {
                            print("row")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        SystemSettingsView()
    } else {
        // Fallback on earlier versions
        preconditionFailure()
    }
}
