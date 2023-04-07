//
//  BioTableViewCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/23/21.
//

import UIKit

class BioTableViewCell: BaseTableViewCell {

    // MARK: - Variables
    
    static var height: CGFloat = UITableView.automaticDimension
    private(set) var rowKey: RowKey?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.contentView.backgroundColor = .secondarySystemBackground
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
  
    func fill(with model: BioTableViewCellModel) {
        self.titleLabel.text = model.title
        self.bioLabel.text = model.bio ?? "undefined"
    }
}

struct BioTableViewCellModel: TableViewCellModelProvider {
    var key: RowKey
    var title: String?
    var bio: String?
}
