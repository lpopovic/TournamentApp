//
//  DataResponse.swift
//  TournamentApp
//
//  Created by MacBook on 6/2/21.
//

import Foundation

struct DataResponse<T: Codable>: Codable {
    let success: Bool
    let data: T
    let message: String
}
