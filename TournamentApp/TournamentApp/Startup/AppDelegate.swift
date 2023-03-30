//
//  AppDelegate.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboardMain.instantiateViewController(withIdentifier: HomeViewController.storyboardIdentifier)
        let navigationViewController = NavigationViewController(rootViewController: homeViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        return true
    }
}

