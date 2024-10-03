//
//  BaseViewController.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa

protocol BaseViewControllerProtocol {
    func setupUI()
    func setupBindings()
    func setupTheme()
    func setupLocalizations()
    func logScreenViewEvent()
}

extension BaseViewControllerProtocol {
    func setupBindings() { }
    func setupTheme() { }
    func setupLocalizations() { }
    func logScreenViewEvent() { }
}

class BaseViewController: UIViewController {
    
    
    var topViewController: UIViewController? {
        return UIApplication.getTopViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private var onTimeCall = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func registerCell(id: String, tableView: UITableView) {
        let nib = UINib(nibName: id, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: id)
    }
    
    func registerCollectionCell(id: String, collectionView: UICollectionView) {
        let nib = UINib(nibName: id, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func present(vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    func presentPopUpView(vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: completion)
    }
    
    func dismissPopUpView(completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: completion)
    }
}

extension BaseViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension BaseViewController {

    enum BarStyle: Int {
        case `default` = 0, back = 1,
             backWithTitle = 2, close = 3,
             closeLeft = 4, none = 5
    }

    // MARK: - Navigation

    @objc func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func dismissPresented() {
        self.dismiss(animated: true, completion: nil)
    }

    private func getBackButton() -> UIBarButtonItem{
        let image = Assets.Assets.back.image
        let back = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain,
                                   target: self, action: #selector(navigateBack))
        return back
    }

}
