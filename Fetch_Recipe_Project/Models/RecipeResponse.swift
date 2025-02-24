//
//  RecipeResponseModel.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import Foundation

/**
 This struct has an array of recipes. It is Codable so it can be converted to and from Json.
 */
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
