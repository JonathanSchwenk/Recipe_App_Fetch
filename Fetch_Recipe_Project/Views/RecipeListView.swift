//
//  RecipeListView.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import SwiftUI

/**
 View that displays the recipie cards in a verical list format.
 */
struct RecipeListView: View {
    @StateObject var recipeViewModel = RecipeViewModel()

    var body: some View {
        VStack {
            if !recipeViewModel.recipes.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(recipeViewModel.recipes) { recipe in
                            RecipeCardView(recipe: recipe)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                // Show Empty State or Error Message
                VStack {
                    if let errorMessage = recipeViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text("No recipes available.")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await recipeViewModel.fetchRecipes()
        }
    }
}

#Preview {
    RecipeListView()
}
