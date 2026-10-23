import Foundation
import SwiftData
import Testing
@testable import LaRecette

struct RecipeSearchTests {
    @Test("search matches either field, ignoring case, accents, and surrounding whitespace", arguments: [
        "crème", "CREME", "brulee", "french", "FRENCH", "  French ", "\nCrème Brûlée\n", "", "  ", "\n"
    ])
    func matchesEitherField(query: String) {
        #expect(RecipeSearch(query: query).matches(name: "Crème Brûlée", cuisine: "French"))
    }

    @Test("unmatched text does not match either field")
    func noMatch() {
        #expect(!RecipeSearch(query: "Italian").matches(name: "Crème Brûlée", cuisine: "French"))
    }

    @Test("filtering preserves input order and never changes the stored recipes")
    @MainActor
    func filteringIsReadOnly() throws {
        let container = try ModelContainer(for: Recipe.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let recipes = [Recipe(name: "Crème Brûlée", cuisine: "French"),
                       Recipe(name: "Pilot Pasta", cuisine: "Italian"),
                       Recipe(name: "Pilot Soup", cuisine: "French")]
        for recipe in recipes { container.mainContext.insert(recipe) }
        try container.mainContext.save()
        let french = RecipeSearch(query: "French").filter(recipes)
        #expect(french.map(\.uuid) == [recipes[0].uuid, recipes[2].uuid])
        #expect(RecipeSearch(query: "Pasta").filter(recipes).map(\.uuid) == [recipes[1].uuid])
        #expect(RecipeSearch(query: "unknown").filter(recipes).isEmpty)
        #expect(RecipeSearch(query: "  ").filter(recipes).map(\.uuid) == recipes.map(\.uuid))
        #expect(try container.mainContext.fetchCount(FetchDescriptor<Recipe>()) == 3)
        #expect(recipes.map(\.name) == ["Crème Brûlée", "Pilot Pasta", "Pilot Soup"])
    }
}
