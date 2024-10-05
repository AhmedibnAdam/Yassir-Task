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
    
    private var paginationManager: PaginationManager!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupPagination()
        viewModel.requestInitialCharacters()
        handleBinding()
    }
    
    private func handleBinding() {
        bindCharactersList()
        bindLoadingState()
        bindButtonActions()
        bindModelSelection()
    }
    
    private func bindCharactersList() {
        viewModel.output.filteredCharactersList
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                guard let self, let item = item else { return UITableViewCell() }
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
    
    private func bindLoadingState() {
        viewModel.output.isLoading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension CharctersListViewController {
    func configureUI() {
        configureLabel()
        configureButtons()
        configureTableView()
        setupPullToRefresh()
    }
    
    private func configureLabel() {
        titleLabel.applyStyle(font: UIFont.boldSystemFont(ofSize: 32), color: Assets.Colors.primary.color)
        titleLabel.text = Localize.characters
    }
    
    private func configureButtons() {
        [aliveButton, deadButton, unKnownButton].forEach { button in
            button?.applyRoundedStyle(borderColor: Assets.Colors.border.color.cgColor)
        }
    }
}

    // MARK: - Table Binding
extension CharctersListViewController {
    private func configureTableView() {
        registerCell(id: CharcterTableViewCell.getName(), tableView: tableView)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupPullToRefresh() {
        tableView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.requestInitialCharacters()
                self?.refreshControl.endRefreshing()
                
            })
            .disposed(by: disposeBag)
    }
    
    private func handleEmptyView(for count: Int, isLoading: Bool) {
        if !isLoading, count < 1 {
            let emptyView = EmptyListView(
                title: Localize.notFound,
                image: Assets.Assets.tempImage.image,
                itemCount: count
            )
            tableView.rx.emptyView.onNext(emptyView)
        }
    }
    
    private func bindModelSelection() {
        tableView.rx.modelSelected(CharacterModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.navigateToCharacterDetails(with: model)
            })
            .disposed(by: disposeBag)
    }
    
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
}

// MARK: - ViewModel Binding
extension CharctersListViewController {
    private func handlePaginationState(hasMore: Bool) {
        hasMore ? tableView.addBottomActivityIndicator() : tableView.removeBottomActivityIndicator()
    }
}

// MARK: -  Button Action Bindings
extension CharctersListViewController {
    private func bindButtonActions() {
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
            button?.isSelected = button == selectedButton ? !button!.isSelected : false
            button?.isSelected == true ? button?.setSelectedStyle() : button?.setDeselectedStyle()
        }
    }

    private func updateFilterStatus(for button: UIButton, with status: CharacterStatus?) {
        if button.isSelected {
            viewModel.input.filterStatus.onNext(status)
        } else {
            viewModel.input.filterStatus.onNext(nil as CharacterStatus?)

        }
    }
}

// MARK: - Pagination Setup
extension CharctersListViewController: PaginationManagerDelegate {
    func setupPagination() {
        paginationManager = PaginationManager()

        paginationManager.delegate = self
        paginationManager.onLoadNextPage = { [weak self] in
            self?.requestNextPage()
        }
        
        Observable.combineLatest(
                  tableView.rx.willDisplayCell.map { $0.indexPath },
                  viewModel.output.filteredCharactersList
              )
              .subscribe(onNext: { [weak self] indexPath, models in
                  self?.paginationManager.handleContentOffset(from: indexPath.row, count: models.count)
              })
              .disposed(by: disposeBag)
     
    }
    
    func requestNextPage() {
        viewModel.getCharacters(with: Observable.just(()), page: paginationManager.currentPage)
    }
    
    func updateLoadingState(isLoading: Bool) {
        paginationManager.updateLoadingState(isLoading: isLoading)
    }
    
    func updateHasMorePages(hasMore: Bool) {
        paginationManager.updateHasMorePages(hasMore: hasMore)
    }
}
