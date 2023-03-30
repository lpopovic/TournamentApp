//
//  RequestResponseProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol RequestResponseProvider {
    func response(completion: @escaping (ResultBasic) -> ())
    func responseObject<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> ())
    func responseArray<T: Decodable>(completion: @escaping (Result<[T], NetworkError>) -> ())
}
