//
//  APIs.swift
//  LaRecette
//
//  Created by philip sidell on 3/11/25.
//
import Foundation

enum APIs {
    enum Recipes: String, API, CaseIterable {
        static let baseURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net")!
        case allRecipes = "recipes.json"
        case malformed = "recipes-malformed.json"
        case empty = "recipes-empty.json"
    }
}

extension RawRepresentable where RawValue == String, Self: API {
    var url: URL {
        Self.baseURL.appendingPathComponent(rawValue)
    }
}
