//
//  APIError.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation

// MARK: - HTTP Response Entity
struct HTTPResponseEntity: Codable {
    let statusCode: Int?
    let error: ErrorEntity?
}

// MARK: - Error Entity
struct ErrorEntity: Codable {
    let code: Int?
    let icon, title, message: String?
}

// MARK: - API Error Codes
enum APIErrorCode: Int {
    case unauthorized = 401
    case none = -10000
    case userNotFound = 614
    case businessError = 422
}

// MARK: - API Error
enum APIError: Error {
    case offline
    case server
    case forbidden
    case notFound
    case timedOut
    case internalServerError
    case failedToCommunicateWithServer
    case badResponse
    case other(Error, data: Data?, errorCode: Int? = nil)
    case canceledLogin
}

// MARK: - Localized Error Description
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .offline:
            return Localize.offline
        case .server:
            return Localize.server
        case .timedOut:
            return Localize.timedOut
        case .internalServerError:
            return Localize.internalServerError
        case .failedToCommunicateWithServer:
            return Localize.failedToCommunicateWithServer
        case .badResponse:
            return Localize.badResponse
        case .notFound:
            return Localize.notFound
        case .forbidden:
            return Localize.forbidden
        case .canceledLogin:
            return Localize.canceledSuccessfullyTitleLabel
        case .other(_, data: let data, errorCode: let errorCode):
            return handleErrorObject(data: data, errorCode: errorCode)?.error?.message

        }
    }
    
    private func handleOtherError(error: Error, data: Data?) -> String? {
        guard let data = data else {
            return error.localizedDescription
        }
        
        if let networkError = try? JSONDecoder().decode(HTTPResponseEntity.self, from: data) {
            return networkError.error?.message ?? ""
        }
        
        return String(data: data, encoding: .utf8) ?? error.localizedDescription
    }
}

// MARK: - Error Title
extension APIError {
    var errorTitle: String? {
        switch self {
        case .other(_, let data, _):
            return handleOtherErrorTitle(data: data)
        default:
            return nil
        }
    }
    
    private func handleOtherErrorTitle(data: Data?) -> String? {
        guard let data = data else { return nil }
        
        if let networkError = try? JSONDecoder().decode(HTTPResponseEntity.self, from: data) {
            return networkError.error?.title ?? ""
        }
        
        return nil
    }
}

// MARK: - Error Object
extension APIError {
    var errorObject: HTTPResponseEntity? {
        switch self {
        case .other(_, let data, let errorCode):
            return handleErrorObject(data: data, errorCode: errorCode)
        default:
            return nil
        }
    }
    
    private func handleErrorObject(data: Data?, errorCode: Int?) -> HTTPResponseEntity? {
        guard let data = data, errorCode == APIErrorCode.businessError.rawValue else {
            return nil
        }
        
        return try? JSONDecoder().decode(HTTPResponseEntity.self, from: data)
    }
}
