//
//  AnimationHelper.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import Lottie
import RxSwift
import UIKit

extension UIViewController {

    private struct AssociatedKeys {
        static var activityIndicator = "ActivityIndicatorAssociatedKey"
        static var activityIndicatorIsPresented = "activityIndicatorIsPresented"
        static var containerView = "containerView"
        static var emptySuperView = "emptySuperView"
    }

    var width: CGFloat { return UIScreen.main.bounds.width }
    var height: CGFloat { return UIScreen.main.bounds.height }

    var containerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.containerView) as? UIView
        }set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.containerView,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var emptySuperView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptySuperView) as? UIView
        }set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.emptySuperView,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var loadingIndicator: LottieAnimationView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? LottieAnimationView
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.activityIndicator,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isActivityIndicatorPresented: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicatorIsPresented) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.activityIndicatorIsPresented,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showActivityIndicator(in view: UIView, backgroundColor: UIColor = .gray.withAlphaComponent(0.5)) {

        let width =  UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        if loadingIndicator == nil {
            loadingIndicator = LottieAnimationView(name: Environment.loaderAnimationName)
        }
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        containerView?.backgroundColor = backgroundColor
        containerView?.isUserInteractionEnabled = true
        loadingIndicator?.backgroundBehavior = .pauseAndRestore
        loadingIndicator!.loopMode = .loop
        loadingIndicator!.frame = CGRect(x: width/2 - 75, y: height/2 - 65, width: 150, height: 130)
        loadingIndicator?.play()
        isActivityIndicatorPresented = true
        containerView?.addSubview(loadingIndicator!)
        loadingIndicator?.tag = 678000 // please do not change this.
        containerView?.tag = 678000 // please do not change this.
        view.addSubview(containerView!)

    }

    func showActivityIndicator(_ isBlocking: Bool = false) {
        DispatchQueue.main.async {
            self.showActivityIndicator(in: UIApplication.shared.windows.filter { $0.isKeyWindow }.first!)
        }
    }

    func hideActivityIndicator() {
        isActivityIndicatorPresented = false
        DispatchQueue.main.async {
            self.loadingIndicator?.stop()
            self.loadingIndicator?.removeFromSuperview()
            self.containerView?.removeFromSuperview()

        }

    }

    /// Check if activity indicator is not presented in the same view,
    /// used to block any action if there is Activity indicator presented.
    var isActivityIndicatorNotPresented: Bool {

        guard loadingIndicator != nil  else {
            return true
        }
        return loadingIndicator?.superview == nil
    }

    public func showBindedError(model: StateDialogueEntity) {
        guard model.description != nil else { return }

        let vc = StateDialogueViewController(nibName: StateDialogueViewController.getName(), bundle: nil)
        let vm = StateDialogueViewModel(dialogueModel: model)

        vc.viewModel = vm
        vm.buttonTapped
            .subscribe(
                onNext: { _ in
                    vc.dismiss(animated: true, completion: nil)
                })

        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    func presentEmptyView () {
        let width =  UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        emptySuperView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        emptySuperView?.backgroundColor = Assets.Colors.primary.color
        emptySuperView?.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.view.addSubview(self.emptySuperView!)
        }
    }

    func removeEmptyView () {
        DispatchQueue.main.async {
            self.emptySuperView?.removeFromSuperview()
        }
    }
}
extension CGRect {
    var center: CGPoint { .init(x: midX, y: midY) }
}
