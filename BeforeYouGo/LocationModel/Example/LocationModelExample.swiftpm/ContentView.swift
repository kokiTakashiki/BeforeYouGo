import SwiftUI
import LocationModel
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    
    @State private var currentPlacemark: CLPlacemark?
    
    var body: some View {
        VStack {
            currentLocationButton()
                .padding(.top)
                .padding(.horizontal)
            LocationSearchView()
        }
    }
    
    private func currentLocationButton() -> some View {
        HStack {
            if let currentPlacemark {
                Text(currentPlacemark.country ?? "")
                + Text(currentPlacemark.administrativeArea ?? "")
                + Text(currentPlacemark.subAdministrativeArea ?? "")
                + Text(currentPlacemark.locality ?? "")
                + Text(currentPlacemark.subLocality ?? "")
            } else {
                Text("Location")
            }
            
            Spacer()
            
            LocationButton(.currentLocation) {
                switch LocationModel.currentLocation() {
                case let .success(value):
                    Task {
                        let placemark = await LocationModel.locationAddress(coordinate: value)
                        Task { @MainActor in
                            currentPlacemark = placemark
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
            .symbolVariant(.fill)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .font(.system(size: 12))
            .foregroundStyle(Color.white)
        }
        .modifier(TextFieldGrayBackgroundColor())
    }
}

#Preview {
    ContentView()
}
