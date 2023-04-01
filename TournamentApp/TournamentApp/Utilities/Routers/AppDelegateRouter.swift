//
//  AppDelegateRouter.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

public class AppDelegateRouter: AnyObject {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension AppDelegateRouter: Router {
    func present(_ viewController: UIViewController,
                      animated: Bool,
                      onDismissed: (()->Void)?) {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }
    
   func dismiss(animated: Bool) { }
}
