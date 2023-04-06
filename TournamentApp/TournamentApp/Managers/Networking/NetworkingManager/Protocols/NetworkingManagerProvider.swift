//
//  NetworkingManagerProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol NetworkingManagerProvider {
    func request(
        _ url: URL,
        method: ApiHTTPMethod,
        parameters: ApiParameters?,
        encoding: ApiParameterEncoding,
        headers: ApiHTTPHeaders?) -> RequestResponseProvider
    func request(_ requestable: NetworkRoutable) -> RequestResponseProvider
    func upload(imageData: Data, _ requestable: NetworkRoutable) -> RequestResponseProvider
    func params(_ apiParameters: ApiParameters?) -> Parameters?
}

extension NetworkingManagerProvider {
    func request(_ requestable: NetworkRoutable) -> RequestResponseProvider {
        request(requestable.url,
                method: requestable.method,
                parameters: requestable.parameters,
                encoding: requestable.encoding,
                headers: requestable.headers)
    }
    
    func params(_ apiParameters: ApiParameters?) -> Parameters? {
        guard let apiParameters = apiParameters else { return nil }
        var params = Parameters()
        for (key, value) in apiParameters {
            params[key.rawValue] = value
        }
        return params
    }

}
