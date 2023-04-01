//
//  DefaultAlert.swift
//  HRManager
//
//  Created by Lazar Popovic on 4.11.21..
//  Copyright © 2021 HTEC. All rights reserved.
//

import UIKit

struct DefaultAlert: Alert {
    var title: String?
    var message: String?
    var completion: NoArgsClosure?
    
    init(title: String?, message: String?, completion: NoArgsClosure? = nil) {
        self.message = message
        self.title = title
        self.completion = completion
    }
    
    func getActions() -> [UIAlertAction] {
        [
            UIAlertAction(
                title: "OK",
                style: .default)
            { _ in
                self.completion?()
            }
        ]
    }
}
