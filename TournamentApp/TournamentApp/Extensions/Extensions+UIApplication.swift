//
//  Extensions+UIApplication.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import UIKit

@objc protocol ApplicationProvider: AnyObject {
    var shortcutItems: [UIApplicationShortcutItem]? { get set }
    var shortcutItemLaunchOptionsKey: String { get }
}

extension UIApplication: ApplicationProvider {
    var shortcutItemLaunchOptionsKey: String {
        LaunchOptionsKey.shortcutItem.rawValue
    }
}
