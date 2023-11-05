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
    let weatherEmoji: String
    let temperatureMin: Float?
    let temperatureMax: Float?
    let temperatureUnit: String
    
    @State private var dayText: String = ""
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Text(dayText.replacingOccurrences(of: "-", with: "/"))
                .font(.system(size: 24))
            Text(weatherEmoji)
                .font(.system(size: 30))
            if let precipitationProbabilityMax = precipitationProbabilityMax?.description {
                Text(precipitationProbabilityMax)
                    .font(.system(size: 24))
                + Text(precipitationProbabilityMaxUnit)
                    .font(.system(size: 24))
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
            if let temperature = temperatureMax?.description {
                Text(temperature) 
                    .font(.system(size: 24))
                    .bold()
                + Text(temperatureUnit)
                    .font(.system(size: 24))
                    .bold()
            } else {
                Text(NSLocalizedString("Temperature.unknown", comment: ""))
                    .font(.system(size: 24))
            }
        }
        .frame(height: 50)
        .onAppear {
            dayText = time
            dayText.removeFirst(5)
        }
    }
}

#Preview {
    DailyWeatherItemView(
        time: "2023-11-05",
        precipitationProbabilityMax: 200,
        precipitationProbabilityMaxUnit: "%",
        weatherEmoji: "🌝",
        temperatureMin: 18.4,
        temperatureMax: 23.8,
        temperatureUnit: "°C"
    )
}

struct DailyWeatherItemView2: View {
    let time: String
    let precipitationProbabilityMax: Int?
    let precipitationProbabilityMaxUnit: String
    let weatherEmoji: String
    let temperatureMin: Float?
    let temperatureMax: Float?
    let temperatureUnit: String
    
    @State private var dayText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Text(dayText.replacingOccurrences(of: "-", with: "/"))
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
        .onAppear {
            dayText = time
            dayText.removeFirst(5)
        }
    }
}

#Preview {
    DailyWeatherItemView2(
        time: "2023-11-05",
        precipitationProbabilityMax: 200,
        precipitationProbabilityMaxUnit: "%",
        weatherEmoji: "🌝",
        temperatureMin: 18.4,
        temperatureMax: 23.8,
        temperatureUnit: "°C"
    )
}
