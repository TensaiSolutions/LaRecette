//  Recipe.swift
//  RecipeList
//
//  Created by philip sidell on 3/8/25.
//
import Foundation
import SwiftData

@Model
class Recipe: Identifiable {
    @Attribute(.unique) var uuid: UUID
    var name: String
    var cuisine: String
    var photoURLLarge: String?
    var photoURLSmall: String?
    var sourceURL: String?
    var youtubeURL: String?
    
    init(uuid: UUID = UUID(), name: String, cuisine: String, photoURLLarge: String? = nil, photoURLSmall: String? = nil, sourceURL: String? = nil, youtubeURL: String? = nil) {
        self.uuid = uuid
        self.name = name
        self.cuisine = cuisine
        self.photoURLLarge = photoURLSmall
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
    
    convenience init(recipe: RecipeDTO) {
        self.init(
            uuid: recipe.uuid,
            name: recipe.name,
            cuisine: recipe.cuisine,
            photoURLLarge: recipe.photoURLLarge,
            photoURLSmall: recipe.photoURLSmall,
            sourceURL: recipe.sourceURL,
            youtubeURL: recipe.youtubeURL
        )
    }
}
