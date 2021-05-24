//
//  PlayerListViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class PlayerListViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var refresher : UIRefreshControl!
    
    // MARK: - Variable
    
    static let storyboardIdentifier = "PlayerListViewController"
    var playerList: [Player] = [Player]()
    var page = 1
    let limit = 20
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVC()
        self.setupTableView()
        self.setupSpinner()
        self.setupRefreshControl()
        
        self.spinner.startAnimating()
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.spinner.center = self.view.center
    }
    
    // MARK: - UI
    
    private func setupVC() {
        self.title = "Player List"
        self.view.backgroundColor = .systemBackground
        
        let drawButton = UIBarButtonItem(
            title: "Draw",
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
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        self.refresher.tintColor = .label
        self.refresher.addTarget(self, action: #selector(didSwipeRefresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: PlayerTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: PlayerTableViewCell.identifier)
        self.tableView.separatorColor = .label
        self.tableView.backgroundColor = .systemBackground
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddPlayerButton() {
        guard let vc = storyboardMain.instantiateViewController(withIdentifier: PlayerAddEditViewController.storyboardIdentifier) as? PlayerAddEditViewController else { return }
        vc.typeOfVC = .add
        vc.delegate = self
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapAddDrawButton() {
        let vc = storyboardMain.instantiateViewController(withIdentifier: TournamentBracketViewController.storyboardIdentifier)
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
    private func didTapTableViewCell(with model: Player) {
        guard let vc = storyboardMain.instantiateViewController(
            withIdentifier: PlayerViewController.storyboardIdentifier
        ) as? PlayerViewController else { return }
        
        vc.playerId = model.id
        vc.delegate = self
        
        guard let nvc = self.navigationController else {
            return
        }
        nvc.pushViewController(vc, animated: true)
    }
    
    @objc private func didSwipeRefresh() {
        self.refresher.beginRefreshing()
        self.playerList.removeAll()
        self.tableView.reloadData()
        self.page = 1
        self.fetchData()
    }
    
    private func fetchData() {
        ApiCaller.shared.getPlayerList(from: self.page, with: self.limit) { [weak self] (result) in
            switch result {
            case .success(let model):
                self?.playerList = model
                self?.playerList.sort{ $0.getPoints() > $1.getPoints() }
                self?.page += 1
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                    self?.spinner.stopAnimating()
                    self?.refresher.endRefreshing()
                }
            case .failure(let error):
                self?.playerList.removeAll()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                    self?.spinner.stopAnimating()
                    self?.refresher.endRefreshing()
                    UIAlertController.showAlertUserMessage(self, title: nil, message: error.localizedDescription)
                }
            }
        }
    }
    
}

extension PlayerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier) as? PlayerTableViewCell else {
            return UITableViewCell()
        }
        let model = self.playerList[indexPath.row]
        let rank = indexPath.row + 1
        cell.configure(with: model, rank)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex && self.playerList.count >= limit {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .label
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            
            
            ApiCaller.shared.getPlayerList(from: self.page, with: self.limit) {  (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        if model.count > 0 {
                            self.playerList = self.playerList + model
                            self.playerList.sort{ $0.getPoints() > $1.getPoints() }
                            self.page += 1
                            self.tableView.reloadData()
                        } else {
                            UIAlertController.showAlertUserMessage(self, title: nil, message: "Currently no more players!")
                        }
                        spinner.stopAnimating()
                        self.tableView.tableFooterView = nil
                        self.tableView.tableFooterView?.isHidden = true
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.tableView.tableFooterView = nil
                        self.tableView.tableFooterView?.isHidden = true
                        self.tableView.reloadData()
                        UIAlertController.showAlertUserMessage(self, title: nil, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
}

extension PlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.didTapTableViewCell(with: self.playerList[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PlayerListViewController: PlayerViewControllerDelegate {
    func playerIsUpdated(with id: Int, player: PlayerDetail) {
        if let index = self.playerList.firstIndex(where: { $0.id == id }) {
            let item = self.playerList[index]
            guard item.firstName != player.firstName ||
                    item.lastName != player.lastName ||
                    item.points != player.points
            else { return }
            
            DispatchQueue.main.async {
                self.playerList[index] = Player(id: id,
                                                firstName: player.firstName,
                                                lastName: player.lastName,
                                                points: player.points,
                                                tournament_id: player.tournament_id)
                self.playerList.sort{ $0.getPoints() > $1.getPoints() }
                self.tableView.reloadData()
                
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
                
            }
            
        }
        
    }
    
    func playerIsDeleted(with id: Int) {
        self.playerList = self.playerList.filter{ $0.id != id }
        self.tableView.reloadData()
    }
    
}

extension PlayerListViewController: PlayerAddEditViewControllerDelegate {
    func playerIsEdited(player: PlayerDetail) { }
    
    func playerIsCreated() {
        self.spinner.startAnimating()
        self.fetchData()
    }
}
