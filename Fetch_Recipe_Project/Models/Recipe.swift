//
//  RecipeModel.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import Foundation

/**
 Recipe is a struct that holds the required and optional recipe data. It is Codable so it can be converted to and from Json.
 */
struct Recipe: Identifiable, Codable {
    let id: String
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    /**
     Enum to help map Json keys when decoding.  It makes sure that the swift and Json keys match properly.
     */
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
