//
//  UserDefaultHelper.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

fileprivate protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional : OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}

extension UserDefaults {
    
    @UserDefault(key: "language", defaultValue: "en")
    static var language: String
    
}
