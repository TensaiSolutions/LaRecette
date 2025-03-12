//
//  RecipeCardView.swift
//  LaRecette
//
//  Created by philip sidell on 3/12/25.
//

import SwiftUI

struct RecipeCardView: View {
//    @State private var name: String
//    @State private var cuisine: String
    @State var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            if let image = recipe.photoURLSmall {
                CachedImage(url: image)
            }
            cardText.padding(.horizontal, 8)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24.0))
        .shadow(radius: 8.0)
    }
    
    var cardText: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.headline)
            HStack(spacing: 4.0) {
                Image(systemName: "fork.knife.circle")
                Text(recipe.cuisine)
            }
            .foregroundColor(.gray)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    let sampleRecipe = Recipe(
        name: "Phils Mac & Cheese",
        cuisine: "American",
        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
    )
    RecipeCardView(recipe: sampleRecipe)
}
