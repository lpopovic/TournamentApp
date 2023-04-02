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
    private let networkSessionManager: NetworkingManagerProvider
    private let playerNetworkRouter: PlayerNetworkRouter.Type = PlayerNetworkRouter.self
    
    init(networkSessionManager: NetworkingManagerProvider) {
        self.networkSessionManager = networkSessionManager
    }
    
    func getAllPlayerList(completion: @escaping (Result<[Player], NetworkError>) -> Void) {
        networkSessionManager.request(playerNetworkRouter.getAllPlayerList)
            .responseArray(completion: completion)
    }
    
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[Player], NetworkError>) -> Void) {
        let parameter = [ApiParameter.limit.rawValue: "\(limit)",
                         ApiParameter.page.rawValue: "\(page)"]
        networkSessionManager.request(playerNetworkRouter.getPlayerList(parameter))
            .responseArray(completion: completion)
    }
}
