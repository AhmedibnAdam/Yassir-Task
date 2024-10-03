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
    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var errorEntity: PublishSubject<StateDialogueEntity> = PublishSubject()
    var isLoading: Bool = false
    let disposeBag = DisposeBag()

    // MARK: Initiation
    init(localRepository: LocalRepository = CharactersLocalRepo(),
         remoteRepository: CharactersRepoType = CharactersRemoteRepo(),
         loading: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false),
         errorEntity: PublishSubject<StateDialogueEntity> = PublishSubject<StateDialogueEntity>(),
         isLoading: Bool = false) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.loading = loading
        self.errorEntity = errorEntity
        self.isLoading = isLoading
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
