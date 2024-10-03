//
//  LocationView.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct LocationView: View {
    let location: String?
    
    var body: some View {
        HStack {
            Text("Location:")
                .font(.headline)
                .foregroundColor(Assets.Colors.primary.swiftUIColor)
            
            Text(location ?? "")
                .font(.subheadline)
        }
        .padding(16)
    }
}
