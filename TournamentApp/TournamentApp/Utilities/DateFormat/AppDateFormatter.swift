//
//  AppDateFormatter.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 6.4.23..
//

import Foundation

enum AppDateFormatter {
    case reverseShortDate
    case shortDate
    case dateAndTime
    case custom(String)
    
    var format: String {
        switch self {
        case .reverseShortDate:
            return "YYYY-MM-dd"
        case .shortDate:
            return "dd-MM-YYYY"
        case .dateAndTime:
            return "yyyy-MM-dd HH:mm:ss"
        case .custom(let format):
            return format
        }
    }
    
    // MARK: - Properties
        
    private var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    // MARK: - Public methods
    
    func string(from date: Date) -> String {
        formatter.string(from: date)
    }
    
    func date(from string: String) -> Date? {
        formatter.date(from: string)
    }
}
