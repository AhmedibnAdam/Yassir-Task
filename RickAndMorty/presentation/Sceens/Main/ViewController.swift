//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let characterView = CharctersListViewController()
            characterView.modalPresentationStyle = .fullScreen
            self.present(characterView, animated: true)
        }
    }

}

