//
//  ResultObject.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

enum ResultObject<T> {
    case success(T)
    case failure(Error)
    
    // MARK: - Properties
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
    // MARK: - Methods
    
    func resolve() throws -> T {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
