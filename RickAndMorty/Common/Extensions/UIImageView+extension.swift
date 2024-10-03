//
//  UIImageView+extension.swift
//  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {

    private struct AssosiatedKeys {
        static var activitIndicatorViewKey = "ActivitIndicatorViewKey"
    }

    public var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssosiatedKeys.activitIndicatorViewKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssosiatedKeys.activitIndicatorViewKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(pth: String!,
                  placeholder: UIImage! = Assets.Assets.tempImage.image,
                  cacheKey: String! = nil,
                  completion: ((UIImage) -> Void)? = nil, animated: Bool = false) {
        guard let path = pth, let url = URL(string: path) else {
            self.image = placeholder
            return
        }

        addActivityIndicator()

        let resource = KF.ImageResource(downloadURL: url, cacheKey: cacheKey)
        kf.setImage(with: resource,
                    placeholder: placeholder,
                    options: KingfisherOptionsInfo.init(repeating: KingfisherOptionsInfoItem.cacheOriginalImage,
                  count: 4),
                    progressBlock: nil) { [weak self] _ in
            guard let self = self else {return}
             self.removeActivityIndicator()
            if animated {
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    completion?(self.image ?? Assets.Assets.tempImage.image)}, completion: nil)
            } else {
                completion?(self.image ?? Assets.Assets.tempImage.image)
            }
        }
    }

    func clearImageFromCache(key: String) {
        KingfisherManager.shared.cache.removeImage(forKey: key)
    }

    func addActivityIndicator() {

        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(activityIndicator!)
        NSLayoutConstraint.activate([
            activityIndicator!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        activityIndicator!.startAnimating()
    }

    func removeActivityIndicator() {

        guard activityIndicator != nil else { return }
        activityIndicator!.stopAnimating()
        activityIndicator!.removeFromSuperview()
    }
}
