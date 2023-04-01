//
//  LocalImage.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import UIKit

enum LocalImage {
    case serbianOpenLogo
    case photo
    case personFill
    case pencil
    
    var value: UIImage? {
        switch self {
        case .serbianOpenLogo:
            return UIImage(named: "serbianOpenLogo")
        case .photo:
            return UIImage(systemName: "photo")
        case .personFill:
            return UIImage(systemName: "person.fill")
        case .pencil:
            return UIImage(systemName: "pencil")
        }
    }
}
