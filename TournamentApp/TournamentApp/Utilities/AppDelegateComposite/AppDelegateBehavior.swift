//
//  AppDelegateBehavior.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import UIKit

typealias LaunchOptionsKey = String
typealias OpenURLOptionsKey = String

@objc protocol AppDelegateBehavior {
    @objc optional func application(_ application: ApplicationProvider, didFinishLaunchingWithOptions launchOptions: [LaunchOptionsKey: Any]?)
    @objc optional func applicationDidBecomeActive(_ application: ApplicationProvider)
    @objc optional func applicationWillResignActive(_ application: ApplicationProvider)
    @objc optional func application(_ app: ApplicationProvider, open url: URL, options: [OpenURLOptionsKey : Any]) -> Bool
    @objc optional func application(_ application: ApplicationProvider, continue userActivity: UserActivityProvider, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void)
    @objc optional func application(_ application: ApplicationProvider, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void)
}
