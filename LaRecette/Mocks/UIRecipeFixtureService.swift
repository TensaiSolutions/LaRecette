#if DEBUG
import Foundation
import SwiftData

/// Opt-in UI-test fixtures use the app's existing injection seam and never call a remote service.
@MainActor
final class UIRecipeFixtureService: RecipeService {
    private let mode: String
    private let context: ModelContext

    init(mode: String, context: ModelContext) {
        self.mode = mode
        self.context = context
    }

    func fetchRecipes(url: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        switch mode {
        case "populated":
            context.insert(Recipe(name: "Pilot Soup", cuisine: "French"))
            context.insert(Recipe(name: "Pilot Pasta", cuisine: "Italian"))
            try context.save()
        case "failure":
            throw NetworkError.badStatus
        default:
            break
        }
    }
}
#endif
