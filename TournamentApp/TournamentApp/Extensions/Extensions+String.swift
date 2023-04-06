//
//  Extensions+String.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import Foundation

extension String {
    func toDate(withFormat format: AppDateFormatter) -> Date? {
        format.date(from: self)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
