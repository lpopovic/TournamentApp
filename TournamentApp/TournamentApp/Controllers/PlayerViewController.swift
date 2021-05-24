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
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var refresher : UIRefreshControl!
    
    // MARK: - Variable
    
    static let storyboardIdentifier = "PlayerViewController"
    var playerId: Int?
    var playerDetailInfo: PlayerDetail?
    weak var delegate: PlayerViewControllerDelegate?
    var isPlayerEdit = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Player"
        self.setupSpinner()
        self.setupTableView()
        self.setupRefreshControl()
        
        self.spinner.startAnimating()
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.spinner.center = self.view.center
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent, self.isPlayerEdit == true, let id = self.playerId, let player = self.playerDetailInfo {
            self.delegate?.playerIsUpdated(with: id, player: player)
        }
    }
    
    // MARK: - UI
    
    func setupNavigationButtons() {
        if let player = self.playerDetailInfo, player.tournament_id == GlobalConstants.tournomentId {
            let deleteButton = UIBarButtonItem(
                title: "Delete",
                style: .done,
                target: self,
                action: #selector(didTapDeleteButton)
            )
            let editButton = UIBarButtonItem(
                image: UIImage(systemName: "pencil"),
                style: .done,
                target: self,
                action:#selector(didTapEditButton)
            )
            navigationItem.rightBarButtonItems = [deleteButton, editButton]
        }
       
    }
    
    private func setupSpinner() {
        self.spinner.tintColor = .label
        self.spinner.hidesWhenStopped = true
        self.spinner.style = .large
    }
    
    private func setupRefreshControl() {
        self.refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        self.refresher.tintColor = .label
        self.refresher.addTarget(self, action: #selector(didSwipeRefresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: PlayerInfoTableCell.identifier, bundle: nil),
                                forCellReuseIdentifier: PlayerInfoTableCell.identifier)
        self.tableView.register(UINib(nibName: BioTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: BioTableViewCell.identifier)
        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    // MARK: - Actions
    
    @objc private func didTapDeleteButton() {
        self.showDialogForDeletePlayer()
    }
    
    @objc private func didTapEditButton() {
        guard let vc = storyboardMain.instantiateViewController(withIdentifier: PlayerAddEditViewController.storyboardIdentifier) as? PlayerAddEditViewController else { return }
        vc.typeOfVC = .edit
        vc.playerId = self.playerId
        vc.playerDetailInfo = self.playerDetailInfo
        vc.delegate = self
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
    @objc private func didSwipeRefresh() {
        self.refresher.beginRefreshing()
        self.fetchData()
    }
    
    func fetchData() {
        guard let id = self.playerId else {
            return
        }
        ApiCaller.shared.getDetailPlayer(with: id) { [weak self] (result) in
            switch result {
            case.success(let model):
                self?.playerDetailInfo = model
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                    self?.setupNavigationButtons()
                    self?.refresher.endRefreshing()
                }
            case .failure(let error):
                self?.playerDetailInfo = nil
                DispatchQueue.main.async {
                    UIAlertController.showAlertUserMessage(self, title: nil, message: error.localizedDescription)
                    self?.spinner.stopAnimating()
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                    self?.refresher.endRefreshing()
                }
            }
        }
    }
    
    func fetchDeleteData() {
        guard let id = self.playerId else {
            return
        }
        self.spinner.startAnimating()
        ApiCaller.shared.deletePlayer(with: id) {[weak self] (result) in
            self?.spinner.stopAnimating()
            switch result {
            case .success(let message):
                let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self?.delegate?.playerIsDeleted(with: id)
                    self?.closeViewController()
                })
                
                UIAlertController.showAlertUserMessage(
                    self,
                    title: "Successfully",
                    message: message,
                    action: action
                )
            case .failure(let error):
                DispatchQueue.main.async {
                    UIAlertController.showAlertUserMessage(
                        self,
                        title: nil,
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
    
    func showDialogForDeletePlayer() {
        let alert = UIAlertController(title: "Are you sure?", message: "You can't undo this action.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.fetchDeleteData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerDetailInfo != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerInfoTableCell.identifier) as? PlayerInfoTableCell,
                  let model = self.playerDetailInfo else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BioTableViewCell.identifier) as? BioTableViewCell,
                  let model = self.playerDetailInfo else {
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
    func playerIsCreated() {}
    
    func playerIsEdited(player: PlayerDetail) {
        guard let id = self.playerId else {
            return
        }
        self.isPlayerEdit = true
        self.playerDetailInfo = player
        self.tableView.reloadData()
    }
    
    
}
