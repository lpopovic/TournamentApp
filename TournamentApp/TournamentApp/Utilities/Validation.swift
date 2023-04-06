//
//  Validation.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 6.4.23..
//

import Foundation

enum Validation {
    case isPositiveNumber(value: String),
         isText(value: String),
         isLastNameText(value: String),
         isNotEmpty(value: String),
         isDate(value: String)
    
    var value: Bool {
        switch self {
        case .isPositiveNumber(let value):
            guard !value.isEmpty, let number = Int(value) else {
                return false
            }
            return number >= 0
        case .isText(let value):
            let lettersCharacters = CharacterSet.letters
            return !value.isEmpty && CharacterSet(charactersIn: value).isSubset(of: lettersCharacters)
        case .isLastNameText(let value):
            let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
            return !value.isEmpty && value.rangeOfCharacter(from: lettersAndSpacesCharacterSet) == nil
        case .isNotEmpty(let value):
            return !value.isEmpty && value.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        case .isDate(let value):
            return !value.isEmpty && value.toDate(withFormat: .reverseShortDate) != nil
        }
    }
}
