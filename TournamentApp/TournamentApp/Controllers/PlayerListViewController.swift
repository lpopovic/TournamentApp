//
//  PlayerListViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerListViewController: BaseViewController {
    
    // MARK: - Properties
    
    static let storyboardIdentifier = "PlayerListViewController"
    
    // MARK: IBOutlet
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    private var refresher: UIRefreshControl!
    
    // MARK: Variable
    
    private let viewModel = PlayerListViewModel()
    private let hapticsManager: HapticsManager = .shared
    private let alertController: UIAlertController.Type = UIAlertController.self
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.setupViews()
        self.getInitPlayerList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.spinner.center = self.view.center
    }
    
    // MARK: - Private methods
    
    private func setupViewModel() {
        viewModel.hideProgress = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.refresher.endRefreshing()
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
                self.tableView.reloadData()
            }
        }
        viewModel.onSelectItem = { [weak self] item in
            guard let self else { return }
            DispatchQueue.main.async {
                self.pushPlayerViewController(with: item)
            }
        }
    }
    
    // MARK: UI
    
    private func setupViews() {
        self.setupVC()
        self.setupSpinner()
        self.setupTableView()
        self.setupRefreshControl()
    }
    
    private func setupVC() {
        self.title = viewModel.navigationTitle
        self.view.backgroundColor = .systemBackground
        
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
        self.spinner.tintColor = .label
        self.spinner.hidesWhenStopped = true
        self.spinner.style = .large
    }
    
    private func setupRefreshControl() {
        self.refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        self.refresher.attributedTitle = NSAttributedString(string: viewModel.refreshViewTitle,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        self.refresher.tintColor = .label
        self.refresher.addTarget(self, action: #selector(didSwipeRefresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: PlayerTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: PlayerTableViewCell.identifier)
        self.tableView.separatorColor = .label
        self.tableView.backgroundColor = .systemBackground
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // MARK: Actions
    
    @objc private func didTapAddPlayerButton() {
        DispatchQueue.main.async { [weak self] in
            self?.hapticsManager.vibrateForSelection()
            self?.pushPlayerAddEditViewController()
        }
    }
    
    @objc private func didTapAddDrawButton() {
        hapticsManager.vibrateForSelection()
        self.pushTournamentBracketViewController()
    }
    
    private func pushPlayerViewController(with model: Player) {
        guard let vc = storyboardMain.instantiateViewController(
            withIdentifier: PlayerViewController.storyboardIdentifier
        ) as? PlayerViewController else { return }
        vc.playerId = model.id
        vc.delegate = self
        guard let nvc = self.navigationController else { return }
        nvc.pushViewController(vc, animated: true)
    }
    
    private func pushPlayerAddEditViewController() {
        guard let vc = self.storyboardMain.instantiateViewController(withIdentifier: PlayerAddEditViewController.storyboardIdentifier) as? PlayerAddEditViewController else { return }
        vc.typeOfVC = .add
        vc.delegate = self
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
    func pushTournamentBracketViewController() {
        guard let playersForDraw: [Player] = viewModel.getItemsForBracket(),
              let nvc = self.navigationController,
              let vc = storyboardMain.instantiateViewController(withIdentifier: TournamentBracketViewController.storyboardIdentifier) as? TournamentBracketViewController
        else { return }
        vc.playerList = playersForDraw
        nvc.pushViewController(vc, animated: true)
    }
    
    @objc private func didSwipeRefresh() {
        self.viewModel.fetchInitData()
    }
    
    private func getInitPlayerList() {
        self.viewModel.fetchInitData()
    }
}

// MARK: - Delegates
// MARK: UITableViewDataSource

extension PlayerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (model, rank) = viewModel.getItem(at: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier) as? PlayerTableViewCell
        else { return UITableViewCell() }
        cell.configure(with: model, rank)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex,
            indexPath.row == lastRowIndex,
           !self.viewModel.isMoreLoading {
            self.viewModel.fetchMoreData()
        }
    }
}

// MARK: UITableViewDelegate

extension PlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.didSelectItem(at: indexPath.row)
        hapticsManager.vibrateForSelection()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

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
    func playerIsEdited(player: PlayerDetail) { }
    
    func playerIsCreated() {
        self.getInitPlayerList()
    }
}
