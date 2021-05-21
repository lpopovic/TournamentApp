//
//  Extensions+UIImage.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

extension UIImage {
    enum LocalImage {
        case serbianOpenLogo
        
        var value: UIImage? {
            get {
                switch self {
                case .serbianOpenLogo:
                    return UIImage(named: "serbianOpenLogo")
                }
            }
        }
    }
}


