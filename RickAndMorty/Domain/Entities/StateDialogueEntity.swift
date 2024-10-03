//
//  StateDialogueEntity.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import UIKit

enum StateDialogueType {
    case error
    case success
    case customError

    var icon: UIImage {
        switch self {
        case .error, .customError:
            return Assets.Assets.tempImage.image
        case .success:
            return Assets.Assets.tempImage.image
        }
    }

    var color: UIColor {
        switch self {
        case .error, .customError:
            return Assets.Colors.primary.color
        case .success:
            return Assets.Colors.secondary.color
        }
    }
}

// MARK: - StateDialogueEntity
public struct StateDialogueEntity {
    var title, description, buttonTitle: String?
    var type: StateDialogueType?
}
