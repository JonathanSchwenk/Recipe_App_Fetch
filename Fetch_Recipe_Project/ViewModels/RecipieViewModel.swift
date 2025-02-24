//
//  RecipieViewModel.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import Foundation
import SwiftUI

/**
 RecipeViewModel sets the recipes to be displayed. It is an observable object so that it's published fields properly update when changed.
 This class has a fetchRecipes function that gets the recipes to be displayed. It uses MainActor to keep the observable UI updates on the main thread so they update properly.
 */
@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    private let urlString: String
    
    // Endpoint for good data
//    "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    // Endpoint for malformed data
//    "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    // Endpoint for empty data
//    "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

    init(urlString: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") {
        self.urlString = urlString
    }

    /**
     fetchRecipes uses the api endpoint url string that this class takes in to get the recipe data. It is an async function to handle asynchronous calls that might not return right away.
     */
    func fetchRecipes() async {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorMessage = "Failed to fetch data"
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)

                // Handle empty data case
                if decodedResponse.recipes.isEmpty {
                    errorMessage = "No recipes available."
                    recipes = [] // Ensure the list is empty
                } else {
                    recipes = decodedResponse.recipes
                    errorMessage = nil
                }
            } catch {
                // Handle malformed JSON case
                errorMessage = "Failed to load recipes due to bad data."
                recipes = [] // Clear existing recipes
            }
        } catch {
            errorMessage = "Error fetching recipes: \(error.localizedDescription)"
            recipes = [] // Ensure no stale data is shown
        }
    }
}
