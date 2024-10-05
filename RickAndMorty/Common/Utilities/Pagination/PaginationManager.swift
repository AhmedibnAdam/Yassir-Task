//
//  PaginationManager.swift
//  RickAndMorty
//
//  Created by Ahmad on 05/10/2024.
//

import RxSwift
import RxCocoa

protocol PaginationManagerDelegate: AnyObject {
    func requestNextPage()
}

class PaginationManager {
    
    private let disposeBag = DisposeBag()
    weak var delegate: PaginationManagerDelegate?
    
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true
    var currentPage: Int = 1
    private let threshold: CGFloat = 100 // Offset threshold for triggering the next page load

    var onContentOffset: ((CGPoint) -> Void)? {
        didSet {
            // Set up initial state if needed
        }
    }

    var onLoadNextPage: (() -> Void)? {
        didSet {
            // Set up initial state if needed
        }
    }

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
    
    private func shouldLoadNextPage(contentOffset: CGPoint) -> Bool {
        let contentHeight = UIScreen.main.bounds.height // Mocking content height, replace with actual content height
        let offsetThreshold = contentHeight - threshold // Offset threshold for triggering the next page load

        return contentOffset.y >= offsetThreshold && hasMorePages && !isLoading
    }
    
    private func loadNextPage() {
        currentPage += 1
        onLoadNextPage?()
    }
}
