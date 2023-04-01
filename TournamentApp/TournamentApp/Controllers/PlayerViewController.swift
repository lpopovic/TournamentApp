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

class PlayerViewController: BaseViewController {
    
    // MARK: - Properties
    // MARK: Public
    
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: Private
    // Variable
    private let viewModel: PlayerViewModel
    private let hapticsManager: HapticsManagerProvider
    private let localImage: LocalImage.Type = LocalImage.self
    
    // IBOutlet
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: PlayerViewModel, hapticsManager: HapticsManagerProvider) {
        self.viewModel = viewModel
        self.hapticsManager = hapticsManager
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
                self.refresher.endRefreshing()
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
                self.tableView.reloadData()
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
        setupRefreshControl()
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
    
    private func setupRefreshControl() {
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                       attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        refresher.tintColor = .label
        refresher.addTarget(self,
                            action: #selector(didSwipeRefresh),
                            for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: PlayerInfoTableCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PlayerInfoTableCell.identifier)
        tableView.register(UINib(nibName: BioTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: BioTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refresher)
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
        let viewModel = PlayerAddEditViewModel(typeOfVC: .edit,
                                               playerId: playerId,
                                               playerDetailInfo: playerDetailInfo)
        let playerAddEditViewController = PlayerAddEditViewController.instantiate(viewModel: viewModel,
                                                                                  hapticsManager: hapticsManager,
                                                                                  delegate: self)
        navigationController?.pushViewController(playerAddEditViewController, animated: true)
    }
    
    @objc private func didSwipeRefresh() {
        refresher.beginRefreshing()
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
            self.closeViewController()
        }
        let alert = DefaultAlert(title: "Successfully", message: message, completion: action)
        presentAlert(with: alert)
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.playerDetailInfo != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerInfoTableCell.identifier) as? PlayerInfoTableCell,
                  let model = viewModel.playerDetailInfo else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BioTableViewCell.identifier) as? BioTableViewCell,
                  let model = viewModel.playerDetailInfo else {
                return UITableViewCell()
            }
            cell.configure(with: "Bio", bio: model.description)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    public class func instantiate(viewModel: PlayerViewModel,
                                  hapticsManager: HapticsManagerProvider,
                                  delegate: PlayerViewControllerDelegate?) -> PlayerViewController {
        let playerViewController = instanceFromStoryboard(nil) { coder -> PlayerViewController? in
            PlayerViewController(coder: coder, viewModel: viewModel, hapticsManager: hapticsManager)
        }
        playerViewController.delegate = delegate
        return playerViewController
    }
}
