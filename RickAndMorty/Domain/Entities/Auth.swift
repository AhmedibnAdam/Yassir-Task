//
//  Auth.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation

// MARK: - Auth
struct EmployeeAuth: BaseModel {
    let statusCode: Int
    let error: ErrorDataEntity?
    let data: AuthDataEntity
}

// MARK: - AuthDataClass
struct AuthDataEntity: BaseModel {
    let userData, tokenType, refresh: String?
    let expiresIn: Int?
    let idToken: String?
    var secretKey: String?

    enum CodingKeys: String, CodingKey {
        case userData = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refresh, idToken
        case secretKey = "secret_key"
    }
}
