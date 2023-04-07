//
//  TableViewHeaderProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

protocol TableViewHeaderProvider {
    var viewForHeaderInSection: UIView? { get }
    var heightForHeader: CGFloat { get }
}
