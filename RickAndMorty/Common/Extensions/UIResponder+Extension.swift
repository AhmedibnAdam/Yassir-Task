//
//  UIResponder+Extension.swift
//  RickAndMorty
//
//  Created by Ahmad on 01/10/2024.
//

import Foundation
import UIKit

extension UIResponder {
    static func getName() -> String {
        return String(describing: self)
    }
}
