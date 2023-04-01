//
//  PlayerListViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerListViewController: BaseViewController {
    
    // MARK: - Properties
    // MARK: Private

    //Variable
    private let viewModel: PlayerListViewModel
    private let hapticsManager: HapticsManagerProvider
    
    // IBOutlet
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
   
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: PlayerListViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
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
                self.refreshControl.endRefreshing()
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
        setupRefreshControl()
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
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: viewModel.refreshViewTitle,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        refreshControl.tintColor = .label
        refreshControl.addTarget(self,
                                 action: #selector(didSwipeRefresh),
                                 for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: PlayerTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: PlayerTableViewCell.identifier)
        tableView.separatorColor = .label
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refreshControl)
    }
    
    // MARK: Actions
    
    @objc private func didTapAddPlayerButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hapticsManager.vibrateForSelection()
            self.pushPlayerAddEditViewController()
        }
    }
    
    @objc private func didTapAddDrawButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hapticsManager.vibrateForSelection()
            self.pushTournamentBracketViewController()
        }
    }
    
    @objc private func didSwipeRefresh() {
        self.viewModel.fetchInitData()
    }
    
    // MARK: Other
    
    private func pushPlayerViewController(with model: Player) {
        let playerViewController = PlayerViewController.instantiate(viewModel: PlayerViewModel(playerId: model.id),
                                                                    hapticsManager: hapticsManager,
                                                                    delegate: self)
        navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    private func pushPlayerAddEditViewController() {
        let viewModel = PlayerAddEditViewModel(typeOfVC: .add)
        let playerAddEditViewController = PlayerAddEditViewController.instantiate(viewModel: viewModel,
                                                                                  hapticsManager: hapticsManager,
                                                                                  delegate: self)
        navigationController?.pushViewController(playerAddEditViewController, animated: true)
    }
    
    func pushTournamentBracketViewController() {
        guard let playersForDraw: [Player] = viewModel.getItemsForBracket(),
              let nvc = self.navigationController
        else { return }
        let tournamentBracketViewController = TournamentBracketViewController.instantiate(playerList: playersForDraw)
        nvc.pushViewController(tournamentBracketViewController, animated: true)
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
           viewModel.checkIfCanLoadMore() {
            viewModel.fetchMoreData()
        }
    }
}

// MARK: UITableViewDelegate

extension PlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath.row)
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
    func playerIsCreated() {
        viewModel.fetchInitData()
    }

    func playerIsEdited(player: PlayerDetail) { }

}

// MARK: - StoryboardInstantiable
extension PlayerListViewController: StoryboardInstantiable {
    public class func instantiate(viewModel: PlayerListViewModel,
                                  hapticsManager: HapticsManagerProvider) -> PlayerListViewController {
        let playerListViewController = instanceFromStoryboard(nil) { coder -> PlayerListViewController? in
            PlayerListViewController(coder: coder, viewModel: viewModel, hapticsManager: hapticsManager)
        }
        return playerListViewController
    }
}
