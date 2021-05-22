//
//  Player.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct Player: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let points: Int
    let tournament_id: Int?
}
