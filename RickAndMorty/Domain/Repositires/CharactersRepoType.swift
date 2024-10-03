//
//  CharactersRepoType.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


protocol CharactersRepoType: RepositoryType {
    func getCharactersList<T: Codable>(page: Int, PageSize: Int) -> VMResult<T> where T: Decodable, T: Encodable
}
