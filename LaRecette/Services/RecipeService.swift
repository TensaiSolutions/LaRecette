//
//  Recipes.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//
import Foundation
import SwiftData

public protocol RecipeService {
    func fetchRecipes(modelContext: ModelContext, url: String) async throws
}

class DefaultRecipeService: RecipeService {
    @MainActor
    func fetchRecipes(modelContext: ModelContext, url: String = APIs.Recipes.allRecipes.url.absoluteString) async throws {
        @Injected(\.networkService) var networkService: NetworkService
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        do {
            /*Remove Stored Recipes & Clear Cache on Refresh. Based on Requirements we dump everything and reload.
                We could enhance this to only remove items if the refresh returns no data
            */
            try clearContext(modelContext: modelContext)
            let recipeData: RecipesDTO? = try await networkService.fetchData(fromUrl: url, session: session)
                for recipe in recipeData?.recipes ?? [] {
                    let recipeToStore = Recipe(recipe: recipe)
                    modelContext.insert(recipeToStore)
                    try modelContext.save()
                }
            
            }
        }
    private func clearContext(modelContext: ModelContext) throws {
        try modelContext.delete(model: Recipe.self)
        try modelContext.save()
        ImageCache.shared.clearCache()
    }
}
