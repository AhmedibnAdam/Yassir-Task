//
//  CharactersRepo.swift
//  RickAndMorty
//
//  Created by Ahmad on 03/10/2024.
//

import Foundation
import RxSwift

class CharactersRepo: CharactersRepoType {

    private let localRepository: LocalRepository
    private let remoteRepository: CharactersRepoType
    let disposeBag = DisposeBag()

    // MARK: Initiation
    init(localRepository: LocalRepository = CharactersLocalRepo(),
         remoteRepository: CharactersRepoType = CharactersRemoteRepo()) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository

    }
    
    func getCharactersList<T>(page: Int, PageSize: Int) -> VMResult<T> where T : Decodable, T : Encodable {
        let localCharacters: VMResult<T>? = localRepository.getCacheableData(page: page, type: .characters)
        let remoteCharacters : VMResult<T> = remoteRepository.getCharactersList(page: page, PageSize: PageSize)
        localRepository.addCacheableData(remoteCharacters , type: .characters)
        guard let localCharacters  = localCharacters else {
            return remoteCharacters
        }
        return localCharacters
    }
}
