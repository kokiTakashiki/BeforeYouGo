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
    let weatherEmoji: String
    let temperature: Float?
    let temperatureUnit: String
    
    @State private var hourText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(hourText)
                    .font(.system(size: 24))
                Text(weatherEmoji)
                    .font(.system(size: 60))
                if let precipitationProbability = precipitationProbability?.description {
                    Text(precipitationProbability)
                        .font(.system(size: 24))
                    + Text(precipitationProbabilityUnit)
                        .font(.system(size: 24))
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
            Button(action: {}, label: {})
                .padding(.bottom, 10)
        }
        .onAppear {
            hourText = time
            hourText.removeFirst(11)
        }
    }
}

#Preview {
    HourlyWeatherItemView(
        time: "2023-11-05T17:30",
        precipitationProbability: 200, 
        precipitationProbabilityUnit: "%",
        weatherEmoji: "🌞",
        temperature: 23.8,
        temperatureUnit: "°C"
    )
}
