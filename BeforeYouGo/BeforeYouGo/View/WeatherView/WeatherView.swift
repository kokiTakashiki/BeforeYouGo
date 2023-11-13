//
//  WeatherView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/05.
//

import SwiftUI

struct WeatherView: View {
    @Bindable var environment: BeforeYouGoAppEnvironment
    @Environment(\.colorScheme) var colorScheme
    
    enum RainInfoCases: String, CaseIterable, Identifiable {
        case precipitation, precipitationProbability
        var id: Self { self }
    }

    @State private var selectedRainInfoCases: RainInfoCases = .precipitationProbability
    
    var body: some View {
        if let weatherInfo = environment.weatherInfo {
            VStack(alignment: .leading) {
                HStack {
                    TimerView()
                        .padding(.horizontal,10)
                        .background(
                            VisualEffect(style: colorScheme == .dark ? .dark : .light)
                        )
                }
                .padding(.bottom, 10)
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Button(action: {}, label: {
                            Text("都市")
                                .font(.system(size: 24))
                                .bold()
                        })
                        weatherNavigation()
                    }
                    .padding(10)
                    .background(
                        VisualEffect(style: colorScheme == .dark ? .dark : .light)
                    )
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Button(action: {}, label: {
                                Text("天気")
                                    .font(.system(size: 24))
                                    .bold()
                            })
                            .padding(.trailing, 14)
                            Button(action: {
                                self.environment.reloadWeather()
                            }, label: {
                                Image(systemName: "arrow.clockwise")
                                    .frame(width: 24, height: 24)
                            })
                            .padding(.trailing, 14)
                            Picker("RainInfoCases", selection: $selectedRainInfoCases) {
                                Text("%")
                                    .tag(RainInfoCases.precipitationProbability)
                                Text("mm")
                                    .tag(RainInfoCases.precipitation)
                            }
                            .frame(width: 180, height: 30)
                        }
                        .padding(10)
                        .background(
                            VisualEffect(style: colorScheme == .dark ? .dark : .light)
                        )
                        VStack(alignment: .leading) {
                            hourlyWeatherListView(weatherInfo: weatherInfo)
                                .padding(10)
                                .background(
                                    VisualEffect(style: colorScheme == .dark ? .dark : .light)
                                )
                                .onAppear {
                                    withAnimation {
                                        self.environment.hourlyWeatherListScroll()
                                    }
                                    self.environment.isHourlyWeatherListOnApper = true
                                }
                            dailyWeatherListView(weatherInfo: weatherInfo)
                                .padding(10)
                                .background(
                                    VisualEffect(style: colorScheme == .dark ? .dark : .light)
                                )
                        }
                        currentWeatherView(weatherInfo: weatherInfo)
                            .padding(10)
                            .background(
                                VisualEffect(style: colorScheme == .dark ? .dark : .light)
                            )
                    }
                    .onChange(of: environment.selectedToshi) {
                        self.environment.reloadWeather()
                    }
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 2)
                }
            }
        } else {
            ContentUnavailableView {
                Label(
                    "No weather information",
                    systemImage: "doc.questionmark.fill"
                )
            } actions: {
                Button(action: {
                    self.environment.reloadWeather()
                }, label: {
                    Label("reload", systemImage: "arrow.clockwise")
                })
            }
            .padding(10)
            .background(
                VisualEffect(style: colorScheme == .dark ? .dark : .light)
            )
        }
    }
    
    private func weatherNavigation() -> some View {
        ScrollView {
            ForEach(environment.toshi, id: \.self) { item in
                HStack(spacing: 0) {
                    Button(action: {
                        environment.selectedToshi = item
                    }, label: {})
                    .padding(.horizontal, 20)
                    Text(item.title())
                        .font(.system(size: 30))
                        .multilineTextAlignment(.leading)
                        .frame(width: 180)
                        .padding(10)
                        .border( item == environment.selectedToshi ? .white : .clear, width: 2.0)
                }
            }
        }
    }
    
    private func currentWeatherView(weatherInfo: WeatherInfo) -> some View {
        HStack(alignment: .top) {
            VStack {
                HStack(spacing: 8) {
                    let currentHourText = {
                        var time = weatherInfo.current.time
                        time.removeFirst(11)
                        return time
                    }()
                    Text("\(currentHourText)時点")
                        .font(.system(size: 40))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    Text(weatherInfo.current.weather?.emoji(
                        isDay: weatherInfo.current.isDay
                    ) ?? "✨")
                        .font(.system(size: 100))
                    Text(NSLocalizedString(weatherInfo.current.weather?.rawValue ?? "Weather.unknown", comment: ""))
                        .font(.system(size: 60))
                        .bold()
                    Text(weatherInfo.current.temperature?.description ?? "Temperature.unknown")
                        .font(.system(size: 60))
                    + Text("°C")
                        .font(.system(size: 60))
                    Text(weatherInfo.current.precipitation?.description ?? "Precipitation.unknown")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    + Text("mm")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    @ViewBuilder
    private func hourlyWeatherListView(weatherInfo: WeatherInfo) -> some View {
        VStack(alignment: .leading) {
            Text("1時間ごとの天気")
                .font(.system(size: 26))
            if weatherInfo.hourly.isEmpty == false {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(weatherInfo.hourly, id: \.time) { item in
                            HourlyWeatherItemView(
                                time: {
                                    var time = item.time
                                    time.removeFirst(11)
                                    return time
                                }(),
                                precipitationProbability: selectedRainInfoCases == .precipitation ? nil : item.precipitationProbability,
                                precipitationProbabilityUnit: "%",
                                precipitation: selectedRainInfoCases == .precipitation ? item.precipitation : nil,
                                precipitationUnit: "mm",
                                weatherEmoji: item.weather?.emoji(
                                    isDay: item.isDay
                                ) ?? "✨",
                                temperature: item.temperature,
                                temperatureUnit: "°C"
                            )
                        }
                    }
                }
                .scrollPosition(id: $environment.hourlyWeatherListPosition)
            } else {
                ContentUnavailableView {
                    Label(
                        "No hourly weather",
                        systemImage: "doc.questionmark.fill"
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func dailyWeatherListView(weatherInfo: WeatherInfo) -> some View {
        VStack(alignment: .leading) {
            Text("日ごとの天気")
                .font(.system(size: 26))
            if weatherInfo.daily.isEmpty == false {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(weatherInfo.daily, id: \.time) { item in
                            DailyWeatherItemView(
                                time: {
                                    var time = item.time
                                    time.removeFirst(5)
                                    return time
                                }(),
                                precipitationProbabilityMax: selectedRainInfoCases == .precipitation ? nil : item.precipitationProbabilityMax,
                                precipitationProbabilityMaxUnit: "%",
                                precipitationSum: selectedRainInfoCases == .precipitation ? item.precipitationSum : nil,
                                precipitationSumUnit: "mm",
                                weatherEmoji: item.weather?.emoji() ?? "✨",
                                temperatureMin: item.temperatureMin,
                                temperatureMax: item.temperatureMax,
                                temperatureUnit: "°C"
                            )
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label(
                        "No daily weather",
                        systemImage: "doc.questionmark.fill"
                    )
                }
            }
        }
    }
}

#Preview {
    WeatherView(environment: BeforeYouGoAppEnvironment())
}

struct VisualEffect: UIViewRepresentable {
    @State var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
