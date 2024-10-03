//
//  DismissButtonView.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct DismissButton: View {
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: "chevron.left")
            }
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2)
        }
    }
}
