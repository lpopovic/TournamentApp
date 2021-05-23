//
//  PlayerDetail.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

struct PlayerDetail: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let points: Int?
    let dateOfBirth: String?
    let profileImageUrl: String?
    let isProfessional: Int?
    let tournament_id: Int?
    let description: String?
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = nil
        self.dateOfBirth = nil
        self.profileImageUrl = nil
        self.isProfessional = nil
        self.tournament_id = nil
        self.description = nil
    }
    
    init(id: Int, firstName: String, lastName: String, points: Int?, dateOfBirth: String?, profileImageUrl: String?, isProfessional: Int?, tournament_id: Int?, description: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = points
        self.dateOfBirth = dateOfBirth
        self.profileImageUrl = profileImageUrl
        self.isProfessional = isProfessional
        self.tournament_id = tournament_id
        self.description = description
    }
}

extension PlayerDetail {
    func getStringIsProfessional() -> String {
        if let isProfessional = self.isProfessional {
            return isProfessional.boolValue ? "yes" : "no"
        } else {
            return "undefined"
        }
    }
    
    func getStringDateOfBirth() -> String? {
        if let dateOfBirth = self.dateOfBirth, let date = dateOfBirth.toDate() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func getPoints() -> Int {
        return self.points ?? 0
    }
}
