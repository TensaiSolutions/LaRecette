//
//  RecipeServiceTests.swift
//  LaRecette
//
//  Created by philip sidell on 3/12/25.
//

import Testing
import Foundation
import SwiftData
@testable import LaRecette


@Suite("RecipeService Tests")
struct RecipeServiceTests {
    
    @Test("restaurant service should store recipes")
    @MainActor
    func fetchRecipes_shouldStoreRecipes() async throws {
        var recipeDTOList: [RecipeDTO] = []
        
        recipeDTOList.append(RecipeDTO(uuid: UUID(uuidString: "6a44d56b-9c90-4ba5-959f-50c01536ec88")! , name: "Chicken Tikka Masala", cuisine: "Indian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil))
        
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        let service = MockRecipeService(recipeDTOList: recipeDTOList, modelContext: container.mainContext)
        
        _ = try await service.fetchRecipes(url: "http://example.com/recipes")
        
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate { $0.name == "Chicken Tikka Masala" }
        )
        
        let recipe = try container.mainContext.fetch(descriptor)
        
        #expect(recipe.count == 1)
    }

    @Test("independent test stores do not share recipes")
    @MainActor
    func testStoresRemainIsolated() async throws {
        let first = try ModelContainer(for: Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let second = try ModelContainer(for: Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let dto = RecipeDTO(uuid: UUID(), name: "Isolated Recipe", cuisine: "French", photoURLLarge: nil,
                            photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        let service = MockRecipeService(recipeDTOList: [dto], modelContext: first.mainContext)
        try await service.fetchRecipes(url: "https://example.invalid/unused")
        #expect(try first.mainContext.fetchCount(FetchDescriptor<Recipe>()) == 1)
        #expect(try second.mainContext.fetchCount(FetchDescriptor<Recipe>()) == 0)
    }
}
