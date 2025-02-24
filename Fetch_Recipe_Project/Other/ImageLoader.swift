//
//  ImageLoaderModel.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import Foundation

import SwiftUI

/**
 ImageLoader has an image that it publishes to be used elsewhere. It also has a load method that uses the ImageCacheService to load cached images or download and cache images if not already found. It is an observable object so that it's published fields properly update when changed and uses MainActor to keep the observable UI updates on the main thread so they update properly.
 */
@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    /**
     Uses the ImageCacheService to load cached images or download and cache images if not already found. It sets the image variable which gets used elsewhere, like in the RecipeCardView to display the recipe image.
     */
    func load() async {
        if let cachedImage = ImageCacheService.shared.loadImage(from: url) {
            self.image = cachedImage
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
                ImageCacheService.shared.saveImage(downloadedImage, for: url)
            }
        } catch {
            print("Failed to load image from \(url): \(error)")
        }
    }
}
