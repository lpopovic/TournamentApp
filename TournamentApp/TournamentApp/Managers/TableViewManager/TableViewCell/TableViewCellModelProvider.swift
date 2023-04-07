//
//  TableViewCellModelProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import Foundation

protocol TableViewCellModelProvider {
    var key: RowKey { get set }
}

typealias RowKey = String
