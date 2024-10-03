//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import Foundation
import RxSwift

class CharacterDetailsViewModel: ViewModelType {
    
    // MARK: Input & Output
    struct Input {
        var characterModel: CharacterModel
    }

    struct Output {
    }

    let input: Input
    private(set) var output: Output
    let bag = DisposeBag()
    
    init(characterModel: CharacterModel) {
        self.input = Input(characterModel: characterModel)
        
        self.output = Output()
    }
}
