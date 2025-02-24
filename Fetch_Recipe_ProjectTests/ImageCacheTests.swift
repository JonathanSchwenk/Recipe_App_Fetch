//
//  ImageCacheTests.swift
//  Fetch_Recipe_ProjectTests
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import XCTest
@testable import Fetch_Recipe_Project

/**
 Tests the ImageCacheService class.
 */
final class ImageCacheTests: XCTestCase {

    var cacheService: ImageCacheService!
    let sampleURL = URL(string: "https://example.com/sample.jpg")!

    override func setUp() {
        super.setUp()
        cacheService = ImageCacheService.shared
    }

    override func tearDown() {
        removeCachedImage()
        cacheService = nil
        super.tearDown()
    }

    /**
     Tests saveImage and loadImage functions with a valid image.
     */
    func testSaveAndLoadImage() {
        let testImage = UIImage(systemName: "photo")!

        // Save image to cache
        cacheService.saveImage(testImage, for: sampleURL)

        // Load image from cache
        let loadedImage = cacheService.loadImage(from: sampleURL)

        XCTAssertNotNil(loadedImage, "Image should be retrieved from cache.")
    }

    /**
     Test if cache persists images correctly.
     */
    func testCachePersistence() {
        let testImage = UIImage(systemName: "photo")!

        // Save image to cache
        cacheService.saveImage(testImage, for: sampleURL)

        // Simulate app relaunch by creating a new instance
        let newCacheService = ImageCacheService.shared
        let loadedImage = newCacheService.loadImage(from: sampleURL)

        XCTAssertNotNil(loadedImage, "Image should still exist in cache after creating a new instance.")
    }

    /// Test loading a missing image returns nil
    func testLoadMissingImage() {
        let missingImage = cacheService.loadImage(from: URL(string: "https://missingImage.jpg")!)
        XCTAssertNil(missingImage, "Loading a non-existent image should return nil.")
    }

    /**
     Helper function to clean up test files.
     */
    private func removeCachedImage() {
        let fileManager = FileManager.default
        let filePath = cacheService.filePath(for: sampleURL)
        if fileManager.fileExists(atPath: filePath.path) {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
}
