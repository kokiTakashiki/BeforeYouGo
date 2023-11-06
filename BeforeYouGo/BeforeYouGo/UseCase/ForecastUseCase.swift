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

extension ForecastUseCase {
    enum Toshi {
        case tama
        case hakone
        func exchange() -> WeatherModel.Toshi {
            switch self {
            case .tama: return .tama
            case .hakone: return .hakone
            }
        }
        func title() -> String {
            switch self {
            case .tama: return "多摩市"
            case .hakone: return "箱根"
            }
        }
    }
}

protocol ForecastUseCaseProtocol {
    func execute(toshi: ForecastUseCase.Toshi) async -> Result<WeatherInfo, UseCaseError>
}

struct ForecastUseCase: ForecastUseCaseProtocol {
    func execute(toshi: ForecastUseCase.Toshi) async -> Result<WeatherInfo, UseCaseError>{
        do{
            WeatherModel.startLogger()
            let result = try await WeatherModel.forecast(toshi: toshi.exchange())
            return .success(
                WeatherInfo(
                    current: WeatherInfo.Current(
                        time: result.current.time,
                        temperature: result.current.temperature_2m,
                        relativehumidity: result.current.relativehumidity_2m,
                        isDay: result.current.is_day == 1,
                        weather: Weather.codeTo(result.current.weathercode)
                    ),
                    hourly: result.hourly.time.enumerated().map {
                        WeatherInfo.Hourly(
                            time: $0.element, 
                            precipitationProbability: result.hourly.precipitation_probability
                                .indices.contains($0.offset) ? result.hourly.precipitation_probability[$0.offset] : nil,
                            temperature: result.hourly.temperature_2m
                                .indices.contains($0.offset) ? result.hourly.temperature_2m[$0.offset] : nil,
                            weather: result.hourly.weathercode
                                .indices.contains($0.offset) ? Weather.codeTo(result.hourly.weathercode[$0.offset]) : nil
                        )
                    },
                    daily: result.daily.time.enumerated().map {
                        WeatherInfo.Daily(
                            time: $0.element, 
                            precipitationProbabilityMax: result.daily.precipitation_probability_max[$0.offset],
                            weather: Weather.codeTo(result.daily.weathercode[$0.offset]),
                            temperatureMin: result.daily.temperature_2m_min[$0.offset],
                            temperatureMax: result.daily.temperature_2m_max[$0.offset]
                        )
                    }
                )
            )
        } catch (let error) {
            switch(error){
            case WeatherModel.APIServiceError.decodingError:
                return .failure(.decodingError)
            case WeatherModel.APIServiceError.networkError:
                return .failure(.networkError)
            default:
                return .failure(UseCaseError.unknownError)
            }
        }
    }
}
