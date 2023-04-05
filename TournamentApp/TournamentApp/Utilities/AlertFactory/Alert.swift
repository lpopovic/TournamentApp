//
//  Alert.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 5.4.23..
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
