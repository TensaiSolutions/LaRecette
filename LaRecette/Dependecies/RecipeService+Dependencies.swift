//
//  RecipeService+Dependencies.swift
//  LaRecette
//
//  Created by philip sidell on 3/11/25.
//

private struct RecipeServiceKey: InjectionKey {

    static var currentValue: RecipeService = DefaultRecipeService()
}

extension InjectedValues {
    var recipeService: RecipeService {
        get { Self[RecipeServiceKey.self] }
        set { Self[RecipeServiceKey.self] = newValue }
    }
}
