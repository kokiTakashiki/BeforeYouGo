//
//  Constants.swift
//
//
//  Created by takedatakashiki on 2023/11/04.
//

import Foundation

enum OpenMeteo {
    enum ProductionServer {
        static let baseURL = "https://api.open-meteo.com/v1"
    }
    enum APIParameterKey: String {
        case timezone
        case latitude
        case longitude
        case forecastDays = "forecast_days"
        case current
        case hourly
        case daily
    }
}

extension WeatherModel {
    public enum APIServiceError: Error {
        case networkError, decodingError, unauthorized, notFound, irregularError
    }
    
    public enum Toshi {
        case tama
        case hakone
        
        func position() -> (latitude: Float, longitude: Float) {
            switch self {
            case .tama:
                return (35.6374, 139.4356)
            case .hakone:
                return (35.1895, 139.0265)
            }
        }
    }
}
