//
//  Recipes.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import Foundation
import SwiftData

public protocol RecipeService {
    func fetchRecipes(url: String) async throws
}

class DefaultRecipeService: RecipeService {
    
    //let imageCache = ImageCache.shared
    
    @MainActor
    func fetchRecipes(url: String = APIs.Recipes.allRecipes.url.absoluteString) async throws {
        
        let container = try ModelContainer(for: Recipe.self)
        let context = container.mainContext
        
        @Injected(\.networkService) var networkService: NetworkService
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        do {
            /*Remove Stored Recipes & Clear Cache on Refresh. Based on Requirements we dump everything and reload.
             We could enhance this to only remove items if the refresh returns no data
             */
            try clearContext(modelContext: context)
            let recipeData: RecipesDTO? = try await networkService.fetchData(fromUrl: url, session: session)
            for recipe in recipeData?.recipes ?? [] {
                let recipeToStore = Recipe(recipe: recipe)
                context.insert(recipeToStore)
                try context.save()
            }
            
        }
        
        
    }
    
    
    private func clearContext(modelContext: ModelContext) throws {
        try modelContext.delete(model: Recipe.self)
        try modelContext.save()
        //imageCache.clearCache()
    }
}
