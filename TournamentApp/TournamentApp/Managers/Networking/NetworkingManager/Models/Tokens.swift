//
//  Tokens.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol Tokens {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    
    var headerToken: String? { get }
}

// MARK: - Default implementation

extension Tokens {
    var accessToken: String? {
        nil
    }
    var refreshToken: String? {
        nil
    }
    
    var headerToken: String? {
        accessToken
    }
}
