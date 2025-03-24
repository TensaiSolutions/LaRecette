//
//  ImageLoader.swift
//  LaRecette
//
//  Created by philip sidell on 3/24/25.
//
import Foundation

//New Cache Logic
@Observable
class ImageLoader {
    typealias ImageResult = (Result<Data, Error>) -> Void
    
    private let cache = Cache<String, Data>()
    
    @MainActor
    func loadImage(_ urlString: String, completion: @escaping ImageResult) async {
        if let cachedData = cache[urlString] {
            completion(.success(cachedData))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cache[urlString] = data
            try cache.saveToDisk(withName: "Image")
            completion(.success(data))
        } catch {
            completion(.failure(error))
            return
        }
        
    }
}
