//
//  AnyDecodable.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation

public struct AnyDecodable<T: Codable>: Codable {
    let statusCode: Int?
    let error: ErrorDataEntity?
    let data: T?
}

public struct ErrorDataEntity: Codable {
    let code: Int?
    let icon, title, message: String?
}
