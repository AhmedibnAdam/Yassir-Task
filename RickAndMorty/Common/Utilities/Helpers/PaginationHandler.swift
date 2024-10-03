//
//  PaginationHandler.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//


import UIKit
import RxSwift
import RxCocoa

// MARK: - PaginationHandler

class PaginationHandler {
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    
    func reset() {
        currentPage = 1
        hasMorePages = true
    }
    
    func requestNextPage() {
        guard hasMorePages else { return }
        currentPage += 1
        // Request data for next page
    }
    
    func updatePageStatus(hasMore: Bool) {
        hasMorePages = hasMore
    }
}
