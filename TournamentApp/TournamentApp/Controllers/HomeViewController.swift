//
//  HomeViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: Private
    
    // Variable
    private let viewModel: HomeViewModel
    private let hapticsManager: HapticsManagerProvider
    
    // IBOutlet
    @IBOutlet private weak var showPlayerListButton: UIButton!
    @IBOutlet private weak var nameOfTournomentButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: HomeViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder::)` to initialize an `HomeViewController` instance.")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private methods
    // MARK: UI
    
    private func setupViews() {
        title = viewModel.navigationBarTitle
        setupShowPlayerListButton()
        setupImageView()
        setupNameOfTournomentButton()
    }
    
    private func setupShowPlayerListButton() {
        showPlayerListButton.setTitle(viewModel.playerListButtonTitle,
                                      for: .normal)
        showPlayerListButton.setTitleColor(.systemBlue,
                                           for: .normal)
        showPlayerListButton.titleLabel?.font = .systemFont(ofSize: 18,
                                                            weight: .bold)
        showPlayerListButton.titleLabel?.textAlignment = .center
        showPlayerListButton.addTarget(self,
                                       action: #selector(didTapNameOfTournomentButton(_:)),
                                       for: .touchUpInside)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = viewModel.serbianOpenLogoImage.value
    }
    
    private func setupNameOfTournomentButton() {
        nameOfTournomentButton.setTitle(viewModel.nameOfTournomentTitle,
                                        for: .normal)
        nameOfTournomentButton.setTitleColor(.label,
                                             for: .normal)
        nameOfTournomentButton.titleLabel?.font = .systemFont(ofSize: 20,
                                                              weight: .bold)
        nameOfTournomentButton.titleLabel?.numberOfLines = 1
        nameOfTournomentButton.titleLabel?.textAlignment = .center
        nameOfTournomentButton.addTarget(self,
                                         action: #selector(didTapNameOfTournomentButton(_:)),
                                         for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc private func didTapNameOfTournomentButton(_ sender: UIButton) {
        hapticsManager.vibrateForSelection()
        pushPlayerListViewController()
    }
    
    // MARK: Other
    
    private func pushPlayerListViewController() {
        viewModel.showPlayerListScreen?()
    }
}

// MARK: - Delegates
// MARK: StoryboardInstantiable
extension HomeViewController: StoryboardInstantiable {
    struct Dependencies {
        let viewModel: HomeViewModel
        let hapticsManager: HapticsManagerProvider
    }
    
    public class func instantiate(with dependencies: Dependencies) -> HomeViewController {
        let homeViewController = instanceFromStoryboard(nil) { coder -> HomeViewController? in
            HomeViewController(coder: coder, viewModel: dependencies.viewModel, hapticsManager: dependencies.hapticsManager)
        }
        return homeViewController
    }
}

