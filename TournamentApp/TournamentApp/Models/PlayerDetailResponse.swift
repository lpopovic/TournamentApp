//
//  PlayerDetailResponse.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct PlayerDetailResponse: Codable {
    let success: Bool
    let data: PlayerDetail
    let message: String
}
