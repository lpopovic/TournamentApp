//
//  PlayerTableViewCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    // MARK: - Variables
    static let identifier = "PlayerTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.clipsToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        self.setupFirstNameLabel()
        self.setupLastNameLabel()
        self.setupRankLabel()
        self.setupPointsLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UI
    
    private func setupFirstNameLabel() {
        self.firstNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        self.firstNameLabel.numberOfLines = 0
        self.firstNameLabel.textAlignment = .left
    }
    
    private func setupLastNameLabel() {
        self.lastNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        self.lastNameLabel.numberOfLines = 0
        self.lastNameLabel.textAlignment = .left
    }
    
    private func setupPointsLabel() {
        self.pointsLabel.font = .systemFont(ofSize: 15, weight: .medium)
        self.pointsLabel.numberOfLines = 1
        self.pointsLabel.textAlignment = .right
    }
    
    private func setupRankLabel() {
        self.rankLabel.font = .systemFont(ofSize: 15, weight: .bold)
        self.rankLabel.numberOfLines = 1
        self.rankLabel.textColor = .systemBlue
        self.rankLabel.textAlignment = .right
    }
    
    
    func configure(with model: String) {
        self.firstNameLabel.text = model
        self.lastNameLabel.text = "Last Name"
        self.pointsLabel.text = "1000 points"
        self.rankLabel.text = "# 1"
        
    }
}
