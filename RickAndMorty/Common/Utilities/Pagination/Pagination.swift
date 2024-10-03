//
//  Pagination.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import UIKit

protocol Pagination: AnyObject {
    /// array.count - offset to start call next page
    var pageOffset: Int { get set }
    var hasMore: Bool { get set }
    var pageNumber: Int { get set }
    /// Set it initially to nil
    var inRequest: Bool { get set }

    /// call this in (will display cell) with your tableview
    func nextPage(from row: Int, count: Int)
    func willCallNextPage()

    /// Call whenever list is refreshed
    func resetPagination()

    /// Place your request here
    func request()
}

extension Pagination {

    func nextPage(from row: Int, count: Int) {

//        if row >= pageOffset {
            guard row >= count - 1 else { return }
            guard hasMore, !inRequest else { return }

            self.pageNumber += 1

            willCallNextPage()
            request()
//        }
    }

    func resetPagination() {
        self.pageNumber = 1
        hasMore = true
    }
}
