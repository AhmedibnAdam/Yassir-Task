//
//  Environment.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation

public enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let serverURL: URL = {
        guard let serverURLstring = Environment.infoDictionary["SERVER_URL"] as? String else {
            fatalError("Server URL not set in plist for this environment")
        }
        guard let url = URL(string: serverURLstring) else {
            fatalError("Server URL is invalid")
        }
        return url
    }()

    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary["ROOT_URL"] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()


    static let socketURL: URL = {
        guard let serverURLstring = Environment.infoDictionary["SOCKET_URL"] as? String else {
            fatalError("Socket URL not set in plist for this environment")
        }
        guard let url = URL(string: serverURLstring) else {
            fatalError("Socket URL is invalid")
        }
        return url
    }()



    static let apiKey: String = {
        guard let apiKey = Environment.infoDictionary["API_KEY"] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return apiKey
    }()

    static let environment: String = {
        guard let apiKey = Environment.infoDictionary["ENVIRONMENT"] as? String else {
            fatalError("environment not set in plist for this environment")
        }
        return apiKey
    }()

    static let bundleIdentifier: String = {
        guard let apiKey = Environment.infoDictionary["APP_BUNDLE_ID"] as? String else {
            fatalError("Bundle Identifier not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let loaderAnimationName: String = {
        guard let apiKey = Environment.infoDictionary["LOADER_ANIMATION_NAME"] as? String else {
            fatalError("LOADER ANIMATION NAME not set in plist for this environment")
        }
        return apiKey
    }()

}
