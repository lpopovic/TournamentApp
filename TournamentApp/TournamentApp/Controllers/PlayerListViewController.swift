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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVC()
        self.setupTableView()
        self.setupSpinner()
        self.setupRefreshControl()
        
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.spinner.stopAnimating()
        self.tableView.isHidden = false
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
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        refresher.tintColor = .label
        refresher.addTarget(self, action: #selector(didSwipeRefresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        self.tableView.register(UITableViewCell.self,
                                        forCellReuseIdentifier: "cell")
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddPlayerButton() {
        let vc = storyboardMain.instantiateViewController(withIdentifier: PlayerViewController.storyboardIdentifier)
        
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
    
    @objc private func didSwipeRefresh() {
        self.refresher.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refresher.endRefreshing()
        }
    }
    
}

extension PlayerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = "Novak Djokovic"
        return cell
    }
    
    
}

extension PlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
