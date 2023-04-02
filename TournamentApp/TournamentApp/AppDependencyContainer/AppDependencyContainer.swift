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
    let apiCaller: ApiCaller
    let networkingManager: NetworkingManagerProvider
    let factoryAppViewController: AppViewControllerFactory
    let factoryViewModel: ViewModelFactory
    let hapticsManager: HapticsManager
    lazy var playerNetworkService: PlayerNetworkService = {
        PlayerNetworkService(networkSessionManager: networkingManager)
    }()
    
    public init() {
        func makeApiCaller() -> ApiCaller {
            return ApiCaller()
        }
        func makeNetworkingManager() -> NetworkingManagerProvider {
          return NetworkingManagerAlamofire()
        }
        func makeFactoryAppViewController() -> AppViewControllerFactory {
            return AppViewControllerFactory()
        }
        func makeFactoryViewModel() -> ViewModelFactory {
            return ViewModelFactory()
        }
        func makeHapticsManager() -> HapticsManager {
            HapticsManager()
        }
        self.apiCaller = makeApiCaller()
        self.networkingManager = makeNetworkingManager()
        self.factoryAppViewController = makeFactoryAppViewController()
        self.factoryViewModel = makeFactoryViewModel()
        self.hapticsManager = makeHapticsManager()
    }
}
