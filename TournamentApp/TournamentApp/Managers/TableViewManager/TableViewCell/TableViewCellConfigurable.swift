//
//  TableViewCellConfigurable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import Foundation

protocol TableViewCellConfigurable {
    associatedtype Model: TableViewCellModelProvider
    associatedtype CellDelegate
    static var height: CGFloat { get  set }
    func fill(with model: Model)
    func setup(_ delegate: CellDelegate?)
}

extension TableViewCellConfigurable {
    func setup(_ delegate: Self?) { }
}
