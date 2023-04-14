//
//  Extensions+UIWindow.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import UIKit

protocol WindowProvider: AnyObject {
    var rootViewController: UIViewController? { get set }
    func makeKeyAndVisible()
}

extension UIWindow: WindowProvider { }
