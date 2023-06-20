//
//  TableViewManager.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 7.4.23..
//

import UIKit

// MARK: - AppTableViewManagerProvider

protocol AppTableViewManagerProvider {
    var sectionCount: Int { get }
    func getRowCount(for section: Int) -> Int
    func addRefreshController(to tableView: UITableView)
    func addFooterSpinner(to tableView: UITableView)
}

// MARK: - AppTableViewDataSource

protocol AppTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

// MARK: - AppTableViewDelegate

protocol AppTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
}

// MARK: - TableViewManager

class TableViewManager: NSObject {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private var dataSource = [TableGroup]()
    private var refresherTableView : UIRefreshControl?
    private var spinnerTableView: UIActivityIndicatorView?
    
    // MARK: Handlers
    
    var onReloadDataPresenter: NoArgsClosure?
    var onSwipeRefresh: NoArgsClosure?
    var onReachEnd: NoArgsClosure?
    
    // MARK: Initialization
    
    init(dataSource: [TableGroup]) {
        super.init()
        self.update(with: dataSource)
    }
    
    // MARK: Public method
    
    func reloadData() {
        endRefreshing()
        stopSpinner()
        onReloadDataPresenter?()
    }
    
    func endRefreshing() {
        guard let refresherTableView = refresherTableView else { return }
        if refresherTableView.isRefreshing {
            refresherTableView.endRefreshing()
        }
    }
    
    func stopSpinner() {
        guard let spinnerTableView = spinnerTableView else { return }
        if spinnerTableView.isAnimating == true {
            spinnerTableView.stopAnimating()
        }
    }
    
    // MARK: Private methods
    
    private func setupSpinner(in tableView: UITableView) {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .label
        spinner.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: tableView.frame.width,
            height: CGFloat(44))
        spinnerTableView = spinner
    }
    
    private func setupRefreshControl() {
        let refresher = UIRefreshControl()
        refresher.tintColor = .label
        refresher.addTarget(
            self,
            action: #selector(didSwipeRefresh),
            for: .valueChanged)
        refresherTableView = refresher
    }
    
    @objc
    private func didSwipeRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        onSwipeRefresh?()
    }
    
    @objc
    private func reachedEnd() {
        spinnerTableView?.startAnimating()
        onReachEnd?()
    }
}

// MARK: AppTableViewManagerProvider

extension TableViewManager: AppTableViewManagerProvider {
    var sectionCount: Int {
        dataSource.count
    }
    
    func update(with newDataSource: [TableGroup]) {
        dataSource = newDataSource
        reloadData()
    }
    
    func getRowCount(for section: Int) -> Int {
        guard section < dataSource.count else { return 0 }
        return dataSource[section].numberOfRows
    }
    
    func addRefreshController(to tableView: UITableView) {
        setupRefreshControl()
        guard let refresherTableView = refresherTableView else { return }
        tableView.addSubview(refresherTableView)
    }
    
    func addFooterSpinner(to tableView: UITableView) {
        setupSpinner(in: tableView)
        tableView.tableFooterView = spinnerTableView
    }
}

// MARK: - Delegate
// MARK: AppTableViewDataSource

extension TableViewManager: AppTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getRowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dataSource[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
}

// MARK: AppTableViewDelegate

extension TableViewManager: AppTableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource[indexPath.section].tapOnRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        guard indexPath.section == lastSectionIndex &&
                indexPath.row == lastRowIndex &&
                !(spinnerTableView?.isAnimating == true) &&
                tableView.tableFooterView != nil
        else { return }
//        reachedEnd()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource[indexPath.section].tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        dataSource[section].getSectionView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        dataSource[section].getSectionHeight()
    }
}
