//
//  PlayerBaseInfo.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct PlayerBaseInfo: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let points: Int?
    let tournament_id: Int?
    
    init(id: Int, firstName: String, lastName: String, points: Int? = nil, tournament_id: Int? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = points
        self.tournament_id = tournament_id
    }
}

extension PlayerBaseInfo {
    func getPoints() -> Int {
        return self.points ?? 0
    }
}
