//
//  NibInitializable.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import UIKit

protocol NibInitializable {
    static var nibIdentifier: String { get }
}

extension NibInitializable where Self: UIViewController {

    static var nibIdentifier: String {
        return String(describing: Self.self)
    }

    static func initFromXib() -> Self {
        return Self(nibName: nibIdentifier, bundle: nil)
    }
}
