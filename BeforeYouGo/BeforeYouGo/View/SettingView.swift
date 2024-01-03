//
//  SettingView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/12/23.
//

import SwiftUI
import UnsplashPhotoPickerView_tvOS

struct SettingView: View {
    @State var environment: BeforeYouGoAppEnvironment
    @Binding var settings: AppSettings
    
    @State private var showUnsplashViewForDay = false
    @State private var showUnsplashViewForNight = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            appIcon()
            ScrollView {
                VStack(alignment: .leading) {
                    backgroundImageSetting()
                    
                    Divider()
                    
                    Text("Display")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Toggle(isOn: self.$settings.todayWeatherDisplay) {
                        Text("Show Today Weather")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Divider()
                    
                    Text("Settings Reset")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button(action: {
                        environment.documentsImages.backgroundImageDay = nil
                        environment.documentsImages.backgroundImageNight = nil
                        guard let appDomain = Bundle.main.bundleIdentifier else {
                            return
                        }
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                        settings = AppSettings.default()
                    }, label: {
                        Text("Reset to default settings")
                        Spacer()
                    })
                    .buttonStyle(.automatic)
                    .tint(.red)
                    
                    Spacer()
                }
                .padding(.all, 20)
            }
            .clipped()
        }
        .background(content: {
            VisualEffect(style: colorScheme == .dark ? .dark : .light, cornerRadius: 20)
        })
    }
    
    private func appIcon() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: UIScreen.main.bounds.width / 3)
            .overlay {
                Image(.icon)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.height / 3)
            }
    }
    
    @ViewBuilder
    private func backgroundImageSetting() -> some View {
        Text("Background Image")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        Text("Day")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        Button(action: {
            showUnsplashViewForDay.toggle()
        }, label: {
            Text(settings.backgroundImageDayUsername ?? "Unknown")
            Spacer()
            if let image = environment.documentsImages.backgroundImageDay {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width/6.0,
                        height: UIScreen.main.bounds.height/6.0
                    )
                    .clipped()
            } else {
                notFoundBackGround()
                    .frame(
                        width: UIScreen.main.bounds.width/6.0,
                        height: UIScreen.main.bounds.height/6.0
                    )
            }
        })
        .sheet(isPresented: $showUnsplashViewForDay) {
            UnsplashView(
                query: "Morning",
                image: Binding(
                    get: { nil },
                    set: { image in
                        environment.documentsImages.backgroundImageDay = image
                    }
                ),
                userName: $settings.backgroundImageDayUsername
            )
        }
        
        Text("Night")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        Button(action: {
            showUnsplashViewForNight.toggle()
        }, label: {
            Text(settings.backgroundImageNightUsername ?? "Unknown")
            Spacer()
            if let image = environment.documentsImages.backgroundImageNight {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width/6.0,
                        height: UIScreen.main.bounds.height/6.0
                    )
                    .clipped()
            } else {
                notFoundBackGround()
                    .frame(
                        width: UIScreen.main.bounds.width/6.0,
                        height: UIScreen.main.bounds.height/6.0
                    )
            }
        })
        .sheet(isPresented: $showUnsplashViewForNight) {
            UnsplashView(
                query: "Night",
                image: Binding(
                    get: { nil },
                    set: { image in
                        environment.documentsImages.backgroundImageNight = image
                    }
                ),
                userName: $settings.backgroundImageNightUsername
            )
        }
    }
    
    private func notFoundBackGround() -> some View {
        Color.accent
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(.icon)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.height / 18)
                    }
                }
                .padding(.all, 20.0)
            }
    }
}

#Preview {
    SettingView(
        environment: .init(),
        settings: .constant(AppSettings.default())
    )
}
