//
//  GetCharactersListUseCase.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//



import Foundation
import RxSwift

struct CharactersListRequestEntity: BaseModel {
    var page: Int
    var pageSize: Int
}
struct GetCharactersListUseCase: UseCaseType {
    var repo: RepositoryType = CharactersRepo()
    var loading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var disposeBag: DisposeBag = DisposeBag()
    var errorEntity: PublishSubject<StateDialogueEntity> = PublishSubject()

    func start<T>(_ params: BaseModel?) -> VMResult<T>? where T: Decodable, T: Encodable {
        guard let parameters = params as? CharactersListRequestEntity else { return nil }
        let repo = (repo as! CharactersRepo)

        repo.loading
            .asDriver(onErrorJustReturn: true)
            .drive(loading)
            .disposed(by: disposeBag)

        repo.errorEntity
            .asDriver(onErrorJustReturn: StateDialogueEntity())
            .drive(errorEntity)
            .disposed(by: disposeBag)

        return repo.getCharactersList(page: parameters.page, PageSize: parameters.pageSize)
    }
}
