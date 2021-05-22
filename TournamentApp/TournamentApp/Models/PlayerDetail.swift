//
//  PlayerDetail.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct PlayerDetail: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let points: String?
    let dateOfBirth: String?
    let profileImageUrl: String?
    let isProfessional: Int?
    let tournament_id: Int?
}
