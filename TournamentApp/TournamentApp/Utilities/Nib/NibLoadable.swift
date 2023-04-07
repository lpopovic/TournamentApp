//
//  NibLoadable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}
