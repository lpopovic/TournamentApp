//
//  PlayerInfoTableCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/22/21.
//

import UIKit
import SDWebImage

class PlayerInfoTableCell: UITableViewCell {
    
    // MARK: - Variables
    
    static let identifier = "PlayerInfoTableCell"
    
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
    
    func configure(with model: PlayerDetail) {
        self.nameLabel.text = "\(model.firstName) \(model.lastName)"
        self.dateOfBirthLabel.text = "\(model.getStringDateOfBirth() ?? "Date of birth undefined")"
        self.pointsLabel.text = "Scored points: \(model.getPoints().formatedWithSeparator)"
        self.isProfessionalLabel.text = "Professional athlete: \(model.getStringIsProfessional())"
        self.photoImageView.sd_setImage(
            with: URL(string: model.profileImageUrl ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
            completed: nil
        )
    }
    
}
