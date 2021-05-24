//
//  Extensions+String.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import Foundation

extension String {
    func toDate(withFormat format: String = Date.dateOfBirthFullFormat)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
    enum Validation {
        case isPositiveNumber(value: String),
             isText(value: String),
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
                    
                case .isText( let value):
                    let lettersCharacters = CharacterSet.letters
                    return !value.isEmpty && CharacterSet(charactersIn: value).isSubset(of: lettersCharacters)
                    
                case .isNotEmpty(let value):
                    return !value.isEmpty
                    
                case .isDate(let value):
                    return !value.isEmpty && value.toDate(withFormat: Date.dateOfBirthFormat) != nil
                }
            }
        }
        
    }
}
