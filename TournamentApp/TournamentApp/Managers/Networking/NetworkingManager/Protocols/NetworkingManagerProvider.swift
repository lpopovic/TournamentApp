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
}
