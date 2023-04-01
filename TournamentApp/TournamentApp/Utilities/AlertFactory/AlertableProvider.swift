//
//  AlertableProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

protocol AlertableProvider {
    func presentAlert(
        with alert: Alert,
        animated: Bool,
        completion: NoArgsClosure?
    )
}

extension UIViewController: AlertableProvider {
    func presentAlert(
        with alert: Alert,
        animated: Bool = true,
        completion: NoArgsClosure? = nil
    ) {
        AlertFactory()
            .presentAlertController(
                from: self,
                with: alert,
                animated: animated,
                completion: completion)
    }
}
