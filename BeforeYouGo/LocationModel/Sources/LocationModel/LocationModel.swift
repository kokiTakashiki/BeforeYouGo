// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import MapKit

public enum LocationModel {
    public enum CurrentLocationError: Error {
        case failed
    }
    
    public static func currentLocation() -> Result<CLLocationCoordinate2D, Error> {
        switch Location.locationManagerDidChangeAuthorization() {
        case .success:
            guard let location = Location.manager.location else {
                return .failure(CurrentLocationError.failed)
            }
            return .success(location.coordinate)
        case let .failure(error):
            return .failure(error)
        }
    }
}

extension LocationModel {
    public struct SearchAddress: Identifiable {
        public let id = UUID()
        public let title: String
        public let subTitle: String
    }
    
    public enum LocationCompleterStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Observable
    public final class LocationCompleterState {
        public var status: LocationCompleterStatus = .idle
        public var completions: [SearchAddress] = []
    }
    
    public struct LocationSearch {
        private let service: Location.LocationService
        
        public var locationCompleterState: LocationCompleterState
        
        public init() {
            self.service = Location.LocationService()
            self.locationCompleterState = self.service.locationCompleterState
        }
        
        public func update(queryFragment: String) {
            service.update(queryFragment: queryFragment)
        }
    }
    
    public static func locationCoordinate(
        address: LocationModel.SearchAddress
    ) async -> CLLocationCoordinate2D? {
        let response = try? await Location.locationSearch(address: address)
        return response?.mapItems.first?.placemark.coordinate
    }
    
    public static func locationAddress(
        coordinate: CLLocationCoordinate2D
    ) async -> CLPlacemark? {
        let response = try? await CLGeocoder().reverseGeocodeLocation(
            CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        )
        return response?.first
    }
}
