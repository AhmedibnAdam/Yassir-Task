//
//  ViewModelType.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import RxSwift

protocol ViewModelType {

    var bag: DisposeBag { get }

    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}
