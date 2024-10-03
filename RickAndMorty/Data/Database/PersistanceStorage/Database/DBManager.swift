//
//  DBManager.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import GRDB

protocol Cacheable: PersistableRecord, FetchableRecord { }

protocol DBManaging {
    func createJsonTable(_ tableName: String)
    func addCacheableData<T: Cacheable>(_ cacheableData: [T]?)
    func addCacheableData<T: Cacheable>(_ cacheableData: T?)
    func getCacheableData<T: Cacheable>(_ type: T.Type) -> T?
    func deleteTableData<T: Cacheable>(_ ofType: T.Type)
    func deleteAppData()
    func registerMigration()
}

class DBManager: DBManaging {

    private let DBName = "Employee.db"
    private var databaseQueue: DatabaseQueue?

    let latestMigVarsion = MigrationVersion.lastValue

    lazy var migrator: DatabaseMigrator = {
        return DatabaseMigrator()
    }()


    private func connection() -> DatabaseQueue? {
        do {
            var config = Configuration()
            config.label = "EmployeeDatabase"
            config.busyMode = .callback({ numberOfTries in
                print("SQLITE Error code \(numberOfTries)")
                return numberOfTries < 3
            })
            if databaseQueue == nil {
                databaseQueue = try DatabaseQueue(path: getDatabasePath() ?? "", configuration: config)
            }
            return databaseQueue
        } catch {
            print("SQLITE Error \(error)")
            return nil
        }
    }

    private func migration() {
        //Once any changes on the Database like adding a column or rename etc
        if let databaseQueue = connection() {
            do {
                let appliedMigrations = try databaseQueue.read(migrator.appliedMigrations)
                if !appliedMigrations.contains(latestMigVarsion) {
                    try migrator.migrate(databaseQueue, upTo: latestMigVarsion)
                }
            } catch {
                print("SQLITE Error \(error)")
            }
        }
    }

    private func create(_ tableName: String, tableDefinition: (TableDefinition) -> Void) {
        do {
            try connection()?.write({ dbs in
                if !(try dbs.tableExists(tableName)) {
                    try dbs.create(table: tableName, body: tableDefinition)
                }
            })
        } catch {
            print("Database error \(error)")
        }
    }
    private func insert(_ cacheable: Cacheable) {
        do {
            try connection()?.write({ dbs in
                try cacheable.insert(dbs)
            })
        } catch {
            print("Database error \(error)")
        }
    }

    private func bulkInsert(_ cacheables: [Cacheable]) {
        do {
            try connection()?.write({ dbs in
                for cacheable in cacheables {
                    try cacheable.insert(dbs)
                }
            })
        } catch {
            print("Database error \(error)")
        }
    }

    private func save(_ cacheable: Cacheable) {
        do {
            try connection()?.write({ dbs in
                try cacheable.save(dbs)
            })
        } catch {
            print("Database error \(error)")
        }
    }
    private func bulkSave(_ cacheables: [Cacheable]) {
        do {
            try connection()?.write({ dbs in
                for cacheable in cacheables {
                    try cacheable.save(dbs)
                }
            })
        } catch {
            print("Database error \(error)")
        }
    }
    private func selectByItem<T: Cacheable>(_ ofType: T.Type, command: String, args: StatementArguments) -> T? {
        do {
            return try connection()?.read({ dbs -> T? in
                return try T.filter(sql: command, arguments: args).fetchOne(dbs)
            })
        } catch {
            print("Database error \(error)")
            return nil
        }
    }

    private func select<T: Cacheable>(_ ofType: T.Type) -> T? {
        do {
            return try connection()?.read({ dbs -> T? in
                return try T.fetchOne(dbs)
            })
        } catch {
            print("Database error \(error)")
            return nil
        }
    }

    private func select<T: Cacheable>(_ ofType: T.Type) -> [T]? {
        do {
            return try connection()?.read({ dbs -> [T] in
                return try T.fetchAll(dbs)
            })
        } catch {
            print("Database error \(error)")
            return nil
        }
    }

    private func delete<T: Cacheable>(_ ofType: T.Type) {
        do {
            _ = try connection()?.write({ dbs in
                try T.deleteAll(dbs)
            })
        } catch {
            print("Database error \(error)")
        }
    }

    private func deleteAllData() {
        do {
            _ = try connection()?.write({ dbs in
                try dbs.inTransaction {
                    // Delete all data from all tables
                    try dbs.execute(sql: "DELETE FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")
                    // Reset auto-increment counters
                    try dbs.execute(sql: "DELETE FROM sqlite_sequence;")
                    // Commit the transaction
                    return .commit
                }
            })
        } catch {
            print("Database error \(error)")
        }
        
    }

    private func getDatabasePath() -> String? {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first
        let finalDatabaseURL = documentsUrl?.appendingPathComponent(DBName)
        return finalDatabaseURL?.path
    }
}

extension DBManager {

    func createJsonTable(_ tableName: String) {
        self.create(tableName) { table in
            table.column("id", .text)
            table.column("json", .text)
        }
    }

    func addCacheableData<T: Cacheable>(_ cacheableData: [T]?) {
        if let data = cacheableData {
            self.bulkSave(data)
        }
    }

    func addCacheableData<T: Cacheable>(_ cacheableData: T?) {
        if let data = cacheableData {
            self.save(data)
        }
    }

    func getCacheableData<T: Cacheable>(_ type: T.Type) -> T? {
        return self.select(type)
    }

    func getCacheableListData<T: Cacheable>(_ type: T.Type) -> [T]? {
        return self.select(type)
    }

    func deleteTableData<T: Cacheable>(_ ofType: T.Type) {
        self.delete(ofType)
    }

    func deleteAppData() {
        deleteAllData()
    }
    
    func registerMigration() {
        self.registerMigrations()
        self.migration()
    }
}
