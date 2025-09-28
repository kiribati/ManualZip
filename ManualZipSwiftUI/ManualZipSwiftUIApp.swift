//
//  ManualZipSwiftUIApp.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

@main
struct ManualZipSwiftUIApp: App {
    @State private var isIntroShown = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ManualItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isIntroShown {
                IntroView {
                    isIntroShown = false
                }
            } else {
                HomeView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
