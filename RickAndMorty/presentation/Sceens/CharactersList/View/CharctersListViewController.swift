//
//  CharctersListViewController.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import SwiftUI

class CharctersListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var aliveButton: UIButton!
    @IBOutlet weak var deadButton: UIButton!
    @IBOutlet weak var unKnownButton: UIButton!

    // MARK: - Properties
    var viewModel = CharactersListViewModel()
    let refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()
    var pageOffset: Int = 20
    var pageNumber: Int = 1
    var hasMore: Bool = true
    var inRequest: Bool = false
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        request() 
        setupUI()
    }
}
// MARK: - CharctersListViewController UI Setup
extension CharctersListViewController {

    func setupUI() {
        setupLabel()
        setupButtonsUI()
        setupRequestsTableView()
        setupPullToRefresh()
        bindObservables()
    }
    
    func setupLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = Assets.Colors.primary.color
        titleLabel.textAlignment = .center
        titleLabel.text = Localize.characters
        titleLabel.shadowColor = Assets.Colors.secondary.color
        titleLabel.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    func setupButtonsUI() {
        configureButton(aliveButton)
        configureButton(deadButton)
        configureButton(unKnownButton)
    }

    private func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = Assets.Colors.background.color
        button.layer.borderWidth = 1
        button.layer.borderColor = Assets.Colors.border.color.cgColor
        button.tintColor = Assets.Colors.primary.color
    }

    /// Set up the table view properties and register the necessary cell types.
    private func setupRequestsTableView() {
        registerCell(id: CharcterTableViewCell.getName(), tableView: tableView)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.showsVerticalScrollIndicator = false
    }

    /// Bind the view model to the table view and handle empty states and selection events.
    private func bindObservables() {
        bindCharactersList()
        bindLoadingState()
        bindModelSelection()
        paginationBinding()
        bindButtonActions()

    }

    /// Binds the characters list to the table view.
    private func bindCharactersList() {
        viewModel.output.filteredCharactersList
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                guard let self = self, let item = item else { return UITableViewCell() }
                let viewModel = CharacterTableViewCellViewModel(model: item)
                return CharcterTableViewCell.populateCell(tableView: tableView, indexPath: IndexPath(row: row, section: 0), viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.filteredCharactersList
            .withLatestFrom(viewModel.output.isLoading) {($0, $1)}
            .subscribe(onNext: { [weak self] characters, isLoading in
                self?.handleEmptyView(for: characters.count, isLoading: isLoading)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.errorEntity
        .asDriver(onErrorJustReturn: StateDialogueEntity())
        .drive(rx.message)
        .disposed(by: disposeBag)
    }

    /// Binds the loading state and updates the empty view accordingly.
    private func bindLoadingState() {
        viewModel.output.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.isAnimating)
            .disposed(by: disposeBag)
    }

    /// Handles the empty view when the list is empty and not loading.
    private func handleEmptyView(for count: Int, isLoading: Bool) {
        if !isLoading {
            let emptyView = EmptyListView(
                title: Localize.notFound,
                image: Assets.Assets.tempImage.image,
                itemCount: count
            )
            tableView.rx.emptyView.onNext(emptyView)
        }
    }

    /// Binds the table view selection to perform actions when an item is selected.
    private func bindModelSelection() {
        tableView.rx.modelSelected(CharacterModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.navigateToCharacterDetails(with: model)
            })
            .disposed(by: disposeBag)
    }

    /// Navigates to the character details view.
    private func navigateToCharacterDetails(with model: CharacterModel) {
        presentCharacterView(character: model)
    }
    
    func presentCharacterView(character: CharacterModel) {
        let characterView = CharacterView(characterDetailsViewModel: CharacterDetailsViewModel(characterModel: character), dismissAction: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
        
        let hostingController = UIHostingController(rootView: characterView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
        
    }
    
    private func getButtonActive(sender: UIButton) {
        sender.layer.borderWidth = 5
        sender.layer.borderColor = Assets.Colors.secondary.color.cgColor
    }
    
    private func getButtonDisActive(sender: UIButton) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = Assets.Colors.border.color.cgColor
    }
    
    func bindButtonActions() {
        let buttons: [(UIButton, CharacterStatus?)] = [
            (aliveButton, .alive),
            (deadButton, .dead),
            (unKnownButton, .unknown)
        ]

        buttons.forEach { button, filterStatus in
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.toggleButtonSelection(selectedButton: button)
                    self.updateFilterStatus(for: button, with: filterStatus)
                })
                .disposed(by: disposeBag)
        }
    }

    private func toggleButtonSelection(selectedButton: UIButton) {
        let buttons = [aliveButton, deadButton, unKnownButton]
        buttons.forEach { button in
            guard let button else { return }
            button.isSelected = (button == selectedButton) ? !button.isSelected : false
            button.isSelected ? getButtonActive(sender: button) : getButtonDisActive(sender: button)
        }
    }

    private func updateFilterStatus(for button: UIButton, with status: CharacterStatus?) {
        if button.isSelected {
            viewModel.input.filterStatus.onNext(status)
        } else {
            viewModel.input.filterStatus.onNext(nil)
        }
    }

}

// MARK: - Pagination
extension CharctersListViewController: Pagination {

    // MARK: - Pull to Refresh Setup
    func setupPullToRefresh() {
        setupRefreshControl()
        bindRefreshControlState()
        handlePullToRefreshEvent()
    }

    /// Sets up the refresh control for the table view.
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }

    /// Binds the refresh control's state to the view model's refresh state.
    private func bindRefreshControlState() {
        viewModel.output.refreshControl
            .skip(1)
            .skip(while: { $0 })
            .asDriver(onErrorJustReturn: false)
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    /// Handles the pull-to-refresh control event.
    private func handlePullToRefreshEvent() {
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .map { self.refreshControl.isRefreshing }
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.handleRefresh()
            })
            .disposed(by: disposeBag)
    }

    /// Triggered when the pull-to-refresh is active.
    private func handleRefresh() {
        viewModel.output.resetList.onNext(())
        tableView.hideEmptyView()
    }

    // MARK: - Pagination Setup
    func paginationBinding() {
        handleResetList()
        bindPaginationToTableView()
        observeHasMoreToLoad()
    }

    /// Resets pagination and triggers a new request when the list is reset.
    private func handleResetList() {
        viewModel.output.resetList
            .subscribe(onNext: { [weak self] in
                self?.resetPagination()
                self?.request()
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    /// Observes the `willDisplayCell` event and checks if more pages should be loaded.
    private func bindPaginationToTableView() {
        Observable.combineLatest(
            tableView.rx.willDisplayCell.map { $0.indexPath },
            viewModel.output.filteredCharactersList
        )
        .subscribe(onNext: { [weak self] indexPath, models in
            self?.nextPage(from: indexPath.row, count: models.count)
        })
        .disposed(by: disposeBag)
    }

    /// Observes whether more content needs to be loaded and shows/hides the activity indicator.
    private func observeHasMoreToLoad() {
        viewModel.output.hasMoreToLoad
            .subscribe(onNext: { [weak self] hasMoreToLoad in
                self?.hasMore = hasMoreToLoad
                if hasMoreToLoad {
                    self?.tableView.addBottomActivityIndicator()
                } else {
                    self?.tableView.removeBottomActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
    }

    /// Adds a bottom activity indicator when fetching the next page.
    func willCallNextPage() {
        tableView.addBottomActivityIndicator()
    }

    /// Requests the next page of characters.
    func request() {
        viewModel.getCharacters(with: Observable.just(()), page: pageNumber)
        pageOffset = (pageNumber * pageNumber) - 1
    }
}
