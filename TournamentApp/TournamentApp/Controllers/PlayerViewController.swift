//
//  PlayerViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerViewController: BaseViewController {
    
    // MARK: - Variable
    static let storyboardIdentifier = "PlayerViewController"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Player"
        let deleteButton = UIBarButtonItem(
            title: "Delete",
            style: .done,
            target: self,
            action: #selector(didTapDeleteButton)
        )
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .done,
            target: self,
            action:#selector(didTapEditButton)
        )
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    // MARK: - Actions
    
    @objc private func didTapDeleteButton() {
        self.closeViewController()
    }
    
    @objc private func didTapEditButton() {
        guard let vc = storyboardMain.instantiateViewController(withIdentifier: PlayerAddEditViewController.storyboardIdentifier) as? PlayerAddEditViewController else { return }
        vc.typeOfVC = .edit
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
}
