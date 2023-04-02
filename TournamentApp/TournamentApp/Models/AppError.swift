//
//  AppError.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

enum AppError {
    case runtimeError(message: String)
}

// MARK: - LocalizedError
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .runtimeError(let message):
            return message
        }
    }
}
