//
//  ApiCaller.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    
    private init () {}
    
    enum ApiError: Error {
        case faileedToGetData
    }
    
}
