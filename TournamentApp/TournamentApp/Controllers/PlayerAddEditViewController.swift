//
//  PlayerAddEditViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit

class PlayerAddEditViewController: BaseViewController {

    // MARK: - Variable
    
    static let storyboardIdentifier = "PlayerAddEditViewController"
    var typeOfVC: TypeViewController = .add
    
    
    enum TypeViewController {
        case edit, add
        
        var valueTitle: String {
            switch self {
            case .add:
                return "Add"
            case .edit:
                return "Edit"
            }
        }
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.typeOfVC.valueTitle
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action:#selector(didTapDoneButton)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        self.closeViewController()
    }

}
