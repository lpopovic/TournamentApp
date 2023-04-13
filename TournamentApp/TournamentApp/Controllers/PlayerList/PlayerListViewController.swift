//
//  PlayerListViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerListViewController: BaseViewController, Bindable {
    
    // MARK: - Properties
    // MARK: Private

    //Variable
    private let viewModel: PlayerListViewModel
    private let hapticsManager: HapticsManagerProvider
    private let tableViewManager: TableViewManager
    private let tableViewCells: [UITableViewCell.Type] = [PlayerTableViewCell.self]
    
    // IBOutlet
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
   
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: PlayerListViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
        self.tableViewManager = TableViewManager(dataSource: [])
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder::)` to initialize an `PlayerListViewController` instance.")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        viewModel.fetchInitData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = view.center
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel.hideProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
        viewModel.showProgress = { [weak self]  in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        }
        viewModel.reloadListView = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateTableViewManager()
            }
        }
        viewModel.onSelectItem = { [weak self] item in
            guard let self else { return }
            DispatchQueue.main.async {
                self.pushPlayerViewController(with: item)
            }
        }
        viewModel.onError = { [weak self] message in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentAlert(with: ErrorAlert(message: message))
                self.hapticsManager.vibrate(for: .error)
            }
        }
    }
    
    // MARK: UI
    
    private func setupViews() {
        setupNavigationBar()
        setupSpinner()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = viewModel.navigationTitle
        view.backgroundColor = .systemBackground
        let drawButton = UIBarButtonItem(
            title: viewModel.drawButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapAddDrawButton)
        )
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action:#selector(didTapAddPlayerButton)
        )
        navigationItem.rightBarButtonItems = [addButton, drawButton]
    }
    
    private func setupSpinner() {
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.style = .large
    }
    
    private func setupTableView() {
        setupTableViewManager()
        tableView.registerCells(tableViewCells)
        tableView.separatorColor = .label
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
    }
    
    private func setupTableViewManager() {
        tableViewManager.onReloadDataPresenter = weak(Function.reloadDataPresenterView)
        tableViewManager.onSwipeRefresh = weak(Function.swipeRefresh)
        tableViewManager.onReachEnd = weak(Function.reachEnd)
        tableViewManager.addRefreshController(to: tableView)
        tableViewManager.addFooterSpinner(to: tableView)
    }
    
    private func updateTableViewManager() {
        tableViewManager.update(with: viewModel.tableSections)
    }
    
    private func reloadDataPresenterView() {
        tableView.reloadData()
    }
    
    // MARK: Actions
    
    @objc private func didTapAddPlayerButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pushPlayerAddEditViewController()
        }
    }
    
    @objc private func didTapAddDrawButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pushTournamentBracketViewController()
        }
    }
    
    @objc private func swipeRefresh() {
        self.viewModel.fetchInitData()
    }
    
    @objc private func reachEnd() {
        if viewModel.checkIfCanLoadMore() {
            viewModel.fetchMoreData()
        }
    }
    
    // MARK: Other
    
    private func pushPlayerViewController(with model: Player) {
        hapticsManager.vibrateForSelection()
        viewModel.showPlayerScreen?(model.id)
    }
    
    private func pushPlayerAddEditViewController() {
        hapticsManager.vibrateForSelection()
        viewModel.showAddPlayerScreen?()
    }
    
    func pushTournamentBracketViewController() {
        hapticsManager.vibrateForSelection()
        viewModel.pushTournamentBracketViewController()
    }
}

// MARK: - Delegates
// MARK: PlayerViewControllerDelegate

extension PlayerListViewController: PlayerViewControllerDelegate {
    func playerIsUpdated(with id: Int, player: PlayerDetail) {
        viewModel.playerIsUpdated(with: id, player: player) { [weak self] index in
            guard let self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func playerIsDeleted(with id: Int) {
        viewModel.playerIsDeleted(id)
    }
}

// MARK: PlayerAddEditViewControllerDelegate

extension PlayerListViewController: PlayerAddEditViewControllerDelegate {
    func playerIsCreated() {
        viewModel.fetchInitData()
    }

    func playerIsEdited(player: PlayerDetail) { }
}

// MARK: - StoryboardInstantiable
extension PlayerListViewController: StoryboardInstantiable {
    struct Dependencies {
        let viewModel: PlayerListViewModel
        let hapticsManager: HapticsManagerProvider
    }
    
    public class func instantiate(with dependencies: Dependencies) -> PlayerListViewController {
        let playerListViewController = instanceFromStoryboard(nil) { coder -> PlayerListViewController? in
            PlayerListViewController(coder: coder, viewModel: dependencies.viewModel, hapticsManager: dependencies.hapticsManager)
        }
        return playerListViewController
    }
}
