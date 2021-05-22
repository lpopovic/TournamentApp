//
//  BaseViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Variable
    let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
    
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

}
