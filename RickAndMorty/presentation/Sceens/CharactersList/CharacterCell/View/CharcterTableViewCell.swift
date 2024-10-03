//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import UIKit
import RxSwift

class CharcterTableViewCell: UITableViewCell {
    
    private var indexPath: IndexPath? // Store indexPath
    var viewModel: CharacterTableViewCellViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = Assets.Colors.border.color.cgColor
        
    }
    
    func setupBinding() {
        viewModel.output.model
            .map { "\($0.name ?? "" )" }
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.model
            .map { ($0.status) }
            .subscribe(
                onNext: { [weak self] status in
                    guard let self = self else { return }
                    switch status {
                    case .alive:
                        self.containerView.backgroundColor = Assets.Colors.aliveColor.color
                    case .dead:
                        self.containerView.backgroundColor = Assets.Colors.deadColor.color
                    case .unknown:
                        self.containerView.backgroundColor = Assets.Colors.unknown.color
                    case .none:
                        break
                    }
                })
            .disposed(by: disposeBag)

        viewModel.output.model
            .map {$0.species ?? ""}
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.model
            .map { ($0.image ?? Assets.Assets.tempImage.name) }
            .subscribe(
                onNext: { [weak self] imageURL in
                    guard let self = self else { return }
                    self.characterImage.setImage(pth: imageURL,
                                                 placeholder: Assets.Assets.tempImage.image,
                                                cacheKey: imageURL)
                })
            .disposed(by: disposeBag)

    }
    
    static func populateCell(tableView: UITableView,
                             indexPath: IndexPath,
                             viewModel: CharacterTableViewCellViewModel) -> CharcterTableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: CharcterTableViewCell.getName(),
                                                 for: indexPath) as! CharcterTableViewCell
        cell.configure(viewModel: viewModel, row: indexPath.row)

        return cell
    }
    
    func configure(viewModel: CharacterTableViewCellViewModel, row: Int) {
        self.viewModel = viewModel
        setupBinding()
    }
}
