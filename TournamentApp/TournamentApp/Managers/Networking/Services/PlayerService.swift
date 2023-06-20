//
//  PlayerService.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

protocol PlayerNetworkServiceProvider {
    func getAllPlayerList(completion: @escaping (Result<[PlayerBaseInfo], NetworkError>) -> Void)
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[PlayerBaseInfo], NetworkError>) -> Void)
    func deletePlayer(with id: Int, completion: @escaping (ResultObject<String>) -> Void)
    func getDetailPlayer(with id: Int, completion: @escaping (Result<PlayerDetail, NetworkError>) -> Void)
    func postCreatePlayer(_ parameters: ApiParameters,
                          profileImageUrl: Data,
                          completion: @escaping (ResultObject<String>) -> Void)
    func putDetailPlayer(with id: Int,
                         _ parameters: ApiParameters,
                         profileImageUrl: Data?,
                         completion: @escaping (ResultObject<String>) -> Void)
}

class PlayerNetworkService {
    
    private let networkSessionManager: NetworkingManagerProvider
    
    init(networkSessionManager: NetworkingManagerProvider) {
        self.networkSessionManager = networkSessionManager
    }
}

extension PlayerNetworkService: PlayerNetworkServiceProvider {
    func getAllPlayerList(completion: @escaping (Result<[PlayerBaseInfo], NetworkError>) -> Void) {
        let networkRoutable = PlayerNetworkRouter.getAllPlayerList
        networkSessionManager.request(networkRoutable)
            .responseArray(completion: completion)
    }
    
    func getPlayerList(from page: Int, with limit: Int, completion: @escaping (Result<[PlayerBaseInfo], NetworkError>) -> Void) {
        let parameters: ApiParameters = [.limit: "\(limit)",
                                         .page: "\(page)"]
        let networkRoutable = PlayerNetworkRouter.getPlayerList(parameters)
        networkSessionManager.request(networkRoutable)
            .responseArray(completion: completion)
    }
    
    func deletePlayer(with id: Int, completion: @escaping (ResultObject<String>) -> Void) {
        let networkRoutable = PlayerNetworkRouter.deletePlayer("\(id)")
        networkSessionManager.request(networkRoutable)
            .response(completion: completion)
    }
    
    func getDetailPlayer(with id: Int, completion: @escaping (Result<PlayerDetail, NetworkError>) -> Void) {
        let networkRoutable = PlayerNetworkRouter.getDetailPlayer("\(id)")
        networkSessionManager.request(networkRoutable)
            .responseObject(completion: completion)
    }
    
    func postCreatePlayer(_ parameters: ApiParameters, profileImageUrl: Data, completion: @escaping (ResultObject<String>) -> Void) {
        let networkRoutable = PlayerNetworkRouter.postCreatePlayer(parameters)
        networkSessionManager.upload(imageData: profileImageUrl, networkRoutable)
            .response(completion: completion)
    }
    
    func putDetailPlayer(with id: Int, _ parameters: ApiParameters, profileImageUrl: Data?, completion: @escaping (ResultObject<String>) -> Void) {
        let networkRoutable = PlayerNetworkRouter.putDetailPlayer("\(id)", parameters)
        networkSessionManager.request(networkRoutable)
            .response(completion: completion)
    }
}
