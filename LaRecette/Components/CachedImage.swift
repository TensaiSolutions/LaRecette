//
//  CachedImage.swift
//  LaRecette
//
//  Created by philip sidell on 3/10/25.
//

import SwiftUI

struct CachedImage: View {
    
    @State private var manager = CacheImageManager()
    
    let url: String
    
    var body: some View {
        ZStack {
            if let data = manager.data, let image = UIImage(data: data){
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

struct NewCacheImage: View {
    
    let url: String
    @State var image: UIImage?
    
    var body: some View {
        ZStack{
            if let image = image {
                Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            } else {
//                //Placeholder Image
//                Image(uiImage: UIImage(named: "AppIcon")!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 300, height: 300)
            }
        }
        .task {
            await ImageLoader().loadImage(url) { result in
                switch result {
                case .success(let image):
                    self.image = UIImage(data: image)
                case .failure(let error):
                    //PlaceHolder Image
                    print("Error loading image: \(error)")
                }
            }
        }
        
    }
}
