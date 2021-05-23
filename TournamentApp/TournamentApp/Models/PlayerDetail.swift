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
