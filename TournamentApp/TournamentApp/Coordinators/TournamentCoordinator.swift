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
        viewModel.showTournamentBracketScreen = { [weak self] players in
            self?.showTournamentBracketViewController(for: players, true)
        }
        viewModel.showAddPlayerScreen = { [weak self] in
            self?.showPlayerAddViewController(for: playerListViewController)
        }
        viewModel.showPlayerScreen = { [weak self] playerId in
            self?.showPlayerViewController(playerId: playerId,
                                           playerListViewController as? PlayerViewControllerDelegate)
        }
        router.present(playerListViewController, animated: animated)
    }
    
    private func showTournamentBracketViewController(for players: [Player], _ animated: Bool) {
        let viewModel = factoryViewModel.makeTournamentBracketViewModel(players)
        let dependencies = TournamentBracketViewController.Dependencies(viewModel: viewModel,
                                                                 hapticsManager: appDIContainer.hapticsManager)
        let playerListViewController = factoryAppViewController.makeTournamentBracketViewController(with: dependencies)
        router.present(playerListViewController, animated: animated)
    }
    
    private func showPlayerAddViewController(for parentViewController: BaseViewController,
                                             _ animated: Bool = true) {
        let viewModelDependencies = PlayerAddEditViewModel.Dependencies(typeOfVC: .add,
                                                                        playerId: nil,
                                                                        playerDetailInfo: nil,
                                                                        apiCaller: appDIContainer.playerNetworkService)
        let viewModel = factoryViewModel.makePlayerAddEditViewModel(viewModelDependencies)
      
        let delegate = parentViewController as? PlayerAddEditViewControllerDelegate
        let playerAddEditViewControllerDependencies = PlayerAddEditViewController.Dependencies(viewModel: viewModel,
                                                                                               hapticsManager: appDIContainer.hapticsManager,
                                                                                               delegate: delegate)
        let playerAddEditViewController = factoryAppViewController.makePlayerAddEditViewController(with: playerAddEditViewControllerDependencies)
        
        let modalNavigationRouter = ModalNavigationRouter(parentViewController: parentViewController)
        modalNavigationRouter.present(playerAddEditViewController, animated: animated)
        viewModel.onCloseRequestScreen = { screen in
            modalNavigationRouter.dismiss(screen, animated: true)
        }
    }
    
    private func showPlayerViewController(playerId: Int,
                                          _ delegate: PlayerViewControllerDelegate?,
                                          _ animated: Bool = true) {
        let viewModel = factoryViewModel.makePlayerViewModel(playerId, appDIContainer.playerNetworkService)
        let playerViewControllerDependencies = PlayerViewController.Dependencies(viewModel: viewModel,
                                                                                 hapticsManager: appDIContainer.hapticsManager,
                                                                                 delegate: delegate)
        let playerViewController = factoryAppViewController.makePlayerViewController(with: playerViewControllerDependencies)
        viewModel.showEditPlayerScreen = { [weak self] request in
            self?.showPlayerEditViewController(playerId: request.playerId,
                                               playerDetailInfo: request.playerDetailInfo,
                                               playerViewController as? PlayerAddEditViewControllerDelegate)
        }
        viewModel.onCloseRequestScreen = { [weak self] screen in
            self?.onCloseRequest(screen)
        }
        router.present(playerViewController, animated: animated)
    }
    
    private func showPlayerEditViewController(playerId: Int?,
                                              playerDetailInfo: PlayerDetail?,
                                             _ delegate: PlayerAddEditViewControllerDelegate?,
                                             _ animated: Bool = true) {
        let viewModelDependencies = PlayerAddEditViewModel.Dependencies(typeOfVC: .edit,
                                                                        playerId: playerId,
                                                                        playerDetailInfo: playerDetailInfo,
                                                                        apiCaller: appDIContainer.playerNetworkService)
        let viewModel = factoryViewModel.makePlayerAddEditViewModel(viewModelDependencies)
        viewModel.onCloseRequestScreen = { [weak self] screen in
            self?.onCloseRequest(screen)
        }
        let playerAddEditViewControllerDependencies = PlayerAddEditViewController.Dependencies(viewModel: viewModel,
                                                                                               hapticsManager: appDIContainer.hapticsManager,
                                                                                               delegate: delegate)
        let playerAddEditViewController = factoryAppViewController.makePlayerAddEditViewController(with: playerAddEditViewControllerDependencies)
        router.present(playerAddEditViewController, animated: animated)
    }
}

extension TournamentCoordinator {
    private func onCloseRequest(_ viewController: BaseViewController, _ animated: Bool = true) {
        router.dismiss(viewController, animated: animated)
    }
}
