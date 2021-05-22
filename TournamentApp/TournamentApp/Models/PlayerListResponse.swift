//
//  PlayerListResponse.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct PlayerListResponse: Codable {
    let success: Bool
    let data: [Player]
    let message: String
}
