//
//  CharactersEntity.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation

// MARK: - CharactersEntity
struct CharactersEntity: Codable {
    let info: CharactersEntityInfo?
    let results: [CharacterModel]?
}

// MARK: - Info
struct CharactersEntityInfo: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
struct CharacterModel: Codable, Equatable, Hashable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
         lhs.id == rhs.id 
    }
    
    static func != (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
         lhs.id != rhs.id
    }
    
    let id: Int?
      let name: String?
      let status: CharacterStatus?
      let species: String?
      let type: String?
      let gender: Gender?
      let origin, location: Location?
      let image: String?
      let episode: [String]?
      let url: String?
      let created: String?
  }

  enum Gender: String, Codable {
      case female = "Female"
      case male = "Male"
      case unknown = "unknown"
      case genderless = "Genderless"
  }

  // MARK: - Location
struct Location: Codable, Hashable {
      let name: String?
      let url: String?
  }
enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

