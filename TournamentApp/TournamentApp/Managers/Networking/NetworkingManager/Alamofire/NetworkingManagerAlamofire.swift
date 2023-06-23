//
//  NetworkingManagerAlamofire.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation
import Alamofire

// MARK: - NetworkingManagerAlamofire

final class NetworkingManagerAlamofire {
    
    // MARK: - Properties
    
    private struct ArrayEncoding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try URLEncoding().encode(urlRequest, with: parameters)
            if let url = request.url {
                request.url = URL(string: url.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
            }
            return request
        }
    }
    
    // MARK: Private properties
    
    private let cacheAge = 30
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.protocolClasses?.insert(DebuggingNetworkProtocol.self, at: 0)
        return Session(configuration: configuration)
    }()
    
    // MARK: Initialization
    
    init() { }
    
    // MARK: Private methods
    
    func setAlamofireHttpMethod(when method: ApiHTTPMethod) -> HTTPMethod {
        switch method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    func setAlamofireEncoding(when encoding: ApiParameterEncoding) -> ParameterEncoding {
        switch encoding {
        case .JSONEncoding:
            return JSONEncoding.default
        case .URLEncoding:
            return URLEncoding.default
        case .QueryEncoding:
            return URLEncoding.queryString
        case .ArrayEncoding:
            return ArrayEncoding()
        }
    }
    
    func setAlamofireHeaders(when data: ApiHTTPHeaders?)-> HTTPHeaders {
        guard let dictionary = data else {
            return HTTPHeaders()
        }
        return HTTPHeaders(dictionary)
    }
}

// MARK: NetworkingManagerProvider

extension NetworkingManagerAlamofire: NetworkingManagerProvider {
    func request(_ url: URL, method: ApiHTTPMethod, parameters: ApiParameters?, encoding: ApiParameterEncoding, headers: ApiHTTPHeaders?) -> RequestResponseProvider {
        let request = sessionManager.request(
            url,
            method: setAlamofireHttpMethod(when: method),
            parameters: params(parameters),
            encoding: setAlamofireEncoding(when: encoding),
            headers: setAlamofireHeaders(when: headers))
            .validate()
        
        return request
    }
    
    func upload(imageData: Data, _ requestable: NetworkRoutable) -> RequestResponseProvider {
        let parameters = params(requestable.parameters)
       return sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: ApiParameter.profileImageUrl.rawValue, fileName: "tmp.jpg", mimeType: "image/jpg")
            if let params = parameters {
                for (key, value) in params {
                    if let dataValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(dataValue, withName: key)
                    }
                }
            }
        },
        to: requestable.url,
        usingThreshold: UInt64.init(),
        method: setAlamofireHttpMethod(when: requestable.method),
        headers: setAlamofireHeaders(when: requestable.headers))
        .validate()
    }
}
