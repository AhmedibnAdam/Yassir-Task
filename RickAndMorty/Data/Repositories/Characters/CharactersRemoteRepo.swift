//
//  CharactersRepoRepo.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import RxSwift

class CharactersRemoteRepo: CharactersRepoType, RepoRequestable {

    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var errorEntity: PublishSubject<StateDialogueEntity> = PublishSubject()
    var isLoading: Bool = false

    func getCharactersList<T: Codable>(page: Int, PageSize: Int) -> VMResult<T> where T: Decodable, T: Encodable {
        return self.request(endpoint: CharactersEndpoint.getCharactersList(page: page, PageSize: PageSize))
        .retry(4)
    }
    
    func getCharacterDetails<T>(characterId: Int) -> VMResult<T> where T: Decodable, T: Encodable {
        return self.request(endpoint: CharactersEndpoint.getCharacterDetails(characterId: characterId))
        .retry(4)
    }




}
