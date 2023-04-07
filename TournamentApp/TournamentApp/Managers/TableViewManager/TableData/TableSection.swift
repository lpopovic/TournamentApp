//
//  TableSection.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

class TableSection<Header> where Header: BaseTableViewHeader {
    
    // MARK: - Properties
    
    // MARK: Private properties
    
    private var delegate: Header.SectionDelegate?
    private var model: Header.Model
    private var key: Header.SectionKey
    
    // MARK: - Initialization
    
    init(model: Header.Model,
         key: Header.SectionKey,
         delegate: Header.SectionDelegate? = nil) {
        self.model = model
        self.key = key
        self.delegate = delegate
    }
}

// MARK: - TableViewHeaderProvider

extension TableSection: TableViewHeaderProvider {
    var viewForHeaderInSection: UIView? {
        let view = Header.instance
        view.setup(delegate)
        view.fill(with: model, key: key)
        return view
    }
    
    var heightForHeader: CGFloat {
        Header.height
    }
}
