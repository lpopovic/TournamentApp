//
//  PlayerListViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerListViewController: UIViewController {
    
    // MARK: - Variable
    static let storyboardIdentifier = "PlayerListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Player List"
        self.navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = .systemBackground
        
    }
    
}
