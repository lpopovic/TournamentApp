//
//  AlertableProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import Foundation

protocol AlertableProvider {
    func presentAlert(
        with alert: Alert,
        animated: Bool,
        completion: NoArgsClosure?
    )
}

extension BaseViewController: AlertableProvider {
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
