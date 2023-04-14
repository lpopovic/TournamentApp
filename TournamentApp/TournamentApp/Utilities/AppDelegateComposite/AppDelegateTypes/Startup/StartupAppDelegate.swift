//
//  StartupAppDelegate.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 14.4.23..
//

import Foundation

final class StartupAppDelegate: NSObject {
    
    // MARK: - Properties
    
    let appDIContainer: AppDependencyContainer
    var window: WindowProvider?
    public lazy var router = AppDelegateRouter(window: window)
    public lazy var appMainCoordinator = AppMainCoordinator(router: router,
                                                            appDIContainer: appDIContainer)

    // MARK: - Initialization
    
    init(window: WindowProvider?, appDIContainer: AppDependencyContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
}

extension StartupAppDelegate: AppDelegateBehavior {
    func application(_ application: ApplicationProvider, didFinishLaunchingWithOptions launchOptions: [LaunchOptionsKey: Any]?) {
        appMainCoordinator.present(animated: true, onDismissed: nil)
    }
}
