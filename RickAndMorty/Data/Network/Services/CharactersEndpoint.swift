//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import Alamofire

enum CharactersEndpoint: URLRequestConvertible, URLRequestMultipartable {
    case getCharactersList(page: Int, PageSize: Int)

    case getCharacterDetails(characterId: Int)

    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getCharactersList : return .get
        case .getCharacterDetails : return .get
        }
    }

    var debugDescription: String {
        return "End points"
    }

    // MARK: - Path
    var path: String {
        switch self {

        case .getCharactersList:
            return "/character"
        case .getCharacterDetails(characterId: let characterId):
            return ""
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getCharactersList(let page, let PageSize):
            return ["page": page]
        default: return nil
        }
    }

    var image: ImageFormData? {
        switch self {
        default: return nil
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {

        let url = URL(string: Environment.rootURL.absoluteString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        print("Sending Request with URL:\(url.debugDescription) and params:\(parameters ?? Dictionary())")

        // HTTP Method
        urlRequest.httpMethod = method.rawValue

        urlRequest.setValue(localTimeZoneIdentifier, forHTTPHeaderField: APIHeaders.timeZone.rawValue)

        if let params = parameters {

            do {
                switch self {
                case .getCharactersList, .getCharacterDetails:
                    urlRequest = try URLEncoding.queryString.encode(urlRequest, with: params)

                default:
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
