//
//  DBDefaultExampleRepo.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import RxSwift

protocol RepositoryType {}

// Define a struct to represent your data
protocol EventDataProtocol: Codable, Cacheable {
    var json: String { get set }
}

protocol LocalRepository: RepositoryType {
    func createTable()
    func addCacheableData<T: Codable>(_ cacheableData: VMResult<T>, type: CacheableDataTypes?)
    func getCacheableData<T: Codable>(page: Int, type: CacheableDataTypes?) -> VMResult<T>?
    func convertObservableToJSON<T: Codable>(_ observable: VMResult<T>, type: CacheableDataTypes?) -> String?
    func convertJSONToObservable<T: Codable>(_ jsonString: String?) -> VMResult<T>?
    func deleteData(type: CacheableDataTypes?)
}

extension LocalRepository {
    // Function to convert JSON to Observable<Event<T>>
    func convertJSONToObservable<T: Codable>(_ jsonString: String?) -> VMResult<T>? {
        guard let jsonString = jsonString else { return  nil }
        return Observable.create { observer in
            do {
                if let jsonData = jsonString.data(using: .utf8) {
                    let value = try JSONDecoder().decode(T.self, from: jsonData)
                    observer.onNext(Event.next(value))
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

