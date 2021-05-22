//
//  APIUrl.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import Foundation

final class APIUrl {
    static let shared = APIUrl()
    
    private init () {}
    
    private let baseApiUrl = "http://internships-mobile.htec.co.rs/api/"
    
    var players: String {
        get {
            return "\(baseApiUrl)players"
        }
    }
}
