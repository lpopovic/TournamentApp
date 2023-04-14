//
//  AppDelegate.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    
    public lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    public lazy var appDIContainer = AppDependencyContainer()
    public lazy var compositionRoot = CompositionRootAppDelegate(window: window, appDIContainer: appDIContainer)
}

extension AppDelegate {
    private func getLaunchOptionsWithStringKey(from launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> [String: Any]? {
        guard let launchOptions = launchOptions else { return nil }
        let tupleArray = launchOptions.map { (key: UIApplication.LaunchOptionsKey, value: Any) in
            return (key: key.rawValue, value)
        }
        return Dictionary(uniqueKeysWithValues: tupleArray)
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let launchOptionsWithStringKey = getLaunchOptionsWithStringKey(from: launchOptions)
        compositionRoot.broadcastable.application?(application, didFinishLaunchingWithOptions: launchOptionsWithStringKey)
        return true
    }
}

