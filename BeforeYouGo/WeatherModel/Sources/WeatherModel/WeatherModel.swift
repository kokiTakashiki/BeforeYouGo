// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import AlamofireNetworkActivityLogger

public enum WeatherModel {
    public static func forecast(toshi: Toshi) async throws -> WeatherForecastResponse {
        return try await OpenMeteo.APIClient.forecast(toshi: toshi)
    }
#if DEBUG
    public static func startLogger() {
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    }
#endif
}
