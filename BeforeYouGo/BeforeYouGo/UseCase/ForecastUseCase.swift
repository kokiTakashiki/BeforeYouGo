//
//  ForecastUseCase.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/04.
//

import Foundation
import WeatherModel

enum UseCaseError: Error {
    case networkError, decodingError, unknownError
}

protocol ForecastUseCaseProtocol {
    func execute() async -> Result<CurrentWeatherInfo, UseCaseError>
}

struct ForecastUseCase: ForecastUseCaseProtocol {
    func execute() async -> Result<CurrentWeatherInfo, UseCaseError>{
        do{
            let result = try await WeatherModel.forecast()
            return .success(
                CurrentWeatherInfo(
                    time: result.current.time,
                    temperature: result.current.temperature_2m,
                    relativehumidity: result.current.relativehumidity_2m,
                    isDay: result.current.is_day == 1,
                    weathercode: result.current.weathercode
                )
            )
        } catch (let error) {
            switch(error){
            case APIServiceError.decodingError:
                return .failure(.decodingError)
            case APIServiceError.networkError:
                return .failure(.networkError)
            default:
                return .failure(UseCaseError.unknownError)
            }
        }
    }
}
