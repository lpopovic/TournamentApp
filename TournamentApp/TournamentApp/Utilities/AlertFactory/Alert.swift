//
//  Alert.swift
//  HRManager
//
//  Created by Lazar Popovic on 1.11.21..
//  Copyright © 2021 HTEC. All rights reserved.
//

import UIKit

protocol Alert {
    var title: String? { get }
    var message: String? { get }
    var style: UIAlertController.Style { get }
    func getActions() -> [UIAlertAction]
}

extension Alert {
    var title: String? {
        nil
    }
    
    var message: String? {
        nil
    }
    
    var style: UIAlertController.Style {
        .alert
    }
}
