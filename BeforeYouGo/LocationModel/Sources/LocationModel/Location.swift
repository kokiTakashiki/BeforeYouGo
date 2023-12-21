//
//  Location.swift
//  
//
//  Created by takedatakashiki on 2023/12/03.
//

import Foundation
import MapKit

public enum Location {
    static let manager = CLLocationManager()
    
    enum AuthorizationStatus {
        case authorized
    }
    
    enum AuthorizationError: Error {
        case notDetermined, restricted, denied, unknown
    }
}

extension Location {
    static func locationManagerDidChangeAuthorization() -> Result<AuthorizationStatus, AuthorizationError> {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined: // ユーザーはこのアプリケーションに関してまだ選択をしていない
            return .failure(.notDetermined)
        case .restricted: // このアプリケーションは、位置情報サービスを使用する権限がありません。 位置情報サービスのアクティブな制限のため、ユーザーはこのステータスを変更できない。このステータスを変更することはできず、個人的に認可を拒否していない可能性があります。
            return .failure(.restricted)
        case .denied: // ユーザーが明示的にこのアプリケーションの認可を拒否している。設定で位置情報サービスが無効になっている。
            return .failure(.denied)
        case .authorizedAlways: // ユーザーは、いつでも位置情報を使用することを許可しています。 アプリは、訪問監視、地域監視、および重要な位置情報の変更監視などのAPIを監視することにより、バックグラウンドで起動される可能性があります。
            return .success(.authorized)
        case .authorizedWhenInUse: // ユーザーは、あなたのアプリを使用している間のみ、位置情報を使用することを許可しています。 注意: ユーザーのアプリへの継続的な関与を反映するには、次のようにします。-allowsBackgroundLocationUpdates。
            return .success(.authorized)
        @unknown default:
            return .failure(.unknown)
        }
    }
}

// MapKit

extension Location {
    final class LocationService: NSObject, MKLocalSearchCompleterDelegate {
        private let completer: MKLocalSearchCompleter
        let locationCompleterState = LocationModel.LocationCompleterState()
        
        init(completer: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
            self.completer = completer
            super.init()
            self.completer.delegate = self
            self.completer.region = MKCoordinateRegion(.world)
            self.completer.resultTypes = .address
        }
        
        func update(queryFragment: String) {
            locationCompleterState.status = .isSearching
            guard !queryFragment.isEmpty else {
                locationCompleterState.status = .idle
                return
            }
            completer.queryFragment = queryFragment
        }
        
        // MARK: MKLocalSearchCompleterDelegate
        
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            let searchResults = placeList(results: completer.results)
            locationCompleterState.completions = searchResults
            locationCompleterState.status = searchResults.isEmpty ? .noResults : .result
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            locationCompleterState.status = .error(error.localizedDescription)
        }
        
        // MARK: Private
        
        private func placeList(
            results: [MKLocalSearchCompletion]
        ) -> [LocationModel.SearchAddress] {
            
            var searchResults: [LocationModel.SearchAddress] = []
            
            for result in results {
                searchResults.append(
                    LocationModel.SearchAddress(
                        title: result.title,
                        subTitle: result.subtitle
                    )
                )
            }
            
            return searchResults
        }
    }
    
    static func locationSearch(address: LocationModel.SearchAddress) async throws -> MKLocalSearch.Response {
        let searchRequest = MKLocalSearch.Request()
        let entireAddress = address.title + " " + address.subTitle
        searchRequest.naturalLanguageQuery = entireAddress
        let search = MKLocalSearch(request: searchRequest)
        
        return try await search.start()
    }
}
