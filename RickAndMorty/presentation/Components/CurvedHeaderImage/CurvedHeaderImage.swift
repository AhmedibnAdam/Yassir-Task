//
//  CurvedHeaderImage.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct CurvedHeaderImage: View {
    let imageUrl: String?
    
    var body: some View {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 384)
                    .cornerRadius(32)
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
                    .frame(height: 384)
                    .cornerRadius(32)
                    .shadow(radius: 10)
            }
        } else {
            Image(uiImage: Assets.Assets.splashImage.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 384)
                .cornerRadius(32)
                .shadow(radius: 10)
        }
    }
}
