//
//  AppMainCoordinator.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

public class AppMainCoordinator: Coordinator {
    public let router: Router
    public var children: [Coordinator] = []
    private let appDIContainer: AppDependencyContainer
    private var rootViewController: NavigationViewController?
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
        showHomeViewController(animated)
    }
}

extension AppMainCoordinator {
    private func showHomeViewController(_ animated: Bool) {
        let viewModel = factoryViewModel.makeHomeViewModel()
        viewModel.showPlayerListScreen = { [weak self] in
            self?.startTournamentCoordinator(true)
        }
        let dependencies = HomeViewController.Dependencies(viewModel: viewModel, hapticsManager: appDIContainer.hapticsManager)
        let homeViewController = factoryAppViewController.makeHomeViewController(with: dependencies)
        let navigationViewController = NavigationViewController(rootViewController: homeViewController)
        rootViewController = navigationViewController
        router.present(navigationViewController, animated: animated)
    }    
}

extension AppMainCoordinator {
    private func startTournamentCoordinator(_ animated: Bool) {
        guard let navigationController = rootViewController else { return }
        let navigationRouter = NavigationRouter(navigationController: navigationController)
        let tournamentCoordinator = TournamentCoordinator(router: navigationRouter,
                                                          appDIContainer: appDIContainer)
        presentChild(tournamentCoordinator, animated: animated)
    }
}
