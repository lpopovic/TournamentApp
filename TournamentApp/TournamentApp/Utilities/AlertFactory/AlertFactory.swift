//
//  AlertFactory.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 5.4.23..
//

import UIKit

protocol AlertFactoryProvider {
    func presentAlertController(
        from presenter: PresentableProvider,
        with alert: Alert,
        animated: Bool,
        completion: NoArgsClosure?
    )
}

class AlertFactory: AlertFactoryProvider {
    struct PropertyConstants {
        static let alertControllerType = UIAlertController.self
    }
    
    func presentAlertController(
        from presenter: PresentableProvider,
        with alert: Alert,
        animated: Bool = true,
        completion: NoArgsClosure? = nil
    ) {
        guard let alertController = createAlertController(from: alert) else { return }
        presenter.present(
            alertController,
            animated: animated,
            completion: completion
        )
    }
    
    private func createAlertController(from alert: Alert) -> UIAlertController? {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: alert.style
        )
        alert.getActions().forEach { alertController.addAction($0) }
        return alertController.actions.count > 0 ? alertController : nil
    }
}
