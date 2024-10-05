//
//  UIButton+Extension.swift
//  RickAndMorty
//
//  Created by Ahmad on 05/10/2024.
//

import UIKit

// MARK: - UIButton Extension

extension UIButton {
    
    func setSelectedStyle() {
        self.layer.borderWidth = 2
        self.layer.borderColor = Assets.Colors.statusBadge.color.cgColor
        self.backgroundColor = Assets.Colors.aliveColor.color
    }
    
    func setDeselectedStyle() {
        self.tintColor = .black
        self.layer.borderWidth = 1
        self.layer.borderColor = Assets.Colors.border.color.cgColor
        self.backgroundColor = Assets.Colors.background.color
    }
}

extension UIButton {
    func applyRoundedStyle(borderColor: CGColor, borderWidth: CGFloat = 1.0) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
}
