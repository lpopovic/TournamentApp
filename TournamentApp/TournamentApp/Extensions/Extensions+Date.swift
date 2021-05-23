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
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: self)
    }
}
