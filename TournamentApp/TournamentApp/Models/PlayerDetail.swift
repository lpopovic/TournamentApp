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
    let tournamentId: Int?
    let description: String?
    
    
    init(id: Int,
         firstName: String,
         lastName: String,
         points: Int? = nil,
         dateOfBirth: String? = nil,
         profileImageUrl: String? = nil,
         isProfessional: Int? = nil,
         tournamentId: Int? = nil,
         description: String? = nil)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = points
        self.dateOfBirth = dateOfBirth
        self.profileImageUrl = profileImageUrl
        self.isProfessional = isProfessional
        self.tournamentId = tournamentId
        self.description = description
    }
    
    private enum CodingKeys: String, CodingKey {
        case tournamentId = "tournament_id"
        case id
        case firstName
        case lastName
        case points
        case dateOfBirth
        case profileImageUrl
        case isProfessional
        case description
    }
}

extension PlayerDetail {
    func getStringIsProfessional() -> String {
        if let isProfessional = isProfessional {
            return isProfessional.boolValue ? "yes" : "no"
        } else {
            return "undefined"
        }
    }
    
    func getDateDateOfBirth() -> Date? {
        guard let dateOfBirth = dateOfBirth,
              let date = dateOfBirth.toDate(withFormat: .dateAndTime)
        else { return nil }
        return date
    }
    
    func getStringDateOfBirth() -> String? {
        guard let date: Date = getDateDateOfBirth()
        else { return nil }
        return date.toString(withFormat: .reverseShortDate)
    }
    
    func getPoints() -> Int {
        guard let points = self.points else {
            return 0
        }
        return points
    }
}
