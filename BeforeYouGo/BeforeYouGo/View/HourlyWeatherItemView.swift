//
//  HourlyWeatherItemView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/05.
//

import SwiftUI

struct HourlyWeatherItemView: View {
    let time: String
    let precipitationProbability: Int?
    let precipitationProbabilityUnit: String
    let precipitation: Float?
    let precipitationUnit: String
    let weatherEmoji: String
    let temperature: Float?
    let temperatureUnit: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(time)
                    .font(.system(size: 24))
                    .padding(.bottom, 8)
                Text(weatherEmoji)
                    .font(.system(size: 60))
                if let precipitationProbability = precipitationProbability?.description {
                    Text(precipitationProbability)
                        .font(.system(size: 24))
                    + Text(precipitationProbabilityUnit)
                        .font(.system(size: 24))
                }
                if let precipitation = precipitation?.description {
                    Text(precipitation)
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                    + Text(precipitationUnit)
                        .font(.system(size: 24))
                        .foregroundStyle(.blue)
                }
                if let temperature = temperature?.description {
                    Text(temperature) 
                        .font(.system(size: 30))
                    + Text(temperatureUnit)
                        .font(.system(size: 30))
                } else {
                    Text(NSLocalizedString("Temperature.unknown", comment: ""))
                        .font(.system(size: 30))
                }
            }
            .padding(.bottom, 8)
            Button(action: {}, label: {})
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    HourlyWeatherItemView(
        time: "2023-11-05T17:30",
        precipitationProbability: nil,//200, 
        precipitationProbabilityUnit: "%",
        precipitation: 9999.99,
        precipitationUnit: "mm",
        weatherEmoji: "🌞",
        temperature: 23.8,
        temperatureUnit: "°C"
    )
}
