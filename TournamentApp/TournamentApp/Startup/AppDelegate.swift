//
//  AppDelegate.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    public lazy var appDIContainer = AppDependencyContainer()
    public lazy var router = AppDelegateRouter(window: window!)
    public lazy var appMainCoordinator = AppMainCoordinator(router: router, appDIContainer: appDIContainer)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        appMainCoordinator.present(animated: true, onDismissed: nil)
        return true
    }
}

