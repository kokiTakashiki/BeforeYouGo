//
//  BeforeYouGoApp.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import SwiftUI

@main
struct BeforeYouGoApp: App {
    // Environment
    static let displayDateFormatter = DateFormatter()
    static let timerDateFormatter = DateFormatter()
    static let forecastUseCaseDateFormatter = DateFormatter()
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
