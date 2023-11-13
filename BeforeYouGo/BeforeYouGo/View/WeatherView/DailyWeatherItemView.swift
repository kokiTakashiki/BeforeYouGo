//
//  DailyWeatherItemView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/05.
//

import SwiftUI

struct DailyWeatherItemView: View {
    let time: String
    let precipitationProbabilityMax: Int?
    let precipitationProbabilityMaxUnit: String
    let precipitationSum: Float?
    let precipitationSumUnit: String
    let weatherEmoji: String
    let temperatureMin: Float?
    let temperatureMax: Float?
    let temperatureUnit: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(time.replacingOccurrences(of: "-", with: "/"))
                    .font(.system(size: 24))
                VStack(spacing: 4) {
                    Text(weatherEmoji)
                        .font(.system(size: 60))
                    if let precipitationProbabilityMax = precipitationProbabilityMax?.description {
                        Text(precipitationProbabilityMax)
                            .font(.system(size: 24))
                        + Text(precipitationProbabilityMaxUnit)
                            .font(.system(size: 24))
                    }
                    if let precipitationSum = precipitationSum?.description {
                        Text(precipitationSum)
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                        + Text(precipitationSumUnit)
                            .font(.system(size: 24))
                            .foregroundStyle(.blue)
                    }
                }
                VStack(spacing: 4) {
                    if let temperature = temperatureMax?.description {
                        Text(temperature)
                            .font(.system(size: 30))
                        + Text(temperatureUnit)
                            .font(.system(size: 30))
                    } else {
                        Text(NSLocalizedString("Temperature.unknown", comment: ""))
                            .font(.system(size: 30))
                    }
                    if let temperature = temperatureMin?.description {
                        Text(temperature)
                            .font(.system(size: 24))
                        + Text(temperatureUnit)
                            .font(.system(size: 24))
                    } else {
                        Text(NSLocalizedString("Temperature.unknown", comment: ""))
                            .font(.system(size: 24))
                    }
                }
            }
            Button(action: {}, label: {})
                .padding(.top, 2)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    DailyWeatherItemView(
        time: "2023-11-05",
        precipitationProbabilityMax: 200,
        precipitationProbabilityMaxUnit: "%",
        precipitationSum: 9999.99,
        precipitationSumUnit: "mm",
        weatherEmoji: "🌝",
        temperatureMin: 18.4,
        temperatureMax: 23.8,
        temperatureUnit: "°C"
    )
}
