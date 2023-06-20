//
//  Match.swift
//  TournamentApp
//
//  Created by MacBook on 5/26/21.
//

import Foundation

struct Match: Codable {
    let playerOne: PlayerBaseInfo
    let playerOneRank: Int
    
    let playerSecond: PlayerBaseInfo
    let playerSecondRank: Int
}
