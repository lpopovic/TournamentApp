//
//  PresentableProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

protocol PresentableProvider {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: PresentableProvider { }
