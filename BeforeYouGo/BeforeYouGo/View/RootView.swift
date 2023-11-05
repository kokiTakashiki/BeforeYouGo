//
//  RootView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import SwiftUI
import SwiftData

struct RootView: View {
    private let forecast: ForecastUseCaseProtocol = ForecastUseCase()
    @State private var weather: Weather?
    
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
                weatherView()
                    .tabItem { Label("Weather", systemImage: "newspaper.fill") }
                ContentView()
                    .modelContainer(sharedModelContainer)
                    .tabItem { Label("Test", systemImage: "gear") }
                Text("Settings")
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
        }
    }
    
    private func weatherView() -> some View {
        VStack {
            HStack(spacing: 8) {
                Text(weather?.emoji() ?? "✨")
                    .font(.system(size: 100))
                Text(NSLocalizedString(weather?.rawValue ?? "Weather.unknown", comment: ""))
                    .font(.system(size: 60))
                    .bold()
            }
            Button("Test Call", action: {
                Task {
                    let result = await forecast.execute()
                    print("result \(String(describing: result))")
                    guard let data = try? result.get() else { return }
                    weather = Weather.codeTo(data.weathercode)
                }
            })
        }
    }
}

#Preview {
    RootView()
}
