//
//  PlayerInfoTableCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit


class PlayerInfoTableCell: BaseTableViewCell {
   
    // MARK: - Variables
    
    static var height: CGFloat = UITableView.automaticDimension
    private(set) var rowKey: RowKey?

    // MARK: - IBOutlet
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var isProfessionalLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.contentView.backgroundColor = .secondarySystemBackground
        self.selectionStyle = .none
        
        self.setupPhotoImageView()
        self.setupNameLabel()
        self.setupPointsLabel()
        self.setupDateOfBirthLabel()
        self.setupIsProfessionalLabel()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fill(with model: PlayerInfoTableCellModel) {
        rowKey = model.key
        self.nameLabel.text = model.nameText
        self.dateOfBirthLabel.text = "\(model.dateOfBirthText ?? "Date of birth undefined")"
        self.pointsLabel.text = "Scored points: \(model.pointsText)"
        self.isProfessionalLabel.text = "Professional athlete: \(model.isProfessionalText)"
        self.photoImageView.setImage(with: URL(string: model.photoImageUrl ?? ""),
                                     placeholderImage: LocalImage.photo.value)
    }
    
    private func setupNameLabel() {
        self.nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        self.nameLabel.numberOfLines = 0
        self.nameLabel.textAlignment = .left
    }
    
    private func setupDateOfBirthLabel() {
        self.dateOfBirthLabel.font = .systemFont(ofSize: 18, weight: .regular)
        self.dateOfBirthLabel.numberOfLines = 1
        self.dateOfBirthLabel.textAlignment = .left
    }
    
    private func setupPointsLabel() {
        self.pointsLabel.font = .systemFont(ofSize: 15, weight: .medium)
        self.pointsLabel.numberOfLines = 1
        self.pointsLabel.textAlignment = .right
    }
    
    private func setupIsProfessionalLabel() {
        self.isProfessionalLabel.font = .systemFont(ofSize: 15, weight: .regular)
        self.isProfessionalLabel.numberOfLines = 1
        self.isProfessionalLabel.textColor = .systemBlue
        self.isProfessionalLabel.textAlignment = .left
    }
    
    private func setupPhotoImageView() {
        self.photoImageView.clipsToBounds = true
        self.photoImageView.contentMode = .scaleAspectFill
    }
}

struct PlayerInfoTableCellModel: TableViewCellModelProvider {
    var key: RowKey
    var nameText: String?
    var dateOfBirthText: String?
    var pointsText: String
    var isProfessionalText: String
    var photoImageUrl: String?
}
