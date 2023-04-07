//
//  ViewLoadable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

protocol ViewLoadable: NibLoadable {
    static var instance: Self { get }
}

extension ViewLoadable {
    static var instance: Self {
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Failed to create an instance of \(self) from \(self.nibName) nib.")
        }
        return view
    }
}
