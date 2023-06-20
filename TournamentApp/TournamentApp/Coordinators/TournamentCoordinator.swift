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
        var playerListViewController: BaseViewController?
        let showTournamentBracketScreen: VoidReturnClosure<[PlayerBaseInfo]> = { [weak self] players in
            self?.showTournamentBracketViewController(for: players, true)
        }
        let showAddPlayerScreen: NoArgsClosure = { [weak self] in
            guard let self, let playerListViewController = playerListViewController else { return }
            self.showPlayerAddViewController(for: playerListViewController)
        }
        let showPlayerScreen: VoidReturnClosure<Int> = { [weak self] playerId in
            self?.showPlayerViewController(playerId: playerId,
                                           playerListViewController as? PlayerViewControllerDelegate)
        }
        playerListViewController = factoryAppViewController.makePlayerListViewController(showTournamentBracketScreen: showTournamentBracketScreen,
                                                                                             showAddPlayerScreen: showAddPlayerScreen,
                                                                                             showPlayerScreen: showPlayerScreen)
        guard let playerListViewController = playerListViewController else { return }
        router.present(playerListViewController, animated: animated)
    }
    
    private func showTournamentBracketViewController(for players: [PlayerBaseInfo], _ animated: Bool) {
        let playerListViewController = factoryAppViewController.makeTournamentBracketViewController(with: players)
        router.present(playerListViewController, animated: animated)
    }
    
    private func showPlayerAddViewController(for parentViewController: BaseViewController,
                                             _ animated: Bool = true) {
        var modalNavigationRouter: ModalNavigationRouter?
        let onCloseRequestScreen: VoidReturnClosure<BaseViewController> = { screen in
            modalNavigationRouter?.dismiss(screen, animated: true)
        }
        let delegate = parentViewController as? PlayerAddEditViewControllerDelegate
        let playerAddEditViewController = factoryAppViewController.makePlayerAddEditViewController(typeOfVC: .add,
                                                                                                   playerId: nil,
                                                                                                   playerDetailInfo: nil,
                                                                                                   onCloseRequestScreen: onCloseRequestScreen,
                                                                                                   with: delegate)
        modalNavigationRouter = ModalNavigationRouter(parentViewController: parentViewController)
        modalNavigationRouter?.present(playerAddEditViewController, animated: animated)
    }
    
    private func showPlayerViewController(playerId: Int,
                                          _ delegate: PlayerViewControllerDelegate?,
                                          _ animated: Bool = true) {
       
        var playerViewController: BaseViewController?
        let showEditPlayerScreen: VoidReturnClosure<PlayerViewModel.EditPlayerRequest> = { [weak self] request in
            self?.showPlayerEditViewController(playerId: request.playerId,
                                               playerDetailInfo: request.playerDetailInfo,
                                               playerViewController as? PlayerAddEditViewControllerDelegate)
        }
        let onCloseRequestScreen: VoidReturnClosure<BaseViewController> = { [weak self] screen in
            self?.onCloseRequest(screen)
        }
        playerViewController = factoryAppViewController.makePlayerViewController(with: playerId,
                                                                                 showEditPlayerScreen: showEditPlayerScreen,
                                                                                 onCloseRequestScreen: onCloseRequestScreen,
                                                                                 delegate: delegate)
        guard let playerViewController = playerViewController else { return }
        router.present(playerViewController, animated: animated)
    }
    
    private func showPlayerEditViewController(playerId: Int?,
                                              playerDetailInfo: PlayerDetail?,
                                             _ delegate: PlayerAddEditViewControllerDelegate?,
                                             _ animated: Bool = true) {
        let onCloseRequestScreen: VoidReturnClosure<BaseViewController> = { [weak self] screen in
            self?.onCloseRequest(screen)
        }
        let playerAddEditViewController = factoryAppViewController.makePlayerAddEditViewController(typeOfVC: .edit,
                                                                                                   playerId: playerId,
                                                                                                   playerDetailInfo: playerDetailInfo,
                                                                                                   onCloseRequestScreen: onCloseRequestScreen,
                                                                                                   with: delegate)
        router.present(playerAddEditViewController, animated: animated)
    }
}

extension TournamentCoordinator {
    private func onCloseRequest(_ viewController: BaseViewController, _ animated: Bool = true) {
        router.dismiss(viewController, animated: animated)
    }
}
