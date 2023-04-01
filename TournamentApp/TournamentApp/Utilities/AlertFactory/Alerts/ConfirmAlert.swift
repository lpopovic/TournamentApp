//
//  ConfirmAlert.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

struct ConfirmAlert: Alert {
    var title: String?
    var message: String?
    var completion: ((Bool) -> Void)?
    
    init(title: String?, message: String?, completion: ((Bool) -> Void)?) {
        self.title = title
        self.message = message
        self.completion = completion
    }
    
    func getActions() -> [UIAlertAction] {
        [
            UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { _ in completion?(true) }
            ),
            UIAlertAction(
                title: "No",
                style: .cancel,
                handler: { _ in completion?(false) }
            )
        ]
    }
}
