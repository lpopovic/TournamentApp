//
//  HomeViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var showPlayerListButton: UIButton!
    @IBOutlet weak var nameOfTournomentButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variable
    
    static let storyboardIdentifier = "HomeViewController"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        
        self.setupShowPlayerListButton()
        self.setupImageView()
        self.setupNameOfTournomentButton()
        
    }
    
    // MARK: - UI
    
    private func setupShowPlayerListButton() {
        self.showPlayerListButton.setTitle("See list of players", for: .normal)
        self.showPlayerListButton.setTitleColor(.systemBlue, for: .normal)
        self.showPlayerListButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        self.showPlayerListButton.titleLabel?.textAlignment = .center
        self.showPlayerListButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage.LocalImage.serbianOpenLogo.value
    }
    
    private func setupNameOfTournomentButton() {
        self.nameOfTournomentButton.setTitle("Serbian Open", for: .normal)
        self.nameOfTournomentButton.setTitleColor(.label, for: .normal)
        self.nameOfTournomentButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        self.nameOfTournomentButton.titleLabel?.numberOfLines = 1
        self.nameOfTournomentButton.titleLabel?.textAlignment = .center
        self.nameOfTournomentButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func didTap(_ sender: UIButton) {
       
        let vc = storyboardMain.instantiateViewController(withIdentifier: TournamentBracketViewController.storyboardIdentifier)
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
    }
    
    
}
