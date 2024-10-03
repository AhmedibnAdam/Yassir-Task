//
//  UseCaseType.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import RxSwift

protocol UseCaseType {
    var repo: RepositoryType { get }
    var loading: BehaviorSubject<Bool> {get set}
    var disposeBag: DisposeBag { get set}
    var errorEntity: PublishSubject<StateDialogueEntity> { get set}

    func start<T: Codable>(_ params: BaseModel?) -> VMResult<T>?
    func start(_ params: BaseModel?) -> VMResultData?
}

extension UseCaseType {
    func start(_ params: BaseModel?) -> VMResultData? { return nil}
}
