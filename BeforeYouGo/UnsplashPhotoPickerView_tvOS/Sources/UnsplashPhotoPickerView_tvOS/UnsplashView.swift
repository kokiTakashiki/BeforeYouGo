//
//  UnsplashView.swift
//
//
//  Created by takedatakashiki on 2023/12/28.
//

import SwiftUI
import UnsplashPhotoPicker
import UnsplashPhotoPickerUI_tvOS

public struct UnsplashView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIViewController
    
    private let query: String
    @Binding var image: UIImage?
    @Binding var userName: String?
    
    public init(query: String, image: Binding<UIImage?>, userName: Binding<String?>) {
        self.query = query
        self._image = image
        self._userName = userName
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, userName: $userName)
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        let configuration = UnsplashPhotoPickerConfiguration(
            photoViewNib: UnsplashPhotoPickerUI_tvOS.photoViewNib,
            accessKey: "f5GFYyvptRKSf6-LaLiCiOC0H4kRiR1i1UWEJcus_rw",
            secretKey: "qS2rmPl3tj3hX-_UdY7cO2SLHdm6kzClK5r2iK1Szvs",
            query: self.query
        )
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = context.coordinator
        return unsplashPhotoPicker
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    public class Coordinator: NSObject, UnsplashPhotoPickerDelegate {
        @Binding var image: UIImage?
        @Binding var userName: String?

        init(image: Binding<UIImage?>, userName: Binding<String?>) {
            self._image = image
            self._userName = userName
        }
        
        public func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            guard let photo = photos.first else { return }
            Task {
                let result = await PhotoDownloader.downloadPhoto(photo)
                Task { @MainActor in
                    image = result
                    userName = photo.user.username
                }
            }
        }
        
        public func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        }
    }
}

struct PhotoDownloader {
    private static var cache: URLCache = {
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let diskPath = "unsplash"
        
        if #available(iOS 13.0, *) {
            return URLCache(
                memoryCapacity: memoryCapacity,
                diskCapacity: diskCapacity,
                directory: URL(fileURLWithPath: diskPath, isDirectory: true)
            )
        }
        else {
            #if !targetEnvironment(macCatalyst)
            return URLCache(
                memoryCapacity: memoryCapacity,
                diskCapacity: diskCapacity,
                diskPath: diskPath
            )
            #else
            fatalError()
            #endif
        }
    }()

    static func downloadPhoto(_ photo: UnsplashPhoto) async -> UIImage? {
        guard let url = photo.urls[.regular] else { return nil }

        if let cachedResponse = Self.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            return image
        }
        
        let result: (data: Data, response: URLResponse)? = try? await URLSession.shared.data(from: url)
        guard let result else { return nil }
        
        Self.cache.storeCachedResponse(
            CachedURLResponse(response: result.response, data: result.data),
            for: URLRequest(url: url)
        )
        
        return UIImage(data: result.data)
    }
}
