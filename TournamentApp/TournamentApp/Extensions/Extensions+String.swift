//
//  Extensions+String.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}
