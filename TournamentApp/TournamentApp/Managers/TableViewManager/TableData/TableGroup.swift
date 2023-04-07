//
//  TableGroup.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

struct TableGroup {
    
    // MARK: - Properties
    
    typealias Row = TableViewCellProvider & TableViewCellTappable
    typealias Section = TableViewHeaderProvider
    
    // MARK: Public properties
    
    let key: String
    var rows: [Row]
    var showRows: Bool
    var section: Section?
    var numberOfRows: Int {
        showRows ? rows.count : 0
    }
    
    // MARK: - Initialization
    
    // key property must be the same like section key
    init(key: String,
         rows: [Row] = [],
         showRows: Bool = true,
         section: Section? = nil) {
        self.key = key
        self.rows = rows
        self.showRows = showRows
        self.section = section
    }
}

// MARK: - Public methods

extension TableGroup {
    mutating func addRows(_ newRows: [Row]) {
        rows.append(contentsOf: newRows)
    }
    
    mutating func setRows(_ visibility: Bool) {
        showRows = visibility
    }
}

// MARK: Rows methods

extension TableGroup {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rows[indexPath.row].tableView(tableView, heightForRowAt: indexPath)
    }

    func tapOnRow(at index: Int) {
        rows[index].performTap()
    }
}

// MARK: Section methods

extension TableGroup {
    func getSectionView() -> UIView? {
        section?.viewForHeaderInSection
    }
    
    func getSectionHeight() -> CGFloat {
        section?.heightForHeader ?? CGFloat.leastNonzeroMagnitude
    }
}
