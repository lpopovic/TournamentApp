//
//  TableViewHeaderConfigurable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import Foundation

protocol TableViewHeaderConfigurable {
    associatedtype Model
    associatedtype SectionDelegate
    typealias SectionKey = String
    static var height: CGFloat { get  set }
    func fill(with model: Model, key: SectionKey)
    func setup(_ delegate: SectionDelegate?)
}
