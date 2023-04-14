//
//  AppViewControllerFactory.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

protocol AppViewControllerFactoryProvider {
    func makeHomeViewController(showPlayerListScreen: NoArgsClosure?) -> BaseViewController
    func makePlayerListViewController(showTournamentBracketScreen: VoidReturnClosure<[Player]>?,
                                      showAddPlayerScreen: NoArgsClosure?,
                                      showPlayerScreen: VoidReturnClosure<Int>?) -> BaseViewController
    func makePlayerViewController(with playerId: Int,
                                  showEditPlayerScreen: VoidReturnClosure<PlayerViewModel.EditPlayerRequest>?,
                                  onCloseRequestScreen: VoidReturnClosure<BaseViewController>?,
                                  delegate: PlayerViewControllerDelegate?) -> BaseViewController
    func makePlayerAddEditViewController(typeOfVC: PlayerAddEditViewModel.TypeViewController,
                                         playerId: Int?,
                                         playerDetailInfo: PlayerDetail?,
                                         onCloseRequestScreen: VoidReturnClosure<BaseViewController>?,
                                         with delegate: PlayerAddEditViewControllerDelegate?) -> BaseViewController
    func makeTournamentBracketViewController(with players: [Player]) -> BaseViewController
}

class AppViewControllerFactory {
    private let hapticsManager: HapticsManagerProvider
    private let factoryViewModel: ViewModelFactoryProvider
    
    init(hapticsManager: HapticsManagerProvider, factoryViewModel: ViewModelFactoryProvider) {
        self.hapticsManager = hapticsManager
        self.factoryViewModel = factoryViewModel
    }
}

extension AppViewControllerFactory: AppViewControllerFactoryProvider {
    func makeHomeViewController(showPlayerListScreen: NoArgsClosure?) -> BaseViewController {
        let viewModel = factoryViewModel.makeHomeViewModel()
        viewModel.showPlayerListScreen = showPlayerListScreen
        let dependencies = HomeViewController.Dependencies(viewModel: viewModel,
                                                           hapticsManager: hapticsManager)
        return HomeViewController.instantiate(with: dependencies)
    }
    
    func makePlayerListViewController(showTournamentBracketScreen: VoidReturnClosure<[Player]>?,
                                      showAddPlayerScreen: NoArgsClosure?,
                                      showPlayerScreen: VoidReturnClosure<Int>?) -> BaseViewController {
        let viewModel = factoryViewModel.makePlayerListViewModel()
        viewModel.showTournamentBracketScreen = showTournamentBracketScreen
        viewModel.showAddPlayerScreen = showAddPlayerScreen
        viewModel.showPlayerScreen = showPlayerScreen
        let dependencies = PlayerListViewController.Dependencies(viewModel: viewModel,
                                                                 hapticsManager: hapticsManager)
        return PlayerListViewController.instantiate(with: dependencies)
    }
    
    func makePlayerAddEditViewController(typeOfVC: PlayerAddEditViewModel.TypeViewController,
                                         playerId: Int?,
                                         playerDetailInfo: PlayerDetail?,
                                         onCloseRequestScreen: VoidReturnClosure<BaseViewController>?,
                                         with delegate: PlayerAddEditViewControllerDelegate?) -> BaseViewController {
        let viewModel = factoryViewModel.makePlayerAddEditViewModel(typeOfVC,
                                                                    playerId: playerId,
                                                                    playerDetailInfo: playerDetailInfo)
        viewModel.onCloseRequestScreen = onCloseRequestScreen
        let dependencies = PlayerAddEditViewController.Dependencies(viewModel: viewModel,
                                                                    hapticsManager: hapticsManager,
                                                                    delegate: delegate)
        return PlayerAddEditViewController.instantiate(with: dependencies)
    }
    
    func makeTournamentBracketViewController(with players: [Player]) -> BaseViewController {
        let viewModel = factoryViewModel.makeTournamentBracketViewModel(players)
        let dependencies = TournamentBracketViewController.Dependencies(viewModel: viewModel,
                                                                        hapticsManager: hapticsManager)
        return TournamentBracketViewController.instantiate(with: dependencies)
    }
    
    func makePlayerViewController(with playerId: Int,
                                  showEditPlayerScreen: VoidReturnClosure<PlayerViewModel.EditPlayerRequest>?,
                                  onCloseRequestScreen: VoidReturnClosure<BaseViewController>?,
                                  delegate: PlayerViewControllerDelegate?) -> BaseViewController {
        let viewModel = factoryViewModel.makePlayerViewModel(playerId)
        viewModel.showEditPlayerScreen = showEditPlayerScreen
        viewModel.onCloseRequestScreen = onCloseRequestScreen
        let dependencies = PlayerViewController.Dependencies(viewModel: viewModel,
                                                             hapticsManager: hapticsManager,
                                                             delegate: delegate)
       return PlayerViewController.instantiate(with: dependencies)
    }
}
