//
//  Extensions+Date.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import Foundation

extension Date {
    func getDateOfBirthFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.dateOfBirthFormat
        return dateFormatter.string(from: self)
    }
    
    static let dateOfBirthFormat: String = "YYYY-MM-dd"
    static let dateOfBirthFullFormat: String = "yyyy-MM-dd HH:mm:ss"
}
