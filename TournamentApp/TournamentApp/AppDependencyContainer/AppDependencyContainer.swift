//
//  AppDependencyContainer.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

final class AppDependencyContainer {
   
    // MARK: - Properties

    // Long-lived dependencies
    lazy var networkingManager: NetworkingManagerProvider = {
        NetworkingManagerAlamofire()
    }()
    lazy var playerNetworkService: PlayerNetworkService = {
        PlayerNetworkService(networkSessionManager: networkingManager)
    }()
    lazy var factoryAppViewController: AppViewControllerFactory = {
        AppViewControllerFactory(hapticsManager: hapticsManager,
                                 factoryViewModel: factoryViewModel)
    }()
    lazy var factoryViewModel: ViewModelFactory = {
        ViewModelFactory(playerNetworkService: playerNetworkService)
    }()
    lazy var hapticsManager: HapticsManager = {
        HapticsManager()
    }()
    
    public init() { }
}
