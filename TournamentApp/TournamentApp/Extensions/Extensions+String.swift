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
    
    enum Validation {
        case isPositiveNumber(value: String),
             isText(value: String),
             isLastNameText(value: String),
             isNotEmpty(value: String),
             isDate(value: String)
        
        var value: Bool {
            get {
                switch self {
                case .isPositiveNumber(let value):
                    guard !value.isEmpty, let number = Int(value) else {
                        return false
                    }
                    return number >= 0
                case .isText(let value):
                    let lettersCharacters = CharacterSet.letters
                    return !value.isEmpty && CharacterSet(charactersIn: value).isSubset(of: lettersCharacters)
                    
                case .isLastNameText( let value):
                    let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
                    return !value.isEmpty && value.rangeOfCharacter(from: lettersAndSpacesCharacterSet) == nil
                    
                case .isNotEmpty(let value):
                    return !value.isEmpty && value.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
                    
                case .isDate(let value):
                    return !value.isEmpty && value.toDate(withFormat: .reverseShortDate) != nil
                }
            }
        }
        
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
