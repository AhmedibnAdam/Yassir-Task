//
//  SocketDecodable.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation

// MARK: - SocketDecodable
struct SocketDecodable <T: Codable>: Codable {
    let receivers: [Int]?
    let message: SocketDecodableMessage<T>?
    let dataType, widget: String?

    enum CodingKeys: String, CodingKey {
        case receivers, message
        case dataType = "data_type"
        case widget
    }
}

// MARK: - Message
struct SocketDecodableMessage<T: Codable>: Codable {
    let statusCode: Int?
    let content: SocketDecodableContent<T>?

    enum CodingKeys: String, CodingKey {

        case statusCode = "status_code"
        case content
    }
}

// MARK: - Content
struct SocketDecodableContent <T: Codable>: Codable {
    let data: T?
    let error: String?
}
