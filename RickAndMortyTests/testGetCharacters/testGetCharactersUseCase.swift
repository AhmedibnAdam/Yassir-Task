//
//  testGetCharactersUseCase.swift
//  RickAndMortyTests
//
//  Created by Ahmad on 06/10/2024.
//

import XCTest
import RxSwift
import RxTest

@testable import RickAndMorty

class GetCharactersListUseCaseTests: XCTestCase {

    var useCase: GetCharactersListUseCase!
    var mockRepo: MockCharactersRepo!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockCharactersRepo()  // Mock repository to inject
        useCase = GetCharactersListUseCase(repo: mockRepo)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        useCase = nil
        mockRepo = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // Test if use case calls the repo with correct parameters
    func testExecuteCallsRepoWithCorrectParameters() {
        
        let requestEntity = CharactersListRequestEntity(page: 1, pageSize: 20)
        let expectedCharacters: [CharacterModel] = [
            CharacterModel(id: 1, name: "Ahmed", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: ""),
            CharacterModel(id: 2, name: "Adam", status: .alive, species: "", type: "", gender: .male, origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: "")
        ]
        mockRepo.expectedCharactersList = expectedCharacters  // Simulating repo response
        let expectation = XCTestExpectation(description: "Wait for characters list to be fetched")

        let result: VMResult<[CharacterModel]>? = useCase.execute(requestEntity)
        var actualResponse = [CharacterModel]()
        result?.subscribe(onNext: { response in
            switch response {
            case   .next(let ch):
                actualResponse.removeAll()
                actualResponse = ch
            case .error(_):
                actualResponse.removeAll()
            case .completed:
                expectation.fulfill()
            }

            
        })
        .disposed(by: disposeBag)

        XCTAssertEqual(actualResponse, expectedCharacters)

        XCTAssertEqual(self.mockRepo.invokedPage, 1)
        XCTAssertEqual(self.mockRepo.invokedPageSize, 20)
        
    }
    
}


