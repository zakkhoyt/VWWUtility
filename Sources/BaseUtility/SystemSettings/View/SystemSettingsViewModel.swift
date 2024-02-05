//
//  SystemSettingsViewModel.swift
//  SystemSettingsExerciser
//
//  Created by Zakk Hoyt on 2/4/24.
//

import BaseUtility
import Foundation

@Observable
class SystemSettingsViewModel {
    struct Section: Identifiable {
        struct Item: Identifiable {
            var id: String { path }
            let title: String
            let path: String
            let generalURLString: String
            let appURLString: String
            let urlProvider: any SystemSettingsURLProvider
        }
        
        var id: String { title }
        let title: String
        let items: [Item]
        let category: any SystemSettingsURLProvider.Type
    }
    
    
    let sections: [Section]
    init() {
        self.sections = SystemSettings.categories.enumerated().map { section in
            Section(
                title: String(describing: section.element),
                items: {
                    guard let children: [any SystemSettingsURLProvider] = section.element.allCases as? [any SystemSettingsURLProvider] else {
                        return []
                    }
                    return children.enumerated().map { item in
                        Section.Item(
                            title: String(describing: item.element),
                            path: "\(String(describing: section.element))/\(String(describing: item.element))",
                            generalURLString: item.element.rawValue,
                            appURLString: item.element.appSpecificUrl.absoluteString,
                            urlProvider: item.element
                        )
                    }
                }(),
                category: section.element.self
            )
        }
    }    
}
