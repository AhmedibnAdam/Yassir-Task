//
//  CharacterTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import Foundation
import RxSwift

class CharacterTableViewCellViewModel: ViewModelType{
    struct Input {
    }

    struct Output {
        var model: BehaviorSubject<CharacterModel>
    }

    var bag: DisposeBag = DisposeBag()
    var model: CharacterModel?
    let input: Input
    let output: Output

    init(model: CharacterModel) {
        self.model = model

        input = Input(
        )
        output = Output(
            model: BehaviorSubject(value: model)
        )
    }
}
