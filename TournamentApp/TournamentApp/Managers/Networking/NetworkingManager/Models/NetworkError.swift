//
//  NetworkError.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

enum NetworkError {
    case general
    case failedToGetData
    case mapping
    case runtimeError(message: String)
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .general:
            return "General Alamofire error"
        case .mapping:
            return "Mapping error"
        case .failedToGetData:
            return "Failed to get data."
        case .runtimeError(let message):
            return message
        }
    }
}
