//
//  TournamentBracketViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 2.4.23..
//

import Foundation

final class TournamentBracketViewModel {
    var playerList: [PlayerBaseInfo]
    
    init(playerList: [PlayerBaseInfo]) {
        self.playerList = playerList
    }
}
