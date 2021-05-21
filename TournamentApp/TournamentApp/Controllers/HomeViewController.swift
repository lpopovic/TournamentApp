//
//  HomeViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var showPlayerListButton: UIButton!
    @IBOutlet weak var nameOfTournomentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variable
    static let storyboardIdentifier = "HomeViewController"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        self.navigationItem.largeTitleDisplayMode = .always

        self.view.backgroundColor = .systemBackground
        
        self.setupButton()
        self.setupImageView()
        self.setupLabel()
        
    }
    
    private func setupButton() {
        self.showPlayerListButton.setTitle("See list of players", for: .normal)
        self.showPlayerListButton.setTitleColor(.label, for: .normal)
        self.showPlayerListButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.showPlayerListButton.titleLabel?.textAlignment = .center
        self.showPlayerListButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage.LocalImage.serbianOpenLogo.value
    }
    
    private func setupLabel() {
        self.nameOfTournomentLabel.text = "Serbian Open"
        self.nameOfTournomentLabel.numberOfLines = 0
        self.nameOfTournomentLabel.textColor = .label
        self.nameOfTournomentLabel.font = .systemFont(ofSize: 19, weight: .bold)
    }
    
    // MARK: - Actions
    
    @objc private func didTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: PlayerListViewController.storyboardIdentifier)
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
        
    }
    
    
}
