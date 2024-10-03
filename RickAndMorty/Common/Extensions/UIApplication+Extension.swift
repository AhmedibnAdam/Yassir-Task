//
//  UIApplication.swift
//  RickAndMorty
//
//  Created by Ahmad on 01/10/2024.
//

import UIKit

extension UIApplication {

    static var loginAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var logoutAnimation: UIView.AnimationOptions = .transitionCrossDissolve

    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionFlipFromRight,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.2,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = viewController
            return
        }

        UIView.transition(with: UIApplication.shared.windows.filter { $0.isKeyWindow }.first!,
                          duration: duration,
                          options: options,
                          animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        })
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIWindow {
    var topViewController: UIViewController? {
        guard var top = rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }

    func removeLoading() {
        for subview in self.subviews where subview.tag == 678000 {
            subview.removeFromSuperview()// here you are removing the view.
            subview.isHidden = true// you can hide the view using this
        }
    }
}
