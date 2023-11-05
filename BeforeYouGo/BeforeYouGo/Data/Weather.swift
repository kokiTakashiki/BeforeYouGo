//
//  Weather.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/04.
//

import Foundation

enum Weather: String, CaseIterable {
    case clearSky = "Weather.0.ClearSky" // ☀️0
    case mainlyClear = "Weather.1.MainlyClear" // 🌤1
    case partlyCloudy = "Weather.2.PartlyCloudy" // ⛅2
    case overcast = "Weather.3.Overcast" // ☁️3

    case fog = "Weather.45.Fog" // 🌫️45, 48
    case drizzle = "Weather.51.Drizzle" // 🌦️51, 53, 55
    case freezingDrizzle = "Weather.56.FreezingDrizzle" // 🌨️56, 57
    case rain = "Weather.61.Rain" // ☔️61, 63, 65

    case freezingRain = "Weather.66.FreezingRain" // 🌨️66, 67
    case snowfall = "Weather.71.Snowfall" // ⛄️71, 73, 75
    case snowGrains = "Weather.77.SnowGrains" // ❄️77
    case rainShowers = "Weather.80.RainShowers" // 🌧80, 81, 82
    case snowShowers = "Weather.85.SnowShowers" // ☃️85, 86
    case thunderstorm = "Weather.95.Thunderstorm" // ⛈️95, 96, 99

    case unknown = "Weather.unknown" // 不明
}

extension Weather {
    static func codeTo(_ weathercode: Int?) -> Self {
        switch weathercode {
        case 0: return .clearSky
        case 1: return .mainlyClear
        case 2: return .partlyCloudy
        case 3: return .overcast

        case 45, 48: return .fog
        case 51, 53, 55: return .drizzle
        case 56, 57: return .freezingDrizzle
        case 61, 63, 65: return .rain

        case 66, 67: return .freezingRain
        case 71, 73, 75: return .snowfall
        case 77: return .snowGrains
        case 80, 81, 82: return .rainShowers
        case 85, 86: return .snowShowers
        case 95, 96, 99: return .thunderstorm
        default:
            return .unknown
        }
    }
    
    func emoji() -> String {
        switch self {
        case .clearSky: return "☀️"
        case .mainlyClear: return "🌤"
        case .partlyCloudy: return "⛅"
        case .overcast: return "☁️"
        
        case .fog: return "🌫️"
        case .drizzle: return "🌦️"
        case .freezingDrizzle: return "🌨️"
        case .rain: return "☔️"
        
        case .freezingRain: return "🌨️"
        case .snowfall: return "⛄️"
        case .snowGrains: return "❄️"
        case .rainShowers: return "🌧"
        case .snowShowers: return "☃️"
        case .thunderstorm: return "⛈️"
        
        case .unknown: return "✨"
        }
    }
}

//コード 説明
//0 快晴☀️Clear sky
//1 概ね晴れ🌤Mainly clear
//2 曇または晴れ⛅Partly cloudy
//3 曇り☁️Overcast

//45, 48 霧🌫️Fog
//51, 53, 55 霧雨🌦️Drizzle
//56, 57 霧氷🌨️Freezing Drizzle
//61, 63, 65 雨☔️Rain

//66, 67 氷雨🌨️Freezing Rain
//71, 73, 75 雪⛄️Snow fall
//77 あられ❄️Snow grains
//80, 81, 82 にわか雨🌧Rain showers
//85, 86 にわか雪☃️Snow showers slight and heavy
//95, 96, 99 * 雷雨⛈️Thunderstorm

//(*) 雹を伴う雷雨予報は中央ヨーロッパのみである。
