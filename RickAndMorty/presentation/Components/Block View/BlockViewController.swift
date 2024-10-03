//
//  NetworkReachabilityViewController.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import UIKit
import RxSwift
import RxCocoa
import Lottie

class BlockViewController: BaseViewController, NibInitializable {

    static var nibIdentifier: String = "BlockViewController"
    var viewModel: BlockViewControllerVM!

    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    func setupBindings() {
        viewModel.message
            .asDriver(onErrorJustReturn: "")
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.title
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.animationFileName
            .subscribe(onNext: { [weak self] animationFileName in
                guard let self = self else { return }
                let animationView = LottieAnimationView(name: animationFileName)
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .loop
                animationView.animationSpeed = 1
                animationView.frame = self.lottieView.frame

                self.lottieView.addSubview(animationView)
                animationView.play()

            })
            .disposed(by: disposeBag)
    }
}
