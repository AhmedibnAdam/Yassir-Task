//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import SwiftUI

struct CharacterView: View {
    var characterDetailsViewModel: CharacterDetailsViewModel
    var dismissAction: (() -> Void)? // Dismiss action
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                CurvedHeaderImage(imageUrl: characterDetailsViewModel.input.characterModel.image)
                
                VStack(alignment: .leading, spacing: 16) {
                    DetailsHeaderView(
                        name: characterDetailsViewModel.input.characterModel.name,
                        status: characterDetailsViewModel.input.characterModel.status
                    )
                    
                    CharacterInfo(
                        species: characterDetailsViewModel.input.characterModel.species,
                        gender: characterDetailsViewModel.input.characterModel.gender?.rawValue
                    )
                    .padding(.vertical, -16)
                    
                    LocationView(location: characterDetailsViewModel.input.characterModel.location?.name)
                    
                    Spacer()
                }
                .padding()
            }
            
            DismissButton(action: dismissAction)
                .padding()
        }
    }
}









