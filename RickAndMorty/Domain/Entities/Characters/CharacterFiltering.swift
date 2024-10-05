//
//  CharacterFiltering.swift
//  RickAndMorty
//
//  Created by Ahmad on 05/10/2024.
//

protocol CharacterFiltering {
    func filterCharacters(_ characters: [CharacterModel], by status: CharacterStatus?) -> [CharacterModel]
}

class CharacterFilter: CharacterFiltering {
    func filterCharacters(_ characters: [CharacterModel], by status: CharacterStatus?) -> [CharacterModel] {
        guard let status = status else { return characters }
        return characters.filter { $0.status == status }
    }
}
