//
//  API.swift
//  RickAndMorty
//
//  Created by Ahmad on 30/09/2024.
//

import Foundation
import Alamofire
import IQKeyboardManagerSwift
import Kingfisher
import UIKit

typealias Response = DataResponse
typealias StringResponse = AFDataResponse<String>
typealias NetError = AFError
typealias ImageFormData = (name: String?, data: Data?, extention: String)

protocol URLRequestMultipartable {
    var image: ImageFormData? { get }
    var parameters: Parameters? { get }
}

protocol Requestable: AnyObject {

    func request <T: Decodable> (endpoint: URLRequestConvertible,
                                 onComplete: @escaping (_ response: Response<T, NetError>) -> Void)

    func requestString(endpoint: URLRequestConvertible,
                       onComplete: @escaping (_ response: Response <String, NetError>) -> Void)
    func upload <T: Decodable> (endpoint: (URLRequestMultipartable & URLRequestConvertible),
                                onComplete: @escaping (_ response: Response<T, NetError>) -> Void)
    func requestStarted()
    func requestEnded()
}

extension Requestable {
    func request <T: Decodable> (endpoint: URLRequestConvertible,
                                 onComplete: @escaping (_ response: Response<T, NetError>) -> Void) {

        print("---------> \n\n\nStart Request \(String(describing: endpoint))\n\n\n<--------")

        let request = AF.request(endpoint, interceptor: APIManager.interceptor)
        print(request.cURLDescription())
        requestStarted()

        request.validate(statusCode: 200...300).responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
            print(response.debugDescription)
            self?.requestEnded()
            onComplete(response)
        }

        DispatchQueue.main.async {
            // Remove text field focus to hide the keyboard
            IQKeyboardManager.shared.resignFirstResponder()
        }
    }

    func requestString(endpoint: URLRequestConvertible,
                       onComplete: @escaping (_ response: StringResponse) -> Void) {

        print("--------->\n\n\nStart Request (\(String(describing: endpoint))\n\n\n<--------")
        let request =  AF.request(endpoint, interceptor: APIManager.interceptor)
        print(request.cURLDescription())

        requestStarted()

        request.validate(statusCode: 200...300).responseString { [weak self] (response: AFDataResponse<String>) in
            print(response.debugDescription)
            onComplete(response)
            self?.requestEnded()
        }

        DispatchQueue.main.async {
            // Remove text field focus to hide the keyboard
            IQKeyboardManager.shared.resignFirstResponder()
        }
    }

    func upload <T: Decodable> (endpoint: (URLRequestMultipartable & URLRequestConvertible),
                                onComplete: @escaping (_ response: Response <T, NetError>) -> Void) {

        requestStarted()
        let req = AF.upload(multipartFormData: { (multipart) in

            if let params = endpoint.parameters {
                for (key, value) in params {
                    multipart.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
                }
            }

            if let data = endpoint.image?.data, let name = endpoint.image?.name {
                multipart.append(data, withName: name, fileName: endpoint.image?.extention)
            }

        }, with: endpoint, interceptor: APIManager.interceptor)

        print(req.cURLDescription())

        req.validate(statusCode: 200...300).responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
            print(response.debugDescription)
            onComplete(response)
            self?.requestEnded()
        }
    }

    func requestStarted() {
        print("---------------------------------------------------------------------------------------")
    }
    func requestEnded() {
        print("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
    }

}

struct APIManager {

    static var interceptor: AuthInterceptor?

    static func configure(baseURL: URL, accessToken: String!, refreshToken: String!, idToken: String) {

        APIManager.interceptor = AuthInterceptor(baseURLString: baseURL,
        accessToken: accessToken,
        refreshToken: refreshToken, idToken: idToken)
    }
}

struct ErrorResponse: Codable {
    let errorMessage: String?
    enum CodingKeys: String, CodingKey {
        case errorMessage = "Message"
    }
}

