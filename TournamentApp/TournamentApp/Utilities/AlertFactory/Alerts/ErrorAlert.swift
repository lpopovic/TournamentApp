//
//  ErrorAlert.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 5.4.23..
//

import UIKit

struct ErrorAlert: Alert {
    var title: String? = "ERROR"
    var message: String?
    var completion: NoArgsClosure?
    
    init(message: String?, completion: NoArgsClosure? = nil) {
        self.completion = completion
        self.message = message
    }
    
    func getActions() -> [UIAlertAction] {
        [
            UIAlertAction(
                title: "OK",
                style: .default
            ) { _ in
                self.completion?()
            }
        ]
    }
}
