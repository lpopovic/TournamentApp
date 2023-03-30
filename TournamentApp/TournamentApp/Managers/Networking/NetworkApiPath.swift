//
//  NetworkApiPath.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

enum NetworkApiPath {
    static let baseApiUrl = "http://internships-mobile.htec.co.rs/api/"
    static var players: String {
            return "\(baseApiUrl)players"
    }
}
