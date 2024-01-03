//
//  WeatherInfo.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/05.
//

import Foundation

struct WeatherInfo {
    let current: Self.Current
    let hourly: [Self.Hourly]
    let daily: [Self.Daily]
}

extension WeatherInfo {
    struct Current {
        let time: String
        let date: Date?
        let temperature: Float?
        let relativehumidity: Int?
        let precipitation: Float?
        let isDay: Bool // day: 1, not day(night): 0
        let weather: Weather?
    }

    struct Hourly {
        let time: String
        let date: Date?
        let isDay: Bool // day: 1, not day(night): 0
        let precipitation: Float?
        let precipitationProbability: Int?
        let temperature: Float?
        let weather: Weather?
    }
    
    struct Daily {
        let time: String
        let date: Date?
        let precipitationSum: Float?
        let precipitationProbabilityMax: Int?
        let weather: Weather?
        let temperatureMin: Float?
        let temperatureMax: Float?
    }
}
