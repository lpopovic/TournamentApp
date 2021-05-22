//
//  Extensions+Formatter.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
