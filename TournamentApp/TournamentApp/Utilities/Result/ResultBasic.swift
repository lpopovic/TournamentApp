//
//  ResultBasic.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

enum ResultBasic {
    case success
    case failure(Error)
    
    // MARK: - Properties
    
    var isSuccess: Bool {
        self == .success
    }
    
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - Equatable
extension ResultBasic: Equatable {
    static func == (lhs: ResultBasic, rhs: ResultBasic) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case let (.failure(error1), .failure(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
