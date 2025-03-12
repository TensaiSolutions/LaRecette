//
//  CacheImageManager.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import Foundation

final class CacheImageManager: ObservableObject {
    
    @Published private(set) var data: Data?
    
    private let imageRetriever = ImageRetriever()
    
    @MainActor
    func loadImage(_ imgUrl: String) async {
        do {
            self.data = try await imageRetriever.fetch(imgUrl)
        } catch { }
    }
    
}

