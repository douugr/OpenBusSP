//
//  OpenBusSPApp.swift
//  OpenBusSP
//
//  Created by Douglas Neto on 08/06/26.
//

import SwiftUI
import SwiftData

@main
struct OpenBusSPApp: App {
    @StateObject private var dependencies = AppDependencies()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            ContentView()
                .environmentObject(dependencies)
        }
        .modelContainer(sharedModelContainer)
    }
}
