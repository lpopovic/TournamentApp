//
//  NibReusable.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

protocol NibReusable: Reusable, NibLoadable { }

extension UITableViewCell: NibReusable { }
extension UICollectionViewCell: NibReusable { }
extension UIView: NibLoadable { }
