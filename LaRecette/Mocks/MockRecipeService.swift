//
//  MockRecipeService.swift
//  LaRecette
//
//  Created by philip sidell on 3/12/25.
//
import Foundation
import SwiftData

@MainActor
final class MockRecipeService: RecipeService {
    
    var recipeDTOList: [RecipeDTO]
    
    init(recipeDTOList: [RecipeDTO]) {
        self.recipeDTOList = recipeDTOList
    }
    
    @MainActor
    func fetchRecipes(url: String) async throws {
        //Mock the Calls to Network Service and just return the data
        let container = try ModelContainer(for: Recipe.self)
        let context = container.mainContext
        
        //Create a Recipe and persist it
        for recipe in recipeDTOList {
            let recipeToStore = Recipe(recipe: recipe)
            context.insert(recipeToStore)
            try context.save()
        }
    }
}
