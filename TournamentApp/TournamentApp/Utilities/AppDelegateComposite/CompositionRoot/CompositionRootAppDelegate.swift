//
//  CompositionRootAppDelegate.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import Foundation

final class CompositionRootAppDelegate {
    
    // MARK: - Properties
    
    let startup: AppDelegateBehavior
    let appearance: AppDelegateBehavior
    let broadcastable: AppDelegateBehavior

    // MARK: - Initialization
    
    init(window: WindowProvider?, appDIContainer: AppDependencyContainer) {
        self.startup = StartupAppDelegate(window: window, appDIContainer: appDIContainer)
        self.appearance = AppearanceAppDelegate(window: window, appDIContainer: appDIContainer)
        let appDelegates = [self.startup, self.appearance]
        self.broadcastable = BroadcastableAppDelegate(appDelegates: appDelegates)
    }
}
