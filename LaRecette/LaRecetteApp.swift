//
//  LaRecetteApp.swift
//  LaRecette
//
//  Created by philip sidell on 3/8/25.
//

import SwiftUI
import SwiftData

@main
struct LaRecetteApp: App {
    var sharedModelContainer: ModelContainer

    @MainActor
    init() {
        var fixtureMode: String?
        #if DEBUG
        fixtureMode = ProcessInfo.processInfo.environment["LARECETTE_UI_FIXTURE"]
        #endif
        let schema = Schema([
            Recipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: fixtureMode != nil)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        #if DEBUG
        if let fixtureMode {
            InjectedValues[\.recipeService] = UIRecipeFixtureService(mode: fixtureMode, context: sharedModelContainer.mainContext)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
