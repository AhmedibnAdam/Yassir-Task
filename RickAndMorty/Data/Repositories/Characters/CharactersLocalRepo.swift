//
//  CharactersLocalRepo.swift
//  RickAndMorty
//
//  Created by Ahmad  on 03/10/2024.
//

import Foundation
import GRDB

struct CharactersLocalData: EventDataProtocol {
    static var databaseTableName: String {
        return TableName.characters.rawValue
    }
    var json: String
}

class CharactersLocalRepo: LocalRepository, LocalRepositoryType {
  
    // MARK: Properties
    let databaseManager: DBManaging

    // MARK: Initiation
    init() {
        databaseManager = DBManager()
        createTable()
    }

    // MARK: Methods
    func createTable() {
        databaseManager.createJsonTable(TableName.characters.rawValue)
    }

    func addCacheableData<T: Codable>(_ cacheableData: VMResult<T>, type: CacheableDataTypes?) {
        guard let cacheableData = convertObservableToJSON(cacheableData, type: .characters) else { return }
        databaseManager.addCacheableData(CharactersLocalData(json: cacheableData))
    }

    func getCacheableData<T>(page: Int, type: CacheableDataTypes?) -> VMResult<T>? where T: Decodable, T: Encodable {
        let retrievedData: CharactersLocalData? =  page > 1 ? nil : self.databaseManager.getCacheableData(CharactersLocalData.self)
        
        return convertJSONToObservable(retrievedData?.json)
    }

    func deleteData(type: CacheableDataTypes?) {
        databaseManager.deleteTableData(CharactersLocalData.self)
    }
}

// MARK: - Function to convert Observable<Event<T>> to JSON
extension CharactersLocalRepo {

    func convertObservableToJSON<T: Codable>(_ observable: VMResult<T>, type: CacheableDataTypes?) -> String? {
        var json: String?
        _ = observable.subscribe(onNext: { event in
            switch event {
            case .next(let value):
                do {
                    let jsonData = try JSONEncoder().encode(value)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        json = jsonString
                        self.deleteData(type: type)
                        self.databaseManager.addCacheableData(CharactersLocalData(json: jsonString))
                    }
                } catch {
                    print("Error encoding JSON: \(error.localizedDescription)")
                }
            case .error(let error):
                print("Observable error: \(error.localizedDescription)")
            case .completed:
                print("Observable completed")
            }
        })
        return json
    }
}
