//
//  NetworkReachabilityVM.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import RxSwift
import RxCocoa

class BlockViewControllerVM: RepoRequestable {
    var loading: BehaviorSubject<Bool>
    var errorEntity: PublishSubject<StateDialogueEntity>
    var isLoading: Bool

    var message: BehaviorSubject<String>
    var animationFileName: BehaviorSubject<String>
    var title: BehaviorSubject<String>
    let disposeBag = DisposeBag()

    init(title: String, message: String, animationFileName: String) {
        loading = BehaviorSubject(value: true)
        errorEntity = PublishSubject()
        isLoading = true

        self.title = BehaviorSubject(value: title)
        self.animationFileName = BehaviorSubject(value: animationFileName)
        self.message = BehaviorSubject(value: message)
    }
}
