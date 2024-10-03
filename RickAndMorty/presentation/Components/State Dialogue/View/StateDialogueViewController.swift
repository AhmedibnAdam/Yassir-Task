//
//  StateDialogueViewController.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import UIKit
import RxSwift
import RxCocoa

class StateDialogueViewController: BaseViewController, BaseViewControllerProtocol {

    // MARK: - Variables
    var viewModel = StateDialogueViewModel(dialogueModel: StateDialogueEntity())
    let disposeBag = DisposeBag()
    let successDialogueDismissTime = 2

    // MARK: - Outlets
    @IBOutlet weak var dialogueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dialogueButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!

    // MARK: - override Func
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        setupTheme()
        setupLocalizations()
        logScreenViewEvent()
    }
    
    func logScreenViewEvent() {}

    // MARK: - Setup

    func setupUI() {
    }

    func setupBindings() {
        viewModel.input.dialogueModel
            .map { $0.type?.icon }
            .asDriver(onErrorJustReturn: UIImage())
            .drive(dialogueImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.input.dialogueModel
            .map { $0.type?.color }
            .asDriver(onErrorJustReturn: .black)
            .drive(titleLabel.rx.textColor)
            .disposed(by: disposeBag)

        viewModel.input.dialogueModel
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.dialogueModel
            .map { $0.description }
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.input.dialogueModel
            .map { ($0.type ?? .success) == .success || ($0.type ?? .success) == .customError}
            .asDriver(onErrorJustReturn: false)
            .drive(buttonContainerView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.input.dialogueModel
            .map { $0.type ?? .success}
            .delay(.seconds(successDialogueDismissTime), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] type in
                    guard let self = self, (type == .success || type == .customError) else { return }
                    self.dismiss(animated: true, completion: nil)
                })
            .disposed(by: disposeBag)

        dialogueButton.rx
            .tap
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
    }

    func setupTheme() {
    }

    func setupLocalizations() {
    }
}
