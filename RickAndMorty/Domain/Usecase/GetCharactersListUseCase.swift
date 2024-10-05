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

protocol GetCharactersListUseCaseProtocol {
    func execute<T>(_ params: BaseModel?) -> VMResult<T>? where T: Decodable, T: Encodable
}

class GetCharactersListUseCase: GetCharactersListUseCaseProtocol {
    private let repo: CharactersRepoType
    private let disposeBag = DisposeBag()

    // Injecting the repository via constructor for better flexibility and testing
    init(repo: CharactersRepoType) {
        self.repo = repo
    }

    func execute<T>(_ params: BaseModel?) -> VMResult<T>? where T: Decodable, T: Encodable {
        guard let parameters = params as? CharactersListRequestEntity else { return nil }
        let repo = (repo as! CharactersRepo)
        return repo.getCharactersList(page: parameters.page, PageSize: parameters.pageSize)
    }
}
