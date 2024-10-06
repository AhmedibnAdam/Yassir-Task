//
//  MockCharactersRepo.swift
//  RickAndMorty
//
//  Created by Ahmad on 06/10/2024.
//
import RxSwift
@testable import RickAndMorty

class MockCharactersRepo: CharactersRepo {
  
    var invokedPage: Int?
    var invokedPageSize: Int?
    var expectedCharactersList: [CharacterModel]?

    override func getCharactersList<T>(page: Int, PageSize: Int) -> RickAndMorty.VMResult<T> where T : Decodable, T : Encodable {
        
        invokedPage = page
        invokedPageSize = PageSize
        return Observable.create { observer in
            observer.onNext(Event.next(self.expectedCharactersList as! T))
                    observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
