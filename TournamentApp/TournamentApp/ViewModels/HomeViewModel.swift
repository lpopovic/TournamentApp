//
//  HomeViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

final class HomeViewModel {
    let navigationBarTitle = "Welcome"
    let playerListButtonTitle = "See list of players"
    let nameOfTournomentTitle = "Serbian Open"
    let serbianOpenLogoImage: LocalImage = .serbianOpenLogo
    
    var showPlayerListScreen: NoArgsClosure?
}
