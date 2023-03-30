//
//  WebImageProvider.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import UIKit
import SDWebImage

protocol WebImageProvider {
    func setImage(with url: URL?, placeholderImage: UIImage?)
}

extension WebImageProvider where Self: UIImageView {
    func setImage(with url: URL?, placeholderImage: UIImage?) {
        self.sd_setImage(with: url,
                         placeholderImage: placeholderImage)
    }
}
