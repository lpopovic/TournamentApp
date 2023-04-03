//
//  Router.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 31.3.23..
//

import UIKit

public protocol Router: AnyObject {
    func present(_ viewController: UIViewController,
                 animated: Bool)
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 onDismissed: NoArgsClosure?)
    func dismiss(animated: Bool)
}

extension Router {
    
    public func present(_ viewController: UIViewController,
                        animated: Bool) {
        present(viewController,
                animated: animated,
                onDismissed: nil)
    }
}
