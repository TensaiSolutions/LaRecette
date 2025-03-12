//
//  RecipeDTO.swift
//  LaRecette
//
//  Created by philip sidell on 3/8/25.
//

import Foundation

struct RecipeDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    var uuid: UUID
    var name: String
    var cuisine: String
    var photoURLLarge: String?
    var photoURLSmall: String?
    var sourceURL: String?
    var youtubeURL: String?
}

struct RecipesDTO: Decodable {
    var recipes: [RecipeDTO]
}



