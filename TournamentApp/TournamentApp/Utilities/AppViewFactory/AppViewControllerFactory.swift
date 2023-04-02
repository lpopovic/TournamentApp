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
//    func makePlayerViewController() -> UIViewController
//    func makePlayerAddEditViewController() -> UIViewController
//    func makeTournamentBracketViewController() -> UIViewController
}

class AppViewControllerFactory: AppViewControllerFactoryProvider {
    func makeHomeViewController(with dependencies: HomeViewController.Dependencies) -> BaseViewController {
        HomeViewController.instantiate(with: dependencies)
    }
    
    func makePlayerListViewController(with dependencies: PlayerListViewController.Dependencies) -> BaseViewController {
        PlayerListViewController.instantiate(with: dependencies)
    }
    
//    func makePlayerViewController() -> UIViewController {
//
//    }
//
//    func makePlayerAddEditViewController() -> UIViewController {
//
//    }
//
//    func makeTournamentBracketViewController() -> UIViewController {
//
//    }
}
