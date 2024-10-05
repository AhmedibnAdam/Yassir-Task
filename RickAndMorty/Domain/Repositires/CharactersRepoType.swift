//
//  CharactersRepoType.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//
import RxSwift

protocol CharactersRepoType: RepositoryType {
    
    func getCharactersList<T: Codable>(page: Int, PageSize: Int) -> VMResult<T> where T: Decodable, T: Encodable
}


protocol RemoteRepositoryType {
    func getCharactersList<T: Decodable & Encodable>(page: Int, pageSize: Int) -> VMResult<T>
}

protocol LocalRepositoryType {
    
    func getCacheableData<T>(page: Int, type: CacheableDataTypes?) -> VMResult<T>? where T: Decodable, T: Encodable
    
    func addCacheableData<T: Codable>(_ cacheableData: VMResult<T>, type: CacheableDataTypes?)
}
