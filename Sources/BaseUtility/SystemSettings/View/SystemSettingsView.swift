//
//  SystemSettingsView.swift
//  SystemSettingsExerciser
//
//  Created by Zakk Hoyt on 2/4/24.
//

import BaseUtility
import SwiftUI
#warning("FIXME: zakkhoyt - Clean this file up for use in a general app")
struct SystemSettingsView: View {
    @Environment(PermissionsViewModel.self)
    private var permissionsViewModel: PermissionsViewModel

    
    var viewModel = SystemSettingsViewModel()
    @State private var isPermissionSheetPresented = false
    
    var body: some View {
        VStack {
            NavigationView {
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
                // This property work for iOS, not macOS
//                .navigationBarTitle("System Settings", displayMode: .inline)
            }
            // This property work for iOS, not macOS
//            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    SystemSettingsView()
}
