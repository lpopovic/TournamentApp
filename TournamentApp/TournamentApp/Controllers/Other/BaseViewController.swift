//
//  BaseViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    
    func closeViewController() {
        guard let nvc = self.navigationController else {
            return
        }
        nvc.popViewController(animated: true)
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
