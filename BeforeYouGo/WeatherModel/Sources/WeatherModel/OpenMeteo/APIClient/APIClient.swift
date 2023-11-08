//
//  APIClient.swift
//
//
//  Created by takedatakashiki on 2023/11/04.
//

import Alamofire
import Foundation

extension OpenMeteo {
    enum APIClient {}
}

extension OpenMeteo.APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(
        route: OpenMeteo.APIRouter,
        decoder: JSONDecoder = JSONDecoder(),
        completion:@escaping (Result<T, AFError>)->Void
    ) -> DataRequest {
        return AF.request(route)
                .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                    completion(response.result)
        }
    }
    
    private static func performRequest<T:Decodable>(route: OpenMeteo.APIRouter) async throws -> T {
        return try await AF.request(route).response()
    }
    
    private static func validateCode(data: Data, response: URLResponse) throws -> Data {
        switch (response as? HTTPURLResponse)?.statusCode {
        case .some(let code) where code == 401:
            throw NSError(domain: "Unauthorized", code: code)
            
        case .some(let code) where code == 404:
            throw NSError(domain: "Not Found", code: code)
            
        case .none:
            throw NSError(domain: "Irregular Error", code: 0)
            
        case .some:
            return data
        }
    }
    
    static func forecast(toshi: WeatherModel.Toshi) async throws -> WeatherForecastResponse {
        let pos = toshi.position()
        return try await performRequest(
            route: OpenMeteo.APIRouter.forecast(
                timezone: "Asia/Tokyo",
                latitude: pos.latitude,
                longitude: pos.longitude,
                forecastDays: 11,
                current: "precipitation,temperature_2m,relativehumidity_2m,is_day,weathercode",
                hourly: "is_day,precipitation,precipitation_probability,temperature_2m,weathercode",
                daily: "precipitation_sum,precipitation_probability_max,weathercode,temperature_2m_min,temperature_2m_max"
            )
        )
    }
}

extension DataRequest {
    func response<T>() async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            self.response { response in
                switch response.result {
                case .success(let element):
                    do {
                        continuation.resume(returning: try JSONDecoder().decode(T.self, from: element!))
                    } catch {
                        print(error)
                        continuation.resume(throwing: WeatherModel.APIServiceError.decodingError)
                    }
                case .failure(let error):
                    switch error.responseCode {
                    case .some(let code) where code == 401:
                        continuation.resume(throwing:  WeatherModel.APIServiceError.networkError)
                        
                    case .some(let code) where code == 404:
                        continuation.resume(throwing: WeatherModel.APIServiceError.networkError)
                        
                    case .none:
                        continuation.resume(throwing: WeatherModel.APIServiceError.networkError)
                    case .some:
                        break
                    }
                    continuation.resume(throwing: WeatherModel.APIServiceError.networkError)
                }
            }
        }
    }
}
