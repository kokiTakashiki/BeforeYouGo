//
//  RootView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import SwiftUI
import SwiftData

struct RootView: View {
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

    var body: some View {
        NavigationView {
            TabView {
                WeatherView()
                    .tabItem { Label("Weather", systemImage: "newspaper.fill") }
                ContentView()
                    .modelContainer(sharedModelContainer)
                    .tabItem { Label("Test", systemImage: "gear") }
                Text("Settings")
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }
}

#Preview {
    RootView()
}
