//
//  TableViewCellModelProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import Foundation

typealias RowKey = String

protocol TableViewCellModelProvider {
    var key: RowKey { get set }
}

