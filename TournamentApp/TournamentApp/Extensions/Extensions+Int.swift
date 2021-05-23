//
//  Extensions+Int.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation

extension Int {
    var formatedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
    
    var boolValue: Bool {
        return self != 0
    }
}
