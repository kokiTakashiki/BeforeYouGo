//
//  LocationSearchView.swift
//  LocationModelExample
//
//  Created by takedatakashiki on 2023/12/22.
//

import SwiftUI
import LocationModel
import MapKit

struct LocationSearchView: View {
    @State private var locationService = LocationModel.LocationSearch()
    @State private var search: String = ""
    
    @State private var showSheet: Bool = false
    @State private var sheetTitle: String?
    @State private var sheetSubTitle: String?
    @State private var sheetLocation: CLLocationCoordinate2D = .init()
    @State private var sheetPosition: MapCameraPosition = .automatic
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a restaurant", text: $search)
                    .autocorrectionDisabled()
                if locationService.locationCompleterState.status == .isSearching {
                    Image(systemName: "clock")
                        .foregroundColor(Color.gray)
                }
            }
            .modifier(TextFieldGrayBackgroundColor())

            Spacer()

            ZStack {
                switch locationService.locationCompleterState.status {
                case .noResults:
                    ContentUnavailableView.search
                case let .error(value):
                    ContentUnavailableView.search(text: value)
                default:
                    if search.isEmpty {
                        EmptyView()
                    } else {
                        locationList()
                    }
                }
            }
        }
        // 5
        .onChange(of: search) {
            locationService.update(queryFragment: search)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func locationList() -> some View {
        List {
            ForEach(locationService.locationCompleterState.completions) { completion in
                Button(action: {
                    sheetTitle = completion.title
                    sheetSubTitle = completion.subTitle
                    Task {
                        guard let coordinate = await LocationModel.locationCoordinate(address: completion) else {
                            return
                        }
                        Task { @MainActor in
                            sheetLocation = coordinate
                            sheetPosition = .camera(
                                MapCamera(
                                    centerCoordinate: coordinate,
                                    distance: 80000,
                                    heading: 90,
                                    pitch: 50
                                )
                            )
                        }
                    }
                    showSheet.toggle()
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(completion.title)
                            .font(.headline)
                            .fontDesign(.rounded)
                        Text(completion.subTitle)
                    }
                }
                .sheet(isPresented: $showSheet) {
                    ディティールView(
                        title: sheetTitle ?? "",
                        subTitle: sheetSubTitle ?? ""
                    )
                }
                // 3
                .listRowBackground(Color.clear)
            }
        }
        // 4
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private func ディティールView(
        title: String,
        subTitle: String
    ) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .fontDesign(.rounded)
            Text(subTitle)
            Map(position: $sheetPosition) {
                Marker(title, coordinate: sheetLocation)
            }
            .mapStyle(.standard(elevation: .realistic))
            .frame(width: 300, height: 300)
            .cornerRadius(5)
            .shadow(radius: 4)
        }
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

#Preview {
    LocationSearchView()
}
