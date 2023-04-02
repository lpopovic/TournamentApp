//
//  ViewModelFactory.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

protocol ViewModelFactoryProvider {
    func makeHomeViewModel() -> HomeViewModel
    func makePlayerListViewModel(_ playerNetworkService: PlayerNetworkServiceProvider) -> PlayerListViewModel
    func makeTournamentBracketViewModel(_ players: [Player]) -> TournamentBracketViewModel
    func makePlayerAddEditViewModel(_ dependencies: PlayerAddEditViewModel.Dependencies) -> PlayerAddEditViewModel
    func makePlayerViewModel(_ playerId: Int, _ apiCaller: ApiCallerProvider) -> PlayerViewModel 
}


class ViewModelFactory: ViewModelFactoryProvider {
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    func makePlayerListViewModel(_ playerNetworkService: PlayerNetworkServiceProvider) -> PlayerListViewModel {
        PlayerListViewModel(apiCaller: playerNetworkService)
    }
    
    func makeTournamentBracketViewModel(_ players: [Player]) -> TournamentBracketViewModel {
        TournamentBracketViewModel(playerList: players)
    }
    
    func makePlayerAddEditViewModel(_ dependencies: PlayerAddEditViewModel.Dependencies) -> PlayerAddEditViewModel {
        PlayerAddEditViewModel(dependencies: dependencies)
    }
    
    func makePlayerViewModel(_ playerId: Int, _ apiCaller: ApiCallerProvider) -> PlayerViewModel {
        PlayerViewModel(playerId: playerId, apiCaller: apiCaller)
    }
}
