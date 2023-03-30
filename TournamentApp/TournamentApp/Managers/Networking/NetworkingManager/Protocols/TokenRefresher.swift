//
//  TokenRefresher.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol TokenRefresher {
    func refreshToken(completion: @escaping (ResultObject<Tokens>) -> ())
}
