//
//  BroadcastableAppDelegate.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import UIKit

class BroadcastableAppDelegate: NSObject {
    // MARK: - Properties

    // MARK: Private
   
    private let appDelegates: [AppDelegateBehavior]
    
    // MARK: - Initialization
    
    init(appDelegates: [AppDelegateBehavior]) {
        self.appDelegates = appDelegates
    }
}

// MARK: - AppDelegateProvider

extension BroadcastableAppDelegate: AppDelegateBehavior {
    func application(_ application: ApplicationProvider, didFinishLaunchingWithOptions launchOptions: [LaunchOptionsKey: Any]?) {
        appDelegates.forEach { $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
    }
    
    func application(_ app: ApplicationProvider, open url: URL, options: [OpenURLOptionsKey : Any] = [:]) -> Bool {
        var returnValue = false
        appDelegates.forEach { appDelegate in
            if let result = appDelegate.application?(app, open: url, options: options) {
                returnValue = result
                return
            }
        }
        return returnValue
    }
    
    func application(_ application: ApplicationProvider, continue userActivity: UserActivityProvider, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) {
        appDelegates.forEach { $0.application?(application, continue: userActivity, restorationHandler: restorationHandler) }
    }
    
    func applicationDidBecomeActive(_ application: ApplicationProvider) {
        appDelegates.forEach { $0.applicationDidBecomeActive?(application) }
    }
    
    func applicationWillResignActive(_ application: ApplicationProvider) {
        appDelegates.forEach { $0.applicationWillResignActive?(application) }
    }
    
    func application(_ application: ApplicationProvider, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        appDelegates.forEach { $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) }
    }
}
