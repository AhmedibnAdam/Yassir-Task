//
//  Instantiator.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import UIKit

protocol Instantiator {
    static func instantiate() -> Self
}

extension Instantiator {

    static func instantiate(StoryboardName name: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        // Forced Typecast is safe here because if your controller's class
        // must always match its storyboard ID
        if #available(iOS 13, *) {
            guard let storyboardInstantiate = storyboard
                .instantiateViewController(identifier: id) as? Self
            else { return Self.self as! Self }
            return storyboardInstantiate
        } else {
            guard let storyboardInstantiate = storyboard
                .instantiateViewController(withIdentifier: id) as? Self
            else { return Self.self as! Self }

            return storyboardInstantiate
        }
    }

    static func instantiate() -> Self {
        let id = String(describing: self)
        let nib = UINib(nibName: id, bundle: Bundle.main)
        guard let storyboardInstantiate = nib.instantiate(withOwner: nil, options: nil)[0]
                as? Self else { return Self.self as! Self }

        return storyboardInstantiate
    }
}
// swiftlint:enable force_cast

extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        guard let data = data else {
            removeObject(forKey: defaultName)
            return
        }
        do {
            let encoded = try JSONEncoder().encode(data)
            set(encoded, forKey: defaultName)
        } catch {
            print("Failed to encode data for key \(defaultName): \(error)")
        }
    }
}
extension UserDefaults {
  func codableObject <T: Codable> (dataType: T.Type, key: String) -> T? {
    guard let userDefaultData = data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: userDefaultData)
  }
}
