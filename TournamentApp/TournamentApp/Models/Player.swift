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
    let points: Int?
    let tournament_id: Int?
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = nil
        self.tournament_id = nil
    }
    
    init(id: Int, firstName: String, lastName: String, points: Int?, tournament_id: Int?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = points
        self.tournament_id = tournament_id
    }
}

extension Player {
    func getPoints() -> Int {
        return self.points ?? 0
    }
}
