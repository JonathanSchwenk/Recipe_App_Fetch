//
//  RecipecardView.swift
//  Fetch_Recipe_Project
//
//  Created by Jonathan Schwenk on 2/20/25.
//

import SwiftUI

/**
 View that displays the recipe info on a small card format. It uses the ImageLoader class to get the cached image if one exists. It also takes in a Recipe as a paramter to fill out the cards info.
 */
struct RecipeCardView: View {
    let recipe: Recipe
    @StateObject private var imageLoader: ImageLoader

    init(recipe: Recipe) {
        self.recipe = recipe
        if let imageURL = recipe.photoURLSmall {
            _imageLoader = StateObject(wrappedValue: ImageLoader(url: imageURL))
        } else {
            _imageLoader = StateObject(wrappedValue: ImageLoader(url: URL(string: "about:blank")!))
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(recipe.cuisine)
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.top, 20)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(recipe.name)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)

            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await imageLoader.load()
                        }
                    }
            }

            Spacer()

            VStack(spacing: 10) {
                if let youtubeURL = recipe.youtubeURL {
                    Link(destination: youtubeURL) {
                        HStack {
                            Image(systemName: "play.rectangle.fill")
                                .foregroundColor(.red)
                            Text("Watch on YouTube")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                }

                if let sourceURL = recipe.sourceURL {
                    Link(destination: sourceURL) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("View Recipe Source")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 10)

        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.5)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

#Preview {
    RecipeCardView(recipe: Recipe(
        id: "12345",
        cuisine: "Italian",
        name: "Spaghetti Carbonara",
        photoURLLarge: URL(string: "https://www.kasandbox.org/programming-images/avatars/mr-pants.png"),
        photoURLSmall: URL(string: "https://www.kasandbox.org/programming-images/avatars/mr-pants.png"),
        sourceURL: URL(string: "https://some.url/index.html"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=someid")
    ))
}
