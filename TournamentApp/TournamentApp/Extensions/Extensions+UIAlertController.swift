//
//  Extensions+UIAlertController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showApiCallerMessage(_ viewController: UIViewController?, title: String?, message: String) {
        let alertVC = UIAlertController(
            title: title ?? "Ooops",
            message: message,
            preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        guard let vc = viewController else { return  }
        vc.present(alertVC, animated: true, completion: nil)
    }
}
