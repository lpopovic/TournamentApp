//
//  Extensions+UIImageView.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation
import SDWebImage

extension UIImageView {
    func setImage(with url: URL?, placeholderImage: UIImage?) {
        self.sd_setImage(with: url,
                         placeholderImage: placeholderImage)
    }
}
