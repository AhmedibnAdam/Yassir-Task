//
//  StatusBadgeView.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import SwiftUI

struct StatusBadge: View {
    let status: CharacterStatus?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Assets.Colors.statusBadge.swiftUIColor)
            Text(status?.rawValue ?? "")
                .font(.subheadline)
                .foregroundColor(Assets.Colors.primary.swiftUIColor)
        }
        .frame(width: 64, height: 32)
        .padding()
    }
}
