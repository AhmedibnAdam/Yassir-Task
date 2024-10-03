//
//  DBTablesNames.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation

enum TableName: String {
    case characters                       = "Characters"

    var migrationValue: String {
        return self.rawValue
    }
}
