//
//  PlayerRouter.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

enum PlayerNetworkRouter {
    case getAllPlayerList
    case getPlayerList(ApiParameters)
}

extension PlayerNetworkRouter: NetworkRoutable {
    var path: ApiPath {
        switch self {
        case .getAllPlayerList,
             .getPlayerList:
            return "/api/players"
        }
    }
    
    var encoding: ApiParameterEncoding {
        switch self {
        case .getAllPlayerList:
            return .URLEncoding
        case .getPlayerList:
            return .QueryEncoding
        }
    }
    
    var parameters: ApiParameters? {
        switch self {
        case .getAllPlayerList:
            return nil
        case .getPlayerList(let apiParameters):
            return apiParameters
        }
    }
}
