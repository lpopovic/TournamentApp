//
//  AppearanceAppDelegate.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import Foundation

final class AppearanceAppDelegate: NSObject {
    
    // MARK: - Properties
    
    let appDIContainer: AppDependencyContainer
    var window: WindowProvider?
    
    // MARK: Private
    // MARK: - Initialization
    
    init(window: WindowProvider?, appDIContainer: AppDependencyContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
}

extension AppearanceAppDelegate: AppDelegateBehavior {
    func application(_ application: ApplicationProvider, didFinishLaunchingWithOptions launchOptions: [LaunchOptionsKey: Any]?) {
        
    }
}

