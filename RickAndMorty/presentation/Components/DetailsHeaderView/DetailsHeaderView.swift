//
//  DetailsHeaderView.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct DetailsHeaderView: View {
    let name: String?
    let status: CharacterStatus?
    
    var body: some View {
        HStack {
            Text(name ?? "")
                .font(.title)
                .bold()
                .foregroundColor(Assets.Colors.primary.swiftUIColor)
                .shadow(radius: 10)
            
            Spacer()
            StatusBadge(status: status)
        }
        .padding(.horizontal, 16)
    }
}
