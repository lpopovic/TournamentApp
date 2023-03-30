//
//  PlayerService.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol PlayerNetworkServiceProvider {
    func getAllPlayerList(completion: @escaping (Result<[Player], NetworkError>) -> Void)
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[Player], NetworkError>) -> Void)
}

class PlayerNetworkService: PlayerNetworkServiceProvider {
    func getAllPlayerList(completion: @escaping (Result<[Player], NetworkError>) -> Void) {
        PlayerNetworkRouter
            .getAllPlayerList
            .request
            .responseArray(completion: completion)
    }
    
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[Player], NetworkError>) -> Void) {
        let parameter = [ApiParameter.limit.rawValue: "\(limit)",
                         ApiParameter.page.rawValue: "\(page)"]
        PlayerNetworkRouter
            .getPlayerList(parameter)
            .request
            .responseArray(completion: completion)
    }
}
