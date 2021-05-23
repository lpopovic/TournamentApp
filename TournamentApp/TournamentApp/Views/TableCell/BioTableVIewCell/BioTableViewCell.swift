//
//  BioTableViewCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import UIKit

class BioTableViewCell: UITableViewCell {

    // MARK: - Variables
    
    static let identifier = "BioTableViewCell"
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.contentView.backgroundColor = .secondarySystemBackground
        self.contentView.clipsToBounds = true
        self.selectionStyle = .none
        
        self.setupTitleLabel()
        self.setupBioLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupTitleLabel() {
        self.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        self.titleLabel.numberOfLines = 1
        self.titleLabel.textAlignment = .left
    }
    
    private func setupBioLabel() {
        self.bioLabel.font = .systemFont(ofSize: 15, weight: .medium)
        self.bioLabel.numberOfLines = 0
        self.bioLabel.textAlignment = .left
    }
  
    func configure(with title: String, bio: String?) {
        self.titleLabel.text = title
        self.bioLabel.text = bio ?? "undefined"
    }
}
