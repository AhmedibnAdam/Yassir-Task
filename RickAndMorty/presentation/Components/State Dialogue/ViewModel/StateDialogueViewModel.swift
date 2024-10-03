//
//  StateDialogueViewModel.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import RxSwift
import RxRelay

class StateDialogueViewModel: ViewModelType {

    var model: BehaviorSubject<StateDialogueEntity> = BehaviorSubject(value: StateDialogueEntity())
    var buttonTapped: PublishSubject<Void> = PublishSubject()

    var bag: DisposeBag = DisposeBag()

    // MARK: Input & Output
    struct Input {
        var dialogueModel: BehaviorSubject<StateDialogueEntity>
    }

    struct Output {
        var buttonTapped: PublishSubject<Void>
    }

    let input: Input
    let output: Output

    // MARK: Initiation

    init(dialogueModel: StateDialogueEntity) {
        input = Input(
            dialogueModel: model
        )
        output = Output(
            buttonTapped: buttonTapped
        )

        model.onNext(dialogueModel)
    }
}
