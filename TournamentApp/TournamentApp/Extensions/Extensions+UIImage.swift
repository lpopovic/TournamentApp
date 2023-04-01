//
//  Extensions+UIImage.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

extension UIImage {
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

enum LocalImage {
    case serbianOpenLogo
    case photo
    case personFill
    
    var value: UIImage? {
        switch self {
        case .serbianOpenLogo:
            return UIImage(named: "serbianOpenLogo")
        case .photo:
            return UIImage(systemName: "photo")
        case .personFill:
            return UIImage(systemName: "person.fill")
        }
    }
}

