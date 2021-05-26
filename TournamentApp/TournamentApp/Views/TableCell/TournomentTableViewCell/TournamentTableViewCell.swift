//
//  TournamentTableViewCell.swift
//  TournamentApp
//
//  Created by MacBook on 5/25/21.
//

import UIKit

class TournamentTableViewCell: UITableViewCell {

    // MARK: - Variables
    
    static let identifier = "TournamentTableViewCell"
    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    @IBOutlet weak var oddLine: UIView!
    @IBOutlet weak var evenLine: UIView!
    @IBOutlet weak var leadingLine: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = true
        self.backgroundColor = .systemBackground
        self.contentView.backgroundColor = .systemBackground
        self.selectionStyle = .none
        
        self.setupMainView()
        self.setupFirstPlayerLabel()
        self.setupSecondPlayerLabel()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupMainView() {
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainView.layer.borderWidth = 1.5
    }
    
    private func setupFirstPlayerLabel() {
        self.firstPlayerLabel.font = .systemFont(ofSize: 15, weight: .regular)
        self.firstPlayerLabel.numberOfLines = 1
        self.firstPlayerLabel.textAlignment = .center
    }
    
    private func setupSecondPlayerLabel() {
        self.secondPlayerLabel.font = .systemFont(ofSize: 15, weight: .regular)
        self.secondPlayerLabel.numberOfLines = 1
        self.secondPlayerLabel.textAlignment = .center
    }
    
    func configureUI(sectionBracket: Int, tableViewTag: Int, indexPath: IndexPath, separatorSize: [Int] ) {

        self.separatorHeight.constant = CGFloat(separatorSize[tableViewTag] + 10)
        
        if(tableViewTag < sectionBracket - 1) {
            if(indexPath.row % 2 == 0) {
                self.evenLine.isHidden = false
                self.oddLine.isHidden = true
            } else {
                self.evenLine.isHidden = true
                self.oddLine.isHidden = false
            }
        } else {
            self.evenLine.isHidden = true
            self.oddLine.isHidden = true
        }
        
        if tableViewTag != 0 {
            self.leadingLine.isHidden = false
        } else {
            self.leadingLine.isHidden = true
        }
    }
    
    func configureData(player1: Player, with rank1: Int, and player2: Player, with rank2: Int) {
        self.firstPlayerLabel.text = "#\(rank1) \(player1.firstName.prefix(1)). \(player1.lastName)"
        self.secondPlayerLabel.text = "#\(rank2) \(player2.firstName.prefix(1)). \(player2.lastName)"
    }
    
    func configureData(with model: Match) {
        self.firstPlayerLabel.text = "#\(model.playerOneRank) \(model.playerOne.firstName.prefix(1)). \(model.playerOne.lastName)"
        self.secondPlayerLabel.text = "#\(model.playerSecondRank) \(model.playerSecond.firstName.prefix(1)). \(model.playerSecond.lastName)"
    }
    
}
