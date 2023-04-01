//
//  Coordinator.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 31.3.23..
//

import Foundation

public protocol Coordinator: AnyObject {

  var children: [Coordinator] { get set }
  var router: Router { get }

  func present(animated: Bool, onDismissed: (() -> Void)?)
  func dismiss(animated: Bool)
  func presentChild(_ child: Coordinator,
                    animated: Bool,
                    onDismissed: (() -> Void)?)
}
