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
}


class ViewModelFactory: ViewModelFactoryProvider {
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel()
    }
    
    func makePlayerListViewModel(_ playerNetworkService: PlayerNetworkServiceProvider) -> PlayerListViewModel {
        PlayerListViewModel(apiCaller: playerNetworkService)
    }
}
