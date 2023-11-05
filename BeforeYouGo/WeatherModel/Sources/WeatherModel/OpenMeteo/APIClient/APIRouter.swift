//
//  APIRouter.swift
//
//
//  Created by takedatakashiki on 2023/11/04.
//

import Foundation
import Alamofire

extension OpenMeteo {
    enum APIRouter {
        typealias ParameterKey = OpenMeteo.APIParameterKey
        
        case forecast(
            timezone: String,
            latitude: Float,
            longitude: Float,
            forecastDays: Int,
            current: String,
            hourly: String,
            daily: String
        )
    }
}

extension OpenMeteo.APIRouter: URLRequestConvertible {
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .forecast:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .forecast:
            return "/forecast"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case let .forecast(timezone, latitude, longitude, forecastDays, current, hourly, daily):
            return [
                ParameterKey.timezone.rawValue: timezone,
                ParameterKey.latitude.rawValue: latitude,
                ParameterKey.longitude.rawValue: longitude,
                ParameterKey.forecastDays.rawValue: forecastDays,
                ParameterKey.current.rawValue: current,
                ParameterKey.hourly.rawValue: hourly,
                ParameterKey.daily.rawValue: daily
            ]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try OpenMeteo.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        //urlRequest.encoding = URLEncoding.default
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
//        if let parameters = parameters {
//            do {
//                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//            } catch {
//                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
//            }
//        }
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
