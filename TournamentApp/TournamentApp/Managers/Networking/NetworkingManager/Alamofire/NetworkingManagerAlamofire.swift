//
//  NetworkingManagerAlamofire.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation
import Alamofire
import AlamofireURLCache5


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
    private lazy var sessionManager: Session = {
       AF
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
            parameters: parameters,
            encoding: setAlamofireEncoding(when: encoding),
            headers: setAlamofireHeaders(when: headers))
        .validate()
        
        return request
    }
}
