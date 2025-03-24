//
//  ImageRetriever.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import Foundation

enum RetrieverError: Error {
    case invalidURL
}

struct ImageRetriever {
    func fetch(_ imgURL: String) async throws -> Data {
        if let data = await ImageCache.shared.getObject(forkey: imgURL as NSString) {
            return data
        }
        
        guard let url = URL(string: imgURL) else {
            throw RetrieverError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await ImageCache.shared.setObject(object: data as NSData, forKey: imgURL as NSString)
            return data
        } catch {
            throw RetrieverError.invalidURL
        }
    }
}
