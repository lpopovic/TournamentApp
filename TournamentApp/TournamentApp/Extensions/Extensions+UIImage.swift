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
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }

}


