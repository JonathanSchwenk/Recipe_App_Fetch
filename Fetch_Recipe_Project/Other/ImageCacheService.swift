//
//  ImageCacheModel.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import Foundation

import SwiftUI

/**
 ImageCacheService image caching system to avoid constant network requests for images. It saves downloaded images to the device's cache directory and retrieves them when needed.
 It uses shared to make sure there is a single instance of the cahce used.
 */
class ImageCacheService {
    static let shared = ImageCacheService()
    private let cacheDirectory: URL
    
    private init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        // Create cache directory if it doesn’t exist
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    /**
     Generates the cache file path for the image url.
     */
    func filePath(for url: URL) -> URL {
        let hashedFileName = "\(url.absoluteString.hashValue).jpg"
        return cacheDirectory.appendingPathComponent(hashedFileName)
    }

    /**
     Loads the image from the cache and returns nil if none is found.
     */
    func loadImage(from url: URL) -> UIImage? {
        let filePath = filePath(for: url)
        if let data = try? Data(contentsOf: filePath), let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    /**
     Save image to cache using the filePath method.
     */
    func saveImage(_ image: UIImage, for url: URL) {
        let filePath = filePath(for: url)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: filePath)
        }
    }
}
