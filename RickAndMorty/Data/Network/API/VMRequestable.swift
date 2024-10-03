//
//  RepoRequestable.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

typealias VMResult<T> = Observable<Event<T>>
typealias VMResultData = Observable<Event<Data>>

class NetworkManager {
    let session: Session

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        let alamoFireManager = Session(configuration: configuration)

        self.session = alamoFireManager
    }
    static let shared: NetworkManager = NetworkManager()
}

protocol RepoRequestable: Requestable {
    var loading: BehaviorSubject<Bool> {get}
    var errorEntity: PublishSubject<StateDialogueEntity> {get}

    var isLoading: Bool {get set}
    func request<T: Decodable>(endpoint: URLRequestConvertible) -> Observable<(T, [HTTPCookie]?)>
    func request<T: Decodable>(endpoint: URLRequestConvertible) -> VMResult<T>
    func requestJSON(endpoint: URLRequestConvertible) -> VMResultData
    func requestEmpty(endpoint: URLRequestConvertible) -> Observable<Void>
    func requestMultipart<T: Decodable>(endpoint: URLRequestConvertible & URLRequestMultipartable) -> VMResult<T>
}

extension RepoRequestable {

    func requestStarted() {
        loading.onNext(true)
    }
    func requestEnded() {
        loading.onNext(false)
    }

    func request<T: Decodable>(endpoint: URLRequestConvertible) -> Observable<(T, [HTTPCookie]?)> {

        requestStarted()
//        IQKeyboardManager.shared.resignFirstResponder()

        return Observable<(T, [HTTPCookie]?)>.create { observer in
            let request = NetworkManager.shared.session.request(endpoint, interceptor: APIManager.interceptor)

            request.validate(statusCode: 200...300)
                .responseDecodable { [weak self](response: DataResponse<T, AFError>) in

                print("\n\n\n")
                print(request.cURLDescription())
                print("\n\n\n")
                print(response.debugDescription)

                self?.requestEnded()
                switch response.result {
                case .success(let v):
                    var cookies: [HTTPCookie]?

                    if let headerFields = response.response?.allHeaderFields as? [String: String],
                       let url = response.request?.url {
                        cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    }

                    observer.onNext((v, cookies))
                    observer.onCompleted()
                case .failure(let error):
                    if error.isResponseValidationError {
                        switch error.responseCode {
                        default:
                            observer.onError(APIError.other(error, data: response.data))
                        }
                    } else if error.isParameterEncodingError {
                        observer.onError(APIError.badResponse)
                    } else if error.isSessionTaskError {
                        observer.onError(APIError.failedToCommunicateWithServer)
                    } else {
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create {
                request.cancel()
            }

        }
    }
    
    func requestJSONData(endpoint: URLRequestConvertible) -> Observable<Data> {
        requestStarted()
        return Observable<Data>.create { observer in
            let request = NetworkManager.shared.session.request(endpoint, interceptor: APIManager.interceptor)
    
            request.validate(statusCode: 200...300)
                .responseData { response in
                
                    print("\n\n\n")
                    print(request.cURLDescription())
                    print("\n\n\n")
                    print(response.debugDescription)

                    self.requestEnded()
                
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        if error.isResponseValidationError {
                            switch error.responseCode {
                            default:
                                observer.onError(APIError.other(error, data: response.data, errorCode: request.error?.responseCode ?? 0))
                            }
                        } else if error.isParameterEncodingError {
                            observer.onError(APIError.badResponse)
                        } else if error.isSessionTaskError {
                            observer.onError(APIError.failedToCommunicateWithServer)
                        } else {
                            observer.onError(error)
                        }
                    }
                }
        
            return Disposables.create {
                request.cancel()
            }
        }
    }


    func request<T: Decodable>(endpoint: URLRequestConvertible) -> Observable<T> {

        requestStarted()
//        IQKeyboardManager.shared.resignFirstResponder()

        return Observable<T>.create { observer in
            let request = NetworkManager.shared.session.request(endpoint, interceptor: APIManager.interceptor)

            request.validate(statusCode: 200...300)
                .responseDecodable { [weak self](response: DataResponse<T, AFError>) in

                print("\n\n\n")
                print(request.cURLDescription())
                print("\n\n\n")
                print(response.debugDescription)

                self?.requestEnded()
                switch response.result {
                case .success(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                case .failure(let error):
                    if error.isResponseValidationError {
                        switch error.responseCode {
                        default:
                            observer.onError(APIError.other(error, data: response.data, errorCode: request.error?.responseCode ?? 0))
                        }
                    } else if error.isParameterEncodingError {
                        observer.onError(APIError.badResponse)
                    } else if error.isSessionTaskError {
                        observer.onError(APIError.failedToCommunicateWithServer)
                    } else {
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func requestEmpty(endpoint: URLRequestConvertible) -> Observable<Void> {

        requestStarted()
//        IQKeyboardManager.shared.resignFirstResponder()

        return Observable<Void>.create { observer in
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 300
            let alamoFireManager = Session(configuration: configuration)

            let request = alamoFireManager.request(endpoint, interceptor: APIManager.interceptor)
            print(endpoint)
            request.validate(statusCode: 200...300).response { [weak self] (response) in

                print("\n\n\n")
                print(request.cURLDescription())
                print("\n\n\n")
                print(response.debugDescription)

                self?.requestEnded()
                switch response.result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    if error.isResponseValidationError {
                        switch error.responseCode {
                        default:
                            observer.onError(APIError.other(error, data: response.data))
                        }
                    } else if error.isParameterEncodingError {
                        observer.onError(APIError.badResponse)
                    } else if error.isSessionTaskError {
                        observer.onError(APIError.failedToCommunicateWithServer)
                    } else {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func requestMutlipart<T: Decodable>(endpoint: (URLRequestMultipartable & URLRequestConvertible)) -> Observable<T> {

        requestStarted()

//        IQKeyboardManager.shared.resignFirstResponder()

        return Observable<T>.create { observer in

            let request = NetworkManager.shared.session.upload(multipartFormData: { (multipart) in

                if let params = endpoint.parameters {
                    for (key, value) in params {
                        multipart.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                    }
                }

                if let data = endpoint.image?.data, let name = endpoint.image?.name {
                    multipart.append(data, withName: name, fileName: endpoint.image?.extention)
                }

            }, with: endpoint, interceptor: APIManager.interceptor)

            print(request.cURLDescription())

            request.validate(statusCode: 200...300)
                .responseDecodable { [weak self] (response: DataResponse<T, AFError>) in

                print("\n\n\n")
                print(request.cURLDescription())
                print("\n\n\n")
                print(response.debugDescription)

                self?.requestEnded()

                switch response.result {
                case .success(let obj):
                    observer.onNext(obj)
                    observer.onCompleted()
                case .failure(let error):
                    if error.isResponseValidationError {
                        switch error.responseCode {
                        default:
                            observer.onError(APIError.other(error, data: response.data))
                        }
                    } else if error.isParameterEncodingError {
                        observer.onError(APIError.badResponse)
                    } else if error.isSessionTaskError {
                        observer.onError(APIError.failedToCommunicateWithServer)
                    } else {
                        observer.onError(error)
                    }
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func requestMultipart<T: Decodable>(endpoint: URLRequestConvertible & URLRequestMultipartable) -> VMResult<T> {
        return requestMutlipart(endpoint: endpoint)
            .materialize()
    }

    func request<T: Decodable>(endpoint: URLRequestConvertible) -> VMResult<(T, [HTTPCookie]?)> {
        return request(endpoint: endpoint)
            .materialize()
    }

    func request<T: Decodable>(endpoint: URLRequestConvertible) -> VMResult<T> {
        return request(endpoint: endpoint)
               .materialize()
    }
    
    func requestJSON(endpoint: URLRequestConvertible) -> VMResultData {
        return requestJSONData(endpoint: endpoint)
               .materialize()
    }

    func requestEmpty(endpoint: URLRequestConvertible) -> VMResult<Void> {
        return requestEmpty(endpoint: endpoint)
            .materialize()
    }
}

extension Reactive where Base: UIViewController {

    public var isAnimating: Binder<Bool> {
        return Binder.init(self.base, binding: { (vc, active) in
            if active {
                vc.showActivityIndicator()
            } else {
                vc.hideActivityIndicator()
            }
        })
    }

    public var message: Binder<StateDialogueEntity> {
        return Binder.init(self.base, binding: { (vc, model) in
            vc.showBindedError(model: model)
        })
    }

    public var isShowEmptyView: Binder<Bool> {
        return Binder.init(self.base, binding: { (vc, isPresent) in
            if isPresent {
                vc.presentEmptyView()
            } else {
                vc.removeEmptyView()
            }
        })
    }
}
