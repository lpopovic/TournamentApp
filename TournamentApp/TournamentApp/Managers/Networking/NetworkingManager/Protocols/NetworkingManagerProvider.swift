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
}

extension NetworkingManagerProvider {
    func request(_ requestable: NetworkRoutable) -> RequestResponseProvider {
        request(requestable.url,
                method: requestable.method,
                parameters: requestable.parameters,
                encoding: requestable.encoding,
                headers: requestable.headers)
    }

}
