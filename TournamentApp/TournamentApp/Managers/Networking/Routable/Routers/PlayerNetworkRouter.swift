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
    case deletePlayer(String)
    case getDetailPlayer(String)
    case postCreatePlayer(ApiParameters)
    case putDetailPlayer(String, ApiParameters)
}

extension PlayerNetworkRouter: NetworkRoutable {
    var path: ApiPath {
        switch self {
        case .getAllPlayerList,
             .getPlayerList,
             .postCreatePlayer:
            return "/api/players"
        case .deletePlayer(let playerId):
            return "/api/players/\(playerId)"
        case .getDetailPlayer(let playerId):
            return "/api/players/\(playerId)"
        case .putDetailPlayer(let playerId, _):
            return "/api/players/\(playerId)"
        }
    }
    
    var encoding: ApiParameterEncoding {
        switch self {
        case .getAllPlayerList:
            return .URLEncoding
        case .getPlayerList:
            return .QueryEncoding
        case .deletePlayer:
            return .URLEncoding
        case .getDetailPlayer:
            return .URLEncoding
        case .postCreatePlayer:
            return .URLEncoding
        case .putDetailPlayer:
            return .QueryEncoding
        }
    }
    
    var parameters: ApiParameters? {
        switch self {
        case .getAllPlayerList:
            return nil
        case .getPlayerList(let apiParameters):
            return apiParameters
        case .deletePlayer:
            return nil
        case .getDetailPlayer:
            return nil
        case .postCreatePlayer(let apiParameters):
            return apiParameters
        case .putDetailPlayer(_, let apiParameters):
            return apiParameters
        }
    }
    
    var method: ApiHTTPMethod {
        switch self {
        case .getAllPlayerList,
             .getPlayerList,
             .getDetailPlayer:
            return .get
        case .deletePlayer:
            return .delete
        case .postCreatePlayer:
            return .post
        case .putDetailPlayer:
            return .put
        }
    }
    
    var headers: ApiHTTPHeaders? {
        var headers = [
            "x-tournament-id": "\(GlobalConstants.tournomentId)",
            "Accept": "application/json",
            "Content-Type": "application/json"]
        switch self {
        case .getAllPlayerList,
             .getPlayerList,
             .deletePlayer,
             .getDetailPlayer,
             .putDetailPlayer:
            return headers
        case .postCreatePlayer:
            headers["Content-type"] = "multipart/form-data"
            return headers
        }
    }
}
