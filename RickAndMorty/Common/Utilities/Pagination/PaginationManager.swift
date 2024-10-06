//
//  PaginationManager.swift
//  RickAndMorty
//
//  Created by Ahmad on 05/10/2024.
//

import RxSwift

protocol PaginationManagerDelegate: AnyObject {
    func requestNextPage()
}

class PaginationManager {
    
    weak var delegate: PaginationManagerDelegate?
    
    var isLoading: Bool = false
    var hasMorePages: Bool = true
    var currentPage: Int = 1
    let threshold: CGFloat = 100
    
    var onContentOffset: ((CGPoint) -> Void)?

    var onLoadNextPage: (() -> Void)?

    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        isLoading = false
    }
    
    func updateLoadingState(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func updateHasMorePages(hasMore: Bool) {
        self.hasMorePages = hasMore
    }
    
    func handleContentOffset(from row: Int, count: Int) {
        guard row >= count - 1 else { return }
        guard hasMorePages else { return }
        loadNextPage()
    }
    
    func shouldLoadNextPage(contentOffset: CGPoint) -> Bool {
        let contentHeight = UIScreen.main.bounds.height // Mocking content height, replace with actual content height
        let offsetThreshold = contentHeight - threshold // Offset threshold for triggering the next page load

        return contentOffset.y >= offsetThreshold && hasMorePages && !isLoading
    }
    
    func loadNextPage() {
        currentPage += 1
        onLoadNextPage?()
    }
}
