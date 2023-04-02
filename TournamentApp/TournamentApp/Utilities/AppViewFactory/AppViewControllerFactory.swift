//
//  AppViewControllerFactory.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

protocol AppViewControllerFactoryProvider {
    func makeHomeViewController(with dependencies: HomeViewController.Dependencies) -> BaseViewController
    func makePlayerListViewController(with dependencies: PlayerListViewController.Dependencies) -> BaseViewController
    func makePlayerViewController(with dependencies: PlayerViewController.Dependencies) -> BaseViewController 
    func makePlayerAddEditViewController(with dependencies: PlayerAddEditViewController.Dependencies) -> BaseViewController
    func makeTournamentBracketViewController(with dependencies: TournamentBracketViewController.Dependencies) -> BaseViewController
}

class AppViewControllerFactory: AppViewControllerFactoryProvider {
   
    func makeHomeViewController(with dependencies: HomeViewController.Dependencies) -> BaseViewController {
        HomeViewController.instantiate(with: dependencies)
    }
    
    func makePlayerListViewController(with dependencies: PlayerListViewController.Dependencies) -> BaseViewController {
        PlayerListViewController.instantiate(with: dependencies)
    }
    
    func makePlayerAddEditViewController(with dependencies: PlayerAddEditViewController.Dependencies) -> BaseViewController {
        PlayerAddEditViewController.instantiate(with: dependencies)
    }

    func makeTournamentBracketViewController(with dependencies: TournamentBracketViewController.Dependencies) -> BaseViewController {
        TournamentBracketViewController.instantiate(with: dependencies)
    }
    
    func makePlayerViewController(with dependencies: PlayerViewController.Dependencies) -> BaseViewController {
        PlayerViewController.instantiate(with: dependencies)
    }
}
