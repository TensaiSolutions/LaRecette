import Foundation

/// A local, read-only search over the recipes already loaded by the app.
struct RecipeSearch {
    private let term: String

    init(query: String) {
        term = query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func matches(name: String, cuisine: String) -> Bool {
        term.isEmpty || name.localizedStandardContains(term) || cuisine.localizedStandardContains(term)
    }

    func filter(_ recipes: [Recipe]) -> [Recipe] {
        recipes.filter { matches(name: $0.name, cuisine: $0.cuisine) }
    }
}
