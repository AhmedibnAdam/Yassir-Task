//
//  APIHeaders.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//
import Foundation

public var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

enum APIHeaders: String {
    case contentType = "Content-Type"
    case acceptLanguage = "Accept-Language"
    case appVersion = "app-version"
    case apiData = "api-key"
    case headerData = "Authorization"
    case accept = "accept"
    case timeZone = "Time-Zone"
}

enum APIContentType: String {
    case applicationJSON = "application/json"
    case multipart = "multipart/form-data"
}
