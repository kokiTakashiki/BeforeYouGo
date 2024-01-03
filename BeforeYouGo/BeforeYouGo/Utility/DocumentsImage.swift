//
//  DocumentsFile.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2024/01/03.
//

import UIKit

@propertyWrapper
struct DocumentsImage {
    private let folder: URL
    private let filename: String

    init(folderName: String = "images", filename: String) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        self.folder = documentsURL.appendingPathComponent(folderName)
        self.filename = filename
        
        // フォルダがなければ作成
        if !FileManager.default.fileExists(atPath: folder.path) {
           try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
    }

    var wrappedValue: UIImage? {
        get {
            let url = folder.appendingPathComponent(filename)
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return UIImage(data: data)
        }
        set {
            guard let image = newValue else {
                try? FileManager.default.removeItem(at: folder.appendingPathComponent(filename))
                return
            }
            let url = folder.appendingPathComponent(filename)
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            try? data.write(to: url)
        }
    }
}
