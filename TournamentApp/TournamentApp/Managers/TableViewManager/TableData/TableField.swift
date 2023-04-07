//
//  TableField.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

protocol TableViewCellTappable {
    func performTap()
}

class TableField<Cell>: TableViewCellProvider, TableViewCellTappable where Cell: BaseTableViewCell {
    
    // MARK: - Properties
    
    // MARK: Private properties
    
    private var delegate: Cell.CellDelegate?
    private var model: Cell.Model
    
    // MARK: Private closures
    
    private var tapClosure: ((RowKey) -> Void)?
    
    // MARK: - Initialization
    
    init(model: Cell.Model,
         delegate: Cell.CellDelegate? = nil,
         tapClosure: ((RowKey) -> Void)? = nil) {
        self.model = model
        self.delegate = delegate
        self.tapClosure = tapClosure
    }
    
    // MARK: - Public methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(delegate)
        cell.fill(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Cell.height
    }
    
    func performTap() {
        tapClosure?(model.key)
    }
}
