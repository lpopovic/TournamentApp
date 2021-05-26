//
//  Match.swift
//  TournamentApp
//
//  Created by MacBook on 5/26/21.
//

import Foundation

struct Match: Codable {
    let playerOne: Player
    let playerOneRank: Int
    
    let playerSecond: Player
    let playerSecondRank: Int
}
