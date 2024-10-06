//
//  testPagination.swift
//  RickAndMortyTests
//
//  Created by Ahmad on 06/10/2024.
//

import XCTest
@testable import RickAndMorty

class PaginationManagerTests: XCTestCase {
    
    var paginationManager: PaginationManager!
    
    override func setUp() {
        super.setUp()
        paginationManager = PaginationManager()
    }
    
    override func tearDown() {
        paginationManager = nil
        super.tearDown()
    }

    func testPaginationReset() {
        paginationManager.currentPage = 5
        paginationManager.updateLoadingState(isLoading: true)
        paginationManager.updateHasMorePages(hasMore: false)
        
        paginationManager.resetPagination()
        
        // Assert values have been reset
        XCTAssertEqual(paginationManager.currentPage, 1)
        XCTAssertTrue(paginationManager.hasMorePages)
        XCTAssertFalse(paginationManager.isLoading)
    }
    
    func testLoadNextPageCalledWhenAtThreshold() {
        let expectation = self.expectation(description: "Next page should be loaded")
        paginationManager.onLoadNextPage = {
            expectation.fulfill()
        }
        
        paginationManager.updateHasMorePages(hasMore: true)
        paginationManager.updateLoadingState(isLoading: false)
        
        let contentOffset = CGPoint(x: 0, y: UIScreen.main.bounds.height - 50)
        XCTAssertTrue(paginationManager.shouldLoadNextPage(contentOffset: contentOffset))

        paginationManager.handleContentOffset(from: 9, count: 10)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testDoNotLoadNextPageWhenLoading() {
        paginationManager.updateLoadingState(isLoading: true)
        
        let contentOffset = CGPoint(x: 0, y: UIScreen.main.bounds.height - 50) // Near the threshold
        XCTAssertFalse(paginationManager.shouldLoadNextPage(contentOffset: contentOffset))
    }
    
    func testDoNotLoadNextPageWhenNoMorePages() {
        paginationManager.updateLoadingState(isLoading: false)
        paginationManager.updateHasMorePages(hasMore: false)
        
        let contentOffset = CGPoint(x: 0, y: UIScreen.main.bounds.height - 50) // Near the threshold
        XCTAssertFalse(paginationManager.shouldLoadNextPage(contentOffset: contentOffset))
    }
    
    func testHandleContentOffsetShouldNotTriggerForLowRowCount() {
        paginationManager.updateHasMorePages(hasMore: true)
        paginationManager.updateLoadingState(isLoading: false)

        paginationManager.handleContentOffset(from: 3, count: 10)

        XCTAssertEqual(paginationManager.currentPage, 1)
    }
}

