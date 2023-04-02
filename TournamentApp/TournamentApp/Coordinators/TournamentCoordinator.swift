//
//  TournamentCoordinator.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

public class TournamentCoordinator: Coordinator {
    public let router: Router
    public var children: [Coordinator] = []

    private let appDIContainer: AppDependencyContainer
    private var factoryViewModel: ViewModelFactoryProvider {
        appDIContainer.factoryViewModel
    }
    private var factoryAppViewController: AppViewControllerFactoryProvider {
        appDIContainer.factoryAppViewController
    }

    init(router: Router, appDIContainer: AppDependencyContainer) {
        self.router = router
        self.appDIContainer = appDIContainer
    }
    
    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        showPlayerListViewController(animated)
    }
}

extension TournamentCoordinator {
    private func showPlayerListViewController(_ animated: Bool) {
        let viewModel = factoryViewModel.makePlayerListViewModel(appDIContainer.playerNetworkService)
        let dependencies = PlayerListViewController.Dependencies(viewModel: viewModel,
                                                                 hapticsManager: appDIContainer.hapticsManager)
        let playerListViewController = factoryAppViewController.makePlayerListViewController(with: dependencies)
        router.present(playerListViewController, animated: animated)
    }
}
