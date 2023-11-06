//
//  RootView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import SwiftUI
import SwiftData
import Kingfisher

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
        .background(
            KFImage(URL(string: "https://images.unsplash.com/photo-1497215728101-856f4ea42174?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MjUwMTV8MHwxfHNlYXJjaHwxfHxvZmZpY2V8ZW58MHx8fHwxNjk5Mjc1NjYyfDA&ixlib=rb-4.0.3&q=85"))
                .resizable()
        )
    }
}

#Preview {
    RootView()
}
