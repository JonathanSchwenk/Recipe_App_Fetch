//
//  FetchRecipeTests.swift
//  Fetch_Recipe_ProjectTests
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import XCTest
@testable import Fetch_Recipe_Project

/**
 Tests the RecipeViewModel class.
 */
final class FetchRecipeTests: XCTestCase {

    var viewModel: RecipeViewModel!

    @MainActor
    override func setUp() {
        super.setUp()
        viewModel = RecipeViewModel()
    }

    @MainActor
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    /**
     Tests a success case for the fetch recipes function.
     */
    func testFetchRecipes_Success() async {
        await viewModel.fetchRecipes()

        await MainActor.run {
            XCTAssertFalse(viewModel.recipes.isEmpty, "Recipes should not be empty after fetching.")
            XCTAssertNil(viewModel.errorMessage, "Error message should be nil on success.")
        }
    }

    /**
     Tests a failure case for the fetch recipes function where the api endpoint url is invalid.
     */
    func testFetchRecipes_InvalidUrl() async {
        let viewModel = await RecipeViewModel(urlString: "invalid_url")
        
        await viewModel.fetchRecipes()

        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil for failed fetch.")
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when fetch fails.")
        }
    }
    
    /**
     Tests a failure case where the data is malformed.
     */
    func testFetchRecipes_MalformedData() async {
        let viewModel = await RecipeViewModel(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        
        await viewModel.fetchRecipes()

        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil for malformed JSON.")
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when JSON is bad.")
        }
    }
    
    /**
     Tests a case where the data is empty.
     */
    func testFetchRecipes_Empty() async {

        let viewModel = await RecipeViewModel(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")

        await viewModel.fetchRecipes()

        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil for empty data.")
            XCTAssertEqual(viewModel.errorMessage, "No recipes available.", "Expected 'No recipes available.' but got \(viewModel.errorMessage ?? "nil")")
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes array should be empty when API returns an empty list.")
        }
    }
}
