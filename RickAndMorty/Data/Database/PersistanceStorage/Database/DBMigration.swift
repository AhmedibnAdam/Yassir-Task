//
//  DBMigration.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import GRDB

enum MigrationVersion: String {
    case migratorV1 = "V1"
    //.....
    
    static var lastValue: String {
         MigrationVersion.migratorV1.rawValue
    }
}

extension DBManager {
    
    func registerMigrations() {
        migrator.registerMigration(MigrationVersion.migratorV1.rawValue) { (dbs) in
            do {
                let tableMig = TableName.characters.migrationValue
                try dbs.drop(table: tableMig)
                try dbs.create(table: tableMig) { (tbl) in
                    tbl.column("id", .text)
                    tbl.column("json", .text)
                }
            } catch {
                print("SQLITE Error \(error)")
            }
            
            do {
                let tableMig = TableName.characters.migrationValue
                try dbs.drop(table: tableMig)
            } catch {
                print("SQLITE Error \(error)")
            }
            
            do {
                let tableMig = TableName.characters.migrationValue
                try dbs.drop(table: tableMig)
            } catch {
                print("SQLITE Error \(error)")
            }
            
        }
    }
}
