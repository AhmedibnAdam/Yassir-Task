//
//  CharacterInfoView.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct CharacterInfo: View {
    let species: String?
    let gender: String?
    
    var body: some View {
        HStack {
            Text("\(species ?? "") . ")
                .bold()
                .font(.subheadline)
            
            
            Text(gender ?? "")
                .font(.subheadline)
        }
        .padding(.horizontal, 16)
    }
}
