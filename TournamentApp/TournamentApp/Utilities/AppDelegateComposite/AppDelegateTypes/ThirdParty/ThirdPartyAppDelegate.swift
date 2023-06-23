//
//  ThirdPartyAppDelegate.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 21.6.23..
//

import Foundation

final class ThirdPartyAppDelegate: NSObject {
    
    // MARK: - Properties
    
    let appDIContainer: AppDependencyContainer
    var window: WindowProvider?
    
    private let debuggingNetworkManager: DebuggingNetworkManagerProvider
    
    // MARK: Private
    // MARK: - Initialization
    
    init(window: WindowProvider?, appDIContainer: AppDependencyContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
        self.debuggingNetworkManager = appDIContainer.debuggingNetworkManager
    }
}

extension ThirdPartyAppDelegate: AppDelegateBehavior {
    func application(_ application: ApplicationProvider, didFinishLaunchingWithOptions launchOptions: [LaunchOptionsKey: Any]?) {
        debuggingNetworkManager.start()
    }
}
