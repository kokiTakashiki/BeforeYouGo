//
//  WeatherForecastResponse.swift
//
//
//  Created by takedatakashiki on 2023/11/04.
//

import Foundation

public struct WeatherForecastResponse: Decodable {
    public let latitude: Double
    public let longitude: Double
    public let generationtime_ms: Double
    public let utc_offset_seconds: Int
    public let timezone: String
    public let timezone_abbreviation: String
    public let elevation: Double
    public let current_units: Self.CurrentUnits
    public let current: Self.Current
    public let hourly_units: Self.HourlyUnits
    public let hourly: Self.Hourly
    public let daily_units: Self.DailyUnits
    public let daily: Self.Daily
}

public extension WeatherForecastResponse {
    struct CurrentUnits: Decodable {
        public let time: String
        public let interval: String
        public let temperature_2m: String
        public let relativehumidity_2m: String
        public let is_day: String
        public let weathercode: String
    }
    
    struct Current: Decodable {
        public let time: String
        public let interval: Int
        public let temperature_2m: Float
        public let relativehumidity_2m: Int
        public let is_day: Int // day: 1, not day(night): 0
        public let weathercode: Int
    }
    
    struct HourlyUnits: Decodable {
        public let time: String
        public let temperature_2m: String
        public let weathercode: String
    }
    
    struct Hourly: Decodable {
        public let time: [String]
        public let temperature_2m: [Float]
        public let weathercode: [Int]
    }
    
    struct DailyUnits: Decodable {
        public let time: String
        public let weathercode: String
        public let temperature_2m_min: String
        public let temperature_2m_max: String
    }
    
    struct Daily: Decodable {
        public let time: [String]
        public let weathercode: [Int]
        public let temperature_2m_min: [Float]
        public let temperature_2m_max: [Float]
    }
}
