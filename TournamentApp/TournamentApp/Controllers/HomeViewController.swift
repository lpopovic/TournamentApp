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
    public let viewModel = HomeViewModel()
    private let hapticsManager: HapticsManager = .shared
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: - UI
    
    private func setupViews() {
        self.title = viewModel.navigationBarTitle
        self.setupShowPlayerListButton()
        self.setupImageView()
        self.setupNameOfTournomentButton()
    }
    
    private func setupShowPlayerListButton() {
        self.showPlayerListButton.setTitle(viewModel.playerListButtonTitle, for: .normal)
        self.showPlayerListButton.setTitleColor(.systemBlue, for: .normal)
        self.showPlayerListButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        self.showPlayerListButton.titleLabel?.textAlignment = .center
        self.showPlayerListButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    private func setupImageView() {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = viewModel.serbianOpenLogoImage.value
    }
    
    private func setupNameOfTournomentButton() {
        self.nameOfTournomentButton.setTitle(viewModel.nameOfTournomentTitle, for: .normal)
        self.nameOfTournomentButton.setTitleColor(.label, for: .normal)
        self.nameOfTournomentButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        self.nameOfTournomentButton.titleLabel?.numberOfLines = 1
        self.nameOfTournomentButton.titleLabel?.textAlignment = .center
        self.nameOfTournomentButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func didTap(_ sender: UIButton) {
        self.hapticsManager.vibrateForSelection()
        self.pushPlayerListViewController()
    }
    
    private func pushPlayerListViewController() {
        viewModel.showPlayerListScreen?()
        let vc = storyboardMain.instantiateViewController(withIdentifier: PlayerListViewController.storyboardIdentifier)
        guard let nvc = self.navigationController else { return }
        nvc.pushViewController(vc, animated: true)
    }
}
