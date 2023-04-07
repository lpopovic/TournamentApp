//
//  PlayerViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

protocol PlayerViewControllerDelegate: AnyObject {
    func playerIsDeleted(with id: Int)
    func playerIsUpdated(with id: Int, player: PlayerDetail)
}

class PlayerViewController: BaseViewController, Bindable {
    
    // MARK: - Properties
    // MARK: Public
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: Private
    // Variable
    private let viewModel: PlayerViewModel
    private let hapticsManager: HapticsManagerProvider
    private let localImage: LocalImage.Type = LocalImage.self
    private let tableViewManager: TableViewManager
    private let tableViewCells: [UITableViewCell.Type] = [PlayerInfoTableCell.self,
                                                          BioTableViewCell.self]
    
    // IBOutlet
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: PlayerViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
        self.tableViewManager = TableViewManager(dataSource: [])
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder::)` to initialize an `PlayerViewController` instance.")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.spinner.center = self.view.center
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            viewModel.checkIfDataWasUpdated()
        }
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel.showProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        }
        viewModel.hideProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
        viewModel.showNavigationBar = {[weak self] show in
            guard let self else { return }
            DispatchQueue.main.async {
                self.setupNavigationButtons(show)
            }
        }
        viewModel.onError = { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentAlert(with: ErrorAlert(message: message))
                self.hapticsManager.vibrate(for: .error)
            }
        }
        viewModel.onDelete = { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.showAlertForSuccessDeletedPlayer(with: message)
                self.hapticsManager.vibrate(for: .success)
            }
        }
        viewModel.reloadListView = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateTableViewManager()
            }
        }
        viewModel.playerWasUpdated = {[weak self] player in
            guard let self else { return }
            self.delegate?.playerIsUpdated(with: self.viewModel.playerId,
                                           player: player)
        }
    }
    
    // MARK: UI
    
    private func setupViews() {
        title = "Player"
        setupSpinner()
        setupTableView()
        setupViewModel()
    }
    
    func setupNavigationButtons(_ show: Bool) {
        if show {
            let deleteButton = UIBarButtonItem(
                title: "Delete",
                style: .done,
                target: self,
                action: #selector(didTapDeleteButton)
            )
            let editButton = UIBarButtonItem(
                image: localImage.pencil.value,
                style: .done,
                target: self,
                action: #selector(didTapEditButton)
            )
            navigationItem.rightBarButtonItems = [deleteButton, editButton]
        } else {
            navigationItem.rightBarButtonItems = []
        }
    }
    
    private func setupSpinner() {
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.style = .large
    }
        
    private func setupTableView() {
        setupTableViewManager()
        tableView.registerCells(tableViewCells)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
    }
    
    private func setupTableViewManager() {
        tableViewManager.onReloadDataPresenter = weak(Function.reloadDataPresenterView)
        tableViewManager.onSwipeRefresh = weak(Function.swipeRefresh)
        tableViewManager.addRefreshController(to: tableView)
    }
    
    private func updateTableViewManager() {
        tableViewManager.update(with: viewModel.tableSections)
    }
    
    private func reloadDataPresenterView() {
        tableView.reloadData()
    }
    
    // MARK: Actions
    
    @objc private func didTapDeleteButton() {
        showDialogForDeletePlayer()
        hapticsManager.vibrateForSelection()
    }
    
    @objc private func didTapEditButton() {
        pushPlayerAddEditViewController(viewModel.playerId, viewModel.playerDetailInfo)
        hapticsManager.vibrateForSelection()
    }
    
    private func pushPlayerAddEditViewController(_ playerId: Int?, _ playerDetailInfo: PlayerDetail?) {
        viewModel.showEditPlayerScreen?((playerId, playerDetailInfo))
    }
    
    @objc private func swipeRefresh() {
        viewModel.fetchData(didSwipeRefresh: true)
    }
   
    func showDialogForDeletePlayer() {
        let alert = ConfirmAlert(title: "Are you sure?",
                                 message: "You can't undo this action.",
                                 completion: { [weak self] confirm in
            guard let self, confirm else { return }
            self.viewModel.fetchDeleteData()
        })
        presentAlert(with: alert)
    }
    
    func showAlertForSuccessDeletedPlayer(with message: String) {
        let action = { [weak self] in
            guard let self else { return }
            self.delegate?.playerIsDeleted(with: self.viewModel.playerId)
            self.viewModel.onCloseRequestScreen?(self)
        }
        let alert = DefaultAlert(title: "Successfully", message: message, completion: action)
        presentAlert(with: alert)
    }
}

extension PlayerViewController: PlayerAddEditViewControllerDelegate {
    func playerIsEdited(player: PlayerDetail) {
        viewModel.updated(player)
    }
    
    func playerIsCreated() {}
}

// MARK: - StoryboardInstantiable
extension PlayerViewController: StoryboardInstantiable {
    struct Dependencies {
        let viewModel: PlayerViewModel
        let hapticsManager: HapticsManagerProvider
        let delegate: PlayerViewControllerDelegate?
    }
   
    public class func instantiate(with dependencies: Dependencies) -> PlayerViewController {
        let playerViewController = instanceFromStoryboard(nil) { coder -> PlayerViewController? in
            PlayerViewController(coder: coder, viewModel: dependencies.viewModel, hapticsManager: dependencies.hapticsManager)
        }
        playerViewController.delegate = dependencies.delegate
        return playerViewController
    }

}
