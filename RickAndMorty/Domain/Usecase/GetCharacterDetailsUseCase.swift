//
//  GetCharacterDetailsUseCase.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//



import Foundation
import RxSwift

struct CharactersRequestEntity: BaseModel {
    let characterId: Int
}
struct GetCharacterDetailsUseCase: UseCaseType {
    var repo: RepositoryType = CharactersRemoteRepo()
    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var disposeBag: DisposeBag = DisposeBag()
    var errorEntity: PublishSubject<StateDialogueEntity> = PublishSubject()

    func start<T>(_ params: BaseModel?) -> VMResult<T>? where T: Decodable, T: Encodable {
        guard let parameters = params as? CharactersRequestEntity else { return nil }
        let repo = (repo as! CharactersRemoteRepo)

        repo.loading
            .asDriver(onErrorJustReturn: true)
            .drive(loading)
            .disposed(by: disposeBag)

        repo.errorEntity
            .asDriver(onErrorJustReturn: StateDialogueEntity())
            .drive(errorEntity)
            .disposed(by: disposeBag)

        return repo.getCharacterDetails(characterId: parameters.characterId)
    }
}
