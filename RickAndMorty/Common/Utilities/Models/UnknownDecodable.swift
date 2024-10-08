//
//  UnknownDecodable.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation

protocol UnknownDecodable: Decodable, RawRepresentable {
    static var unknown: Self { get }
}

extension UnknownDecodable where RawValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(RawValue.self)
        self = Self(rawValue: raw) ?? .unknown
    }
}
