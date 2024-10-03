//
//  TableView+extensions.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//
import Foundation
import UIKit
import RxCocoa
import RxSwift

extension UITableView {
    
    func addLoadRefresher(_ refreshControl: UIRefreshControl, _ isLoading: Bool) {
        self.setContentOffset(
            CGPoint(x: 0, y: -refreshControl.frame.size.height),
            animated: false)
        refreshControl.rx.isRefreshing.onNext(isLoading)
    }
    
    func addBottomActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 55))
        activityIndicator.startAnimating()
        activityIndicator.style = .medium
        self.tableFooterView = activityIndicator
    }
    
    func removeBottomActivityIndicator() {
        self.tableFooterView = nil
    }

    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = "    \(message)    "
        // styling
        label.sizeToFit()
        label.textColor = UIColor.lightGray

        self.tableFooterView = label
    }

    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.tableFooterView = nil
        self.separatorStyle = .singleLine
    }

    func setEmptyBackground(message: String!, numberOfItems: Int) {

        if numberOfItems > 0 {
            backgroundView = nil
            return
        }

        if backgroundView == nil {
            let bgView = UIView()
            backgroundView = bgView
            let label = UILabel()
            label.tag = 101
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            backgroundView!.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bgView.topAnchor),
                label.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
            ])
        }

        guard let label = backgroundView?.viewWithTag(101) as? UILabel else { return }
        label.text = message ?? NSLocalizedString("Empty List", comment: "Default empty message used in all lists if retrieved empty")
    }

    func setEmptyBackground(emptyListData: EmptyListView) {

        if emptyListData.itemCount > 0 {
            backgroundView = nil
            return
        }

        if backgroundView == nil {
            let bgView = UIView()
            backgroundView = bgView
            let emptyView = EmptyView()
            emptyView.configureView(emptyViewData: emptyListData)
            emptyView.tag = 101
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView!.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
                emptyView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }

        guard var emptyListView = backgroundView?.viewWithTag(101) as? EmptyListView else { return }
        emptyListView.title = emptyListData.title
        emptyListView.image = emptyListData.image
    }

    func hideEmptyView() {
        backgroundView = nil
    }

    func setEmptyListBackground(emptyListData: EmptySharedListView) {

        if emptyListData.itemCount > 0 {
            backgroundView = nil
            return
        }

        if backgroundView == nil {
            let bgView = UIView()
            backgroundView = bgView
            let emptyView = EmptyView()
            emptyView.configureView(emptyViewData: EmptyListView(title: emptyListData.title, image: emptyListData.image, itemCount: emptyListData.itemCount))
            emptyView.tag = 101
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView!.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
                emptyView.heightAnchor.constraint(equalToConstant: 80)
            ])
        }

        guard var emptySharedListView = backgroundView?.viewWithTag(101) as? EmptySharedListView else { return }
        emptySharedListView.title = emptyListData.title
        emptySharedListView.image = emptyListData.image
        emptySharedListView.description = emptyListData.description
    }

}

extension Reactive where Base: UITableView {

    public var itemsCountMessage: Binder<Int> {
        return Binder.init(self.base, binding: { (tv, count) in
            tv.setEmptyBackground(message: nil, numberOfItems: count)
        })
    }

    var emptyView: Binder<EmptyListView> {
        return Binder.init(self.base, binding: { (tv, emptyListData) in
            tv.setEmptyBackground(emptyListData: emptyListData)
        })
    }

    var hideEmptyView: Binder<Void> {
        return Binder.init(self.base, binding: { (tv, _) in
            tv.hideEmptyView()
        })
    }

    var sharedEmptyList: Binder<EmptySharedListView> {
        return Binder.init(self.base, binding: { (tv, emptySharedListData) in
            tv.setEmptyListBackground(emptyListData: emptySharedListData)
        })
    }
}

extension UICollectionView {

func setEmptyBackground(message: String!, numberOfItems: Int) {

    if numberOfItems > 0 {
        backgroundView = nil
        return
    }

    if backgroundView == nil {
        let bgView = UIView()
        backgroundView = bgView
        let label = UILabel()
        label.tag = 101
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        backgroundView!.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: bgView.topAnchor),
            label.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bgView.bottomAnchor)
        ])
    }

    guard let label = backgroundView?.viewWithTag(101) as? UILabel else { return }
    label.text = message ?? NSLocalizedString("Empty List", comment: "Default empty message used in all lists if retrieved empty")
}

func setEmptyBackground(emptyListData: EmptyListView) {

    if emptyListData.itemCount > 0 {
        backgroundView = nil
        return
    }

    if backgroundView == nil {
        let bgView = UIView()
        backgroundView = bgView
        let emptyView = EmptyView()
        emptyView.configureView(emptyViewData: emptyListData)
        emptyView.tag = 101
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView!.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    guard var emptyListView = backgroundView?.viewWithTag(101) as? EmptyListView else { return }
    emptyListView.title = emptyListData.title
    emptyListView.image = emptyListData.image
}

    func setEmptyListBackground(emptyListData: EmptySharedListView) {

        if emptyListData.itemCount > 0 {
            backgroundView = nil
            return
        }

        if backgroundView == nil {
            let bgView = UIView()
            backgroundView = bgView
            let emptyView = EmptyView()
            emptyView.configureView(emptyViewData: EmptyListView(title: emptyListData.title, image: emptyListData.image, itemCount: emptyListData.itemCount))
            emptyView.tag = 101
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView!.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
                emptyView.heightAnchor.constraint(equalToConstant: 80)
            ])
        }

        guard var emptySharedListView = backgroundView?.viewWithTag(101) as? EmptySharedListView else { return }
        emptySharedListView.title = emptyListData.title
        emptySharedListView.image = emptyListData.image
        emptySharedListView.description = emptyListData.description
    }
}


extension Reactive where Base: UICollectionView {

    public var itemsCountMessage: Binder<Int> {
        return Binder.init(self.base, binding: { (tv, count) in
            tv.setEmptyBackground(message: nil, numberOfItems: count)
        })
    }

    var emptyView: Binder<EmptyListView> {
        return Binder.init(self.base, binding: { (tv, emptyListData) in
            tv.setEmptyBackground(emptyListData: emptyListData)
        })
    }

    var sharedEmptyList: Binder<EmptySharedListView> {
        return Binder.init(self.base, binding: { (tv, emptySharedListData) in
            tv.setEmptyListBackground(emptyListData: emptySharedListData)
        })
    }
}


struct EmptyListView {
    var title: String
    var image: UIImage
    var itemCount: Int
}

struct EmptySharedListView {
    var title: String
    var description: String
    var image: UIImage
    var itemCount: Int
}


extension UITableView {

    func isCellAtIndexPathFullyVisible(_ indexPath: IndexPath) -> Bool {

        let cellFrame = rectForRow(at: indexPath)
        return bounds.contains(cellFrame)
    }

    func indexPathsForFullyVisibleRows() -> [IndexPath] {

        let visibleIndexPaths = indexPathsForVisibleRows ?? []

        return visibleIndexPaths.filter { indexPath in
            return isCellAtIndexPathFullyVisible(indexPath)
        }
    }

    var lastCellIndexPath: IndexPath? {
        for section in (0..<self.numberOfSections).reversed() {
            let rows = numberOfRows(inSection: section)
            guard rows > 0 else { continue }
            return IndexPath(row: rows - 1, section: section)
        }
        return nil
    }
}
