//
//  CachedImage.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//
import SwiftUI

struct CachedImage: View {
    
    @StateObject private var manager = CacheImageManager()
    let url: String
    
    var body: some View {
        ZStack {
            if let data = manager.data,
               let image = UIImage(data: data){
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            }
        }
        .task {
            await manager.loadImage(url)
        }
    }
}

#Preview {
    CachedImage(url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
}

