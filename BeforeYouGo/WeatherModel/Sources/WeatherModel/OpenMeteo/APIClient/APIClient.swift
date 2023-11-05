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
    
    static func forecast() async throws -> WeatherForecastResponse {
        return try await performRequest(
            route: OpenMeteo.APIRouter.forecast(
                timezone: "Asia/Tokyo",
                latitude: 35.6374,
                longitude: 139.4356,
                forecastDays: 16,
                current: "temperature_2m,relativehumidity_2m,is_day,weathercode",
                hourly: "temperature_2m,weathercode",
                daily: "weathercode,temperature_2m_min,temperature_2m_max"
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
                        continuation.resume(throwing: APIServiceError.decodingError)
                    }
                case .failure(let error):
                    switch error.responseCode {
                    case .some(let code) where code == 401:
                        continuation.resume(throwing:  APIServiceError.networkError)
                        
                    case .some(let code) where code == 404:
                        continuation.resume(throwing: APIServiceError.networkError)
                        
                    case .none:
                        continuation.resume(throwing: APIServiceError.networkError)
                    case .some:
                        break
                    }
                    continuation.resume(throwing: APIServiceError.networkError)
                }
            }
        }
    }
}
