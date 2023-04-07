//
//  Bindable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import Foundation

protocol Bindable: AnyObject {}

extension Bindable {
    
    typealias Function = Self
    
    func weak<Args>(_ method: @escaping ((Function) -> ((Args) -> Void))) -> ((Args) -> Void) {
        return { [weak self] arg in
            guard let `self` = self else { return }
            method(self)(arg)
        }
    }
    
    func weak(_ method: @escaping ((Function) -> (() -> Void))) -> (() -> Void) {
        return { [weak self]  in
            guard let `self` = self else { return }
            method(self)()
        }
    }
}
