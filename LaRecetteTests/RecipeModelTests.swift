import Foundation
import Testing
@testable import LaRecette

struct RecipeModelTests {
    @Test("large and small image URLs retain their distinct values")
    @MainActor
    func distinctImageURLsArePreserved() {
        let dto = RecipeDTO(uuid: UUID(), name: "Recipe", cuisine: "French",
                            photoURLLarge: "https://example.invalid/large.jpg",
                            photoURLSmall: "https://example.invalid/small.jpg", sourceURL: nil, youtubeURL: nil)
        let recipe = Recipe(recipe: dto)
        #expect(recipe.photoURLLarge == dto.photoURLLarge)
        #expect(recipe.photoURLSmall == dto.photoURLSmall)
    }

    @Test("a missing large image is not replaced by the small image")
    @MainActor
    func missingLargeImageRemainsMissing() {
        let recipe = Recipe(name: "Recipe", cuisine: "French", photoURLSmall: "https://example.invalid/small.jpg")
        #expect(recipe.photoURLLarge == nil)
        #expect(recipe.photoURLSmall == "https://example.invalid/small.jpg")
    }
}
