//
//  Extensions+NSUserActivity.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import Foundation

@objc protocol UserActivityProvider {
    var webpageURL: URL? { get set }
}

extension NSUserActivity: UserActivityProvider { }
