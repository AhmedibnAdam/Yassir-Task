//
//  NetworkReachabilityController.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//


import Foundation
import UIKit
import Alamofire

class NetworkReachability {
    
    static let shared = NetworkReachability()

    private init() {}
    var alertWindow: UIWindow!

    func showNotification(title: String, message: String, animationFileName: String) {
        let vm = BlockViewControllerVM(title: title, message: message, animationFileName: animationFileName)
        let reachabilityVc = BlockViewController.initFromXib()
        reachabilityVc.viewModel = vm

        if let currentWindowScene = UIApplication.shared.connectedScenes.first as?  UIWindowScene {
            alertWindow = UIWindow(windowScene: currentWindowScene)
            }
        alertWindow.windowLevel = UIWindow.Level.alert
        alertWindow.rootViewController = reachabilityVc
        alertWindow.makeKeyAndVisible()
    }

    func hideNotificationMessage() {
        if let alertWindow = alertWindow {
            alertWindow.resignKey()
            alertWindow.isHidden = true
            alertWindow.windowScene = nil
        }
    }

    func completed() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }

    @objc func removeFromSuperViewSelector() {
        self.hideNotificationMessage()
    }
}

protocol NetworkReachabilityType {
    var reachability: NetworkReachabilityManager? { get }
    func listineOnInternet(_ listine: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void)
    func clearPreviousRequest()
    func checkPendingRequests(completion: ((Bool) -> Void)?)
}

extension NetworkReachabilityType {
    var reachability: NetworkReachabilityManager? {
        return NetworkReachabilityManager(host: "www.apple.com")
    }

    func listineOnInternet(_ listine: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        reachability?.startListening { status in
            listine(status)
        }
    }

    func clearPreviousRequest() {
        AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach({$0.cancel()})
            uploadTasks.forEach({$0.cancel()})
            downloadTasks.forEach({$0.cancel()})
        }
    }

    func checkPendingRequests(completion: ((Bool) -> Void)?) {
        AF.session.getAllTasks { tasks in
            completion?(tasks.isEmpty == false)
        }
    }
}
