//
//  ApiUrl.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import Foundation

final class ApiUrl {
    static let shared = ApiUrl()
    
    private init () {}
    
    private let baseApiUrl = "http://internships-mobile.htec.co.rs/api/"
    
    var players: String {
        get {
            return "\(baseApiUrl)players"
        }
    }
}
