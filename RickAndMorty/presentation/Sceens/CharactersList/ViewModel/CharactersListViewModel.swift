//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import Foundation
import RxSwift

// MARK: - CharactersListViewModel
class CharactersListViewModel: ViewModelType {
    
    // MARK: Input & Output
    struct Input {
        let pageSize: BehaviorSubject<Int>
        var pageOffset: Int = 0
        var selectedItem: PublishSubject<CharacterModel> = PublishSubject()
        var filterStatus: BehaviorSubject<CharacterStatus?> = BehaviorSubject(value: nil)

        
    }

    struct Output {
        var isLoading: BehaviorSubject<Bool>
        let errorEntity: PublishSubject<StateDialogueEntity>
        var refreshControl: BehaviorSubject<Bool>
        var hasMoreToLoad: BehaviorSubject<Bool>
        var hasNoData: BehaviorSubject<Bool>
        var charactersList: BehaviorSubject<[CharacterModel?]>
        var filteredCharactersList: BehaviorSubject<[CharacterModel?]>
        var resetList: PublishSubject<Void>

    }

    let input: Input
    private(set) var output: Output
    let bag = DisposeBag()
    private let getCharactersListUseCase: GetCharactersListUseCase
    private (set) var charactersList: [CharacterModel] = []

    // MARK: - Initialization
    init() {
        self.input = Input(pageSize: BehaviorSubject(value: 20))
        
        self.output = Output(
            isLoading: BehaviorSubject(value: false),
            errorEntity: PublishSubject<StateDialogueEntity>(),
            refreshControl: BehaviorSubject(value: false),
            hasMoreToLoad: BehaviorSubject<Bool>(value: false),
            hasNoData: BehaviorSubject<Bool>(value: false),
            charactersList: BehaviorSubject<[CharacterModel?]>(value: []),
            filteredCharactersList: BehaviorSubject<[CharacterModel?]>(value: []),
            resetList: PublishSubject<Void>()

        )
        self.getCharactersListUseCase = GetCharactersListUseCase()
        filterCharacters()
    }
}

extension CharactersListViewModel {
    
    func getCharacters(with submit: Observable<Void>, page: Int){
        self.output.isLoading.onNext(true)
        
        submit
            .withLatestFrom(input.pageSize)
            .flatMap { [weak self] pageSize -> VMResult<CharactersEntity> in
            guard let self = self else { return .empty() }
                return self.getCharactersListUseCase.start(CharactersListRequestEntity(page: page, pageSize: pageSize))!
        }.subscribe(
            onNext: { [weak self] result in
                guard let self else { return }
                self.output.isLoading.onNext(false)
                switch result {
                case .next(let value):
                    guard let characters = value.results,
                          let info = value.info else {
                        return
                    }
                    handleResponse(characters, info)
                case .error(let error):
                    handleError(error)
                case .completed:
                    break
                }
            }
        ).disposed(by: bag)
    }
    
    private func handleResponse(_ characters: [CharacterModel], _ info: CharactersEntityInfo) {
        var hasMoreToLoad = !characters.isEmpty
        if hasMoreToLoad && characters.count < self.input.pageOffset {
            hasMoreToLoad = false
        }
        if hasMoreToLoad && characters.count <  input.pageOffset {
            hasMoreToLoad = false
        }
        self.output.hasMoreToLoad.onNext(hasMoreToLoad)
        
        charactersList.append(contentsOf: characters)
        setCharacterStatus()
    }
    
    private func handleError(_ error: Error) {
           output.errorEntity.onNext(StateDialogueEntity(
               title: Localize.error,
               description: (error as? APIError)?.localizedDescription ?? error.localizedDescription,
               buttonTitle: Localize.ok,
               type: .error
           ))
       }
    
}

extension CharactersListViewModel {
    func filterCharacters(){
        input.filterStatus
            .subscribe(onNext: { [weak self] status in
                guard let status = status else {
                    self?.resetFilter()
                    return
                }
                if let characters = self?.charactersList.filter({$0.status == status}) {
                    self?.output.filteredCharactersList.onNext(characters)
                }
            })
            .disposed(by: bag)
  
    }
    
    fileprivate func setCharacterStatus() {
        let lastValue = try? input.filterStatus.value()
        input.filterStatus.onNext(lastValue)
    }
    
    
    func resetFilter() {
        charactersList = Array(Set(charactersList))
        output.filteredCharactersList.onNext(charactersList)
    }
}
