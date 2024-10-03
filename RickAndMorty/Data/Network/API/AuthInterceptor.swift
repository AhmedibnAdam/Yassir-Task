//
//  OAuth2Interceptor.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import Alamofire
import RxSwift


class AuthInterceptor: RequestInterceptor {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ auth: AuthDataEntity?) -> Void
    
    private let lock = NSLock()
    private var baseURLString: URL
    private var accessToken: String?
    private var refreshToken: String?
    private var idToken: String?
    
    private var isRefreshing = false
    private var isRequesting = false
    
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    public let manager = NetworkReachabilityManager(host: "www.apple.com")
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    public init(baseURLString: URL, accessToken: String!, refreshToken: String!, idToken: String) {
        self.baseURLString = baseURLString
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.idToken = idToken
        
        manager?.startListening(onUpdatePerforming: { [weak self] (status: NetworkReachabilityManager
            .NetworkReachabilityStatus) in
            
            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable: break
            case .reachable:
                self?.requestsToRetry.forEach { $0(RetryResult.retry) }
                self?.requestsToRetry.removeAll()
            case .unknown: break
            }
            
        })
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (CharacterModel) -> Void) {}
    
    // MARK: - RequestRetrier
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == APIErrorCode.unauthorized.rawValue {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, auth in
                    
                    guard succeeded else { return }
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let auth = auth, let accessToken = auth.userData, let refreshToken = auth.userData {
                        
                        strongSelf.accessToken = accessToken
                        strongSelf.refreshToken = refreshToken
                        
                        NotificationCenter.default.post(name: .didUpdateTokens, object: nil, userInfo: ["auth": auth])
                        
                        strongSelf.requestsToRetry.forEach { $0(RetryResult.retry) }
                        strongSelf.requestsToRetry.removeAll()
                        
                    } else {
                        // Refresh API is succeeded but all tokens are expired.
                        NotificationCenter.default.post(name: .expiredRefreshToken, object: nil)
                    }
                }
            }
        } else {
            completion(RetryResult.doNotRetry)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        
        guard let refreshToken = refreshToken else {
            NotificationCenter.default.post(name: .invalidAccessToken, object: nil)
            return
        }
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        //        MicrosoftAuthRepo().refreshTokenSilently { authResult, error in
        //            if  error != nil {
        //                completion(false, nil)
        //            }
        //            guard let authResult = authResult else {
        //                print("Couldn't get refresh graph token")
        //                completion(false, nil)
        //                return
        //            }
        //            self.isRefreshing = false
        //            completion(true, authResult)
        //        }
    }
}

extension NSNotification.Name {
    public static let expiredRefreshToken = NSNotification.Name("")
    public static let invalidAccessToken = NSNotification.Name("")
    public static let didUpdateTokens = NSNotification.Name("")
}
