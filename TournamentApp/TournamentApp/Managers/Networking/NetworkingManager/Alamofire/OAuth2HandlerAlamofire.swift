//
//  OAuth2HandlerAlamofire.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation
import Alamofire

final class OAuth2HandlerAlamofire {
    
    // MARK: Private properties
    
    typealias RequestRetryCompletion = (Alamofire.RetryResult) -> Void
    
    private let queue = DispatchQueue(label: "RefreshQueue")
    private let refresher: TokenRefresher
    private var tokens: Tokens
    private var isRefreshing = false
    private var requestsToRetry = [RequestRetryCompletion]()
    
    // MARK: Initialization
    
    init(tokens: Tokens, refresher: TokenRefresher) {
        self.tokens = tokens
        self.refresher = refresher
    }
}

// MARK: - RequestAdapter

extension OAuth2HandlerAlamofire: RequestAdapter {
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("\(GlobalConstants.APIAccess.authorizationPrefix)\(tokens.headerToken ?? "")", forHTTPHeaderField: GlobalConstants.APIAccess.authorization)
        completion(.success(urlRequest))
    }
}

// MARK: - RequestRetrier

extension OAuth2HandlerAlamofire: RequestRetrier {
    func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        queue.sync {
            guard let response = request.task?.response as? HTTPURLResponse else {
                completion(.doNotRetry)
                return
            }
            switch response.statusCode {
            case 401:
                requestsToRetry.append(completion)
                if !isRefreshing {
                    isRefreshing = true
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.refresher.refreshToken { result in
                            self.isRefreshing = false
                            self.queue.sync {
                                if let newTokens = result.value {
                                    self.tokens = newTokens
                                }
                                self.requestsToRetry.forEach { $0(result.isSuccess ? .retry : .doNotRetry) }
                                self.requestsToRetry.removeAll()
                            }
                        }
                    }
                }
            default:
                // TODO: Check if you need to insert a check for updates here, if status code begins with 4
                completion(.doNotRetry)
            }
        }
    }
}
