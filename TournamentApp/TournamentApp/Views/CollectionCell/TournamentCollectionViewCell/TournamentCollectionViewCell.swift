//
//  TournamentCollectionViewCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/25/21.
//

import UIKit

class TournamentCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables
    
    static let identifier = "TournamentCollectionViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.backgroundColor = .systemBackground
        self.contentView.backgroundColor = .systemBackground
        
        self.setupTableView()
        self.setupLevelLabel()
      
    }
    
    private func setupLevelLabel() {
        self.levelLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        self.levelLabel.numberOfLines = 1
        self.levelLabel.textAlignment = .center
        self.levelLabel.textColor = .label
    }
    
    private func setupTableView() {
        self.tableView.separatorColor = .none
        self.tableView.backgroundColor = .systemBackground
        self.tableView.register(UINib(nibName: TournamentTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: TournamentTableViewCell.identifier)
        self.tableView.isScrollEnabled = false
    }
    
    func configure(indexPath: IndexPath, tableViewTag: Int, sectionBracket: Int) {
        if(indexPath.row == (sectionBracket - 1)) {
            self.levelLabel.text = "Final"
        } else if(indexPath.row == (sectionBracket - 2)) {
            self.levelLabel.text = "Semi Final"
        } else {
            self.levelLabel.text = "Level \((indexPath.row) + 1)"
        }
        self.tableView.tag = tableViewTag
    }

}
