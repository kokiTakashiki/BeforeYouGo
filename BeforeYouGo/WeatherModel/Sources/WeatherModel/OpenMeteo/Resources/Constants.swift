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

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

extension WeatherModel {
    public enum APIServiceError: Error{
        case networkError, decodingError
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
