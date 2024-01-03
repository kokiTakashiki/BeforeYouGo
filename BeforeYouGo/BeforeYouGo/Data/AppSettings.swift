//
//  AppSettings.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/12/29.
//

import Foundation

struct AppSettings {
    var todayWeatherDisplay: Bool
    var backgroundImageDayUsername: String?
    var backgroundImageNightUsername: String?
}

// MARK: `default`

extension AppSettings {
    static func `default`() -> AppSettings {
        .init(
            todayWeatherDisplay: false,
            backgroundImageDayUsername: "Default",
            backgroundImageNightUsername: "Default"
        )
    }
}

// MARK: Codable

extension AppSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case todayWeatherDisplay
        case backgroundImageDayUsername
        case backgroundImageNightUsername
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(todayWeatherDisplay, forKey: .todayWeatherDisplay)
        if let backgroundImageDayUsername {
            try container.encode(backgroundImageDayUsername, forKey: .backgroundImageDayUsername)
        }
        if let backgroundImageNightUsername {
            try container.encode(backgroundImageNightUsername, forKey: .backgroundImageNightUsername)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todayWeatherDisplay = try container.decode(Bool.self, forKey: .todayWeatherDisplay)
        backgroundImageDayUsername = try container.decode(String.self, forKey: .backgroundImageDayUsername)
        backgroundImageNightUsername = try container.decode(String.self, forKey: .backgroundImageNightUsername)
    }
}

// MARK: RawRepresentable

extension AppSettings: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            return nil
        }
        self = decoded
    }

    var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let jsonString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
}
