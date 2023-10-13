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

  func present(animated: Bool, onDismissed: NoArgsClosure?)
  func dismiss(animated: Bool)
  func presentChild(_ child: Coordinator,
                    animated: Bool,
                    onDismissed: NoArgsClosure?)
}

extension Coordinator {

  public func dismiss(animated: Bool) {
    router.dismiss(animated: animated)
  }

  public func presentChild(_ child: Coordinator,
                           animated: Bool,
                           onDismissed: NoArgsClosure? = nil) {
    children.append(child)
    child.present(animated: animated, onDismissed: { [weak self, weak child] in
      guard let self = self, let child = child else { return }
      self.removeChild(child)
      onDismissed?()
    })
  }

  private func removeChild(_ child: Coordinator) {
    guard let index = children.firstIndex(where:  { $0 === child })
      else {
        return
    }
    children.remove(at: index)
  }
}
