//
//  ViewModelFactory.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

protocol ViewModelFactoryProvider {
    func makeHomeViewModel() -> HomeViewModel
    func makePlayerListViewModel() -> PlayerListViewModel
    func makeTournamentBracketViewModel(_ players: [Player]) -> TournamentBracketViewModel
    func makePlayerAddEditViewModel(_ typeOfVC: PlayerAddEditViewModel.TypeViewController, playerId: Int?, playerDetailInfo: PlayerDetail?) -> PlayerAddEditViewModel
    func makePlayerViewModel(_ playerId: Int) -> PlayerViewModel
}


class ViewModelFactory {
    
    private let playerNetworkService: PlayerNetworkServiceProvider
    
    init(playerNetworkService: PlayerNetworkServiceProvider) {
        self.playerNetworkService = playerNetworkService
    }
}

extension ViewModelFactory: ViewModelFactoryProvider {
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    func makePlayerListViewModel() -> PlayerListViewModel {
        PlayerListViewModel(apiCaller: playerNetworkService)
    }
    
    func makeTournamentBracketViewModel(_ players: [Player]) -> TournamentBracketViewModel {
        TournamentBracketViewModel(playerList: players)
    }
    
    func makePlayerAddEditViewModel(_ typeOfVC: PlayerAddEditViewModel.TypeViewController, playerId: Int?, playerDetailInfo: PlayerDetail?) -> PlayerAddEditViewModel {
        let dependencies = PlayerAddEditViewModel.Dependencies(typeOfVC: typeOfVC,
                                                               playerId: playerId,
                                                               playerDetailInfo: playerDetailInfo,
                                                               apiCaller: playerNetworkService)
        return PlayerAddEditViewModel(dependencies: dependencies)
    }
    
    func makePlayerViewModel(_ playerId: Int) -> PlayerViewModel {
        PlayerViewModel(playerId: playerId, apiCaller: playerNetworkService)
    }
}
