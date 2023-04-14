//
//  AppDelegateRouter.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

public class AppDelegateRouter: NSObject {
    
    let window: WindowProvider?
    
    init(window: WindowProvider?) {
        self.window = window
    }
}

extension AppDelegateRouter: Router {
    public func present(_ viewController: UIViewController,
                        animated: Bool,
                        onDismissed: (()->Void)?) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    public func dismiss(animated: Bool) { }
}
