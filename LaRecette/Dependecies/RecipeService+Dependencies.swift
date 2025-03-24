//
//  RecipeService+Dependencies.swift
//  LaRecette
//
//  Created by philip sidell on 3/11/25.
//
@MainActor
private struct RecipeServiceKey: @preconcurrency InjectionKey {
    static var currentValue: RecipeService = DefaultRecipeService()
}

extension InjectedValues {
    var recipeService: RecipeService {
        get { Self.self[RecipeServiceKey.self] }
        set { Self.self[RecipeServiceKey.self] = newValue }
    }
}
