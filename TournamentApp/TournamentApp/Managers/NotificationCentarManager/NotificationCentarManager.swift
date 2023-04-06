//
//  NotificationCentarManager.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 6.4.23..
//

import Foundation

protocol NotificationCentarManagerProvider {
    typealias NotificationName = Notification.Name
    func post(with notificationName: NotificationName)
    func addObserver(_ observer: Any, selector aSelector: Selector, notificationName: NotificationName, object anObject: Any?)
    func removeObserver(_ observer: Any)
    func removeObserver(_ observer: Any, notificationName: NotificationName, object: Any?)
}

final class NotificationCentarManager {
    
    // MARK: - Properties
        
    private let notificationCenter: NotificationCenter

    // MARK: - Initialization
    
    init() {
        notificationCenter = .default
    }
}

// MARK: - NotificationCentarManagerProvider

extension NotificationCentarManager: NotificationCentarManagerProvider {
    func post(with notificationName: NotificationName) {
        notificationCenter.post(name: notificationName,
                                object: nil,
                                userInfo: nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector, notificationName: NotificationName, object: Any? = nil) {
        notificationCenter.addObserver(observer,
                                       selector: selector,
                                       name: notificationName,
                                       object: object)
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }

    func removeObserver(_ observer: Any, notificationName: NotificationName, object: Any? = nil) {
        notificationCenter.removeObserver(observer,
                                          name: notificationName,
                                          object: object)
    }
}
