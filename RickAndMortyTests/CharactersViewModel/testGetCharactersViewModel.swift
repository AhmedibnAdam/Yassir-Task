//
//  testGetCharactersViewModel.swift
//  RickAndMortyTests
//
//  Created by Ahmad on 06/10/2024.
//

import XCTest
import RxSwift
import RxCocoa

@testable import RickAndMorty

class CharactersListViewModelTests: XCTestCase {

    var viewModel: CharactersListViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = CharactersListViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    func testRequestInitialCharacters() {
        let expectedCharactersCount = 20
        viewModel.charactersList = [
            CharacterModel(id: 1, name: "Ahmed", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: ""),
            CharacterModel(id: 2, name: "Adam", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: "")
        ]
        
        viewModel.requestInitialCharacters()
        
        XCTAssertEqual(viewModel.charactersList.count, expectedCharactersCount, "Expected character count should match.")
        
    }

    func testHandleResponseWithEmptyCharacters() {
        let emptyCharacters: [CharacterModel] = []
        let info = CharactersEntityInfo(count: 1, pages: 1, next: "", prev: "")

        viewModel.handleResponse(emptyCharacters, info)

        viewModel.output.hasMoreToLoad
            .subscribe(onNext: { hasMore in
                XCTAssertFalse(hasMore, "Expected no more characters to load.")
            })
            .disposed(by: disposeBag)
    }

    func testHandleResponseWithCharacters() {
        let characters: [CharacterModel] = [
            CharacterModel(id: 1, name: "Ahmed", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: ""),
            CharacterModel(id: 2, name: "Adam", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: "")
        ]
        
        let info = CharactersEntityInfo(count: 1, pages: 1, next: "", prev: "")

        viewModel.handleResponse(characters, info)

        XCTAssertEqual(viewModel.charactersList.count, characters.count, "Characters list should contain the characters added.")
        viewModel.output.hasMoreToLoad
            .subscribe(onNext: { hasMore in
                XCTAssertTrue(hasMore, "Expected more characters to load.")
            })
            .disposed(by: disposeBag)
    }
    func testHandleError() {

        let error = APIError.internalServerError

        viewModel.handleError(error)
        
        viewModel.output.errorEntity
            .subscribe(onNext: { errorEntity in
                XCTAssertEqual(errorEntity.title, error.errorTitle)
            })
            .disposed(by: disposeBag)
        
    }
}
