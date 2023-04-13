//
//  PlayerViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import Foundation

final class PlayerViewModel {
   
    // MARK: - Properties
    
    typealias EditPlayerRequest = (playerId: Int?, playerDetailInfo: PlayerDetail?)
    
    enum TableSection {
        case base
        
        var key: String {
            switch self {
            case .base:
                return "baseKey"
            }
        }
        
        var rows: [TableRow] {
            switch self {
            case .base:
                return [.playerInfo, .bio]
            }
        }
    }
    
    enum TableRow  {
        case playerInfo
        case bio
        
        var key: String {
            switch self {
            case .playerInfo:
                return "playerInfoKey"
            case .bio:
                return "bioKey"
            }
        }
    }
    
    let playerId: Int
    private(set) var playerDetailInfo: PlayerDetail?
    private(set) var tableSections = [TableGroup]()
    private var isPlayerEdit = false
    
    // MARK: Service
    
    private let apiCaller: PlayerNetworkServiceProvider
    
    // MARK: Handlers
    
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var reloadListView: NoArgsClosure?
    var playerWasUpdated: VoidReturnClosure<PlayerDetail>?
    var onError: VoidReturnClosure<String>?
    var onDelete: VoidReturnClosure<String>?
    var showNavigationBar: VoidReturnClosure<Bool>?
    var showEditPlayerScreen: VoidReturnClosure<EditPlayerRequest>?
    var onCloseRequestScreen: VoidReturnClosure<BaseViewController>?

    // MARK: - Initialization

    init(playerId: Int,
         apiCaller: PlayerNetworkServiceProvider) {
        self.playerId = playerId
        self.apiCaller = apiCaller
    }
    
    // MARK: - Public methods
    
    func fetchData(didSwipeRefresh: Bool = false) {
        if didSwipeRefresh {
            showProgress?()
        }
        apiGetDetailPlayer { [weak self] result in
            guard let self = self else { return }
            self.hideProgress?()
            switch result {
            case.success: break
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
            self.setupNavigationActions()
            self.setTableSections()
        }
    }
    
    func fetchDeleteData() {
        showProgress?()
        apiDeletePlayer { [weak self] result in
            guard let self else { return }
            self.hideProgress?()
            switch result {
            case .success(let message):
                self.onDelete?(message)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func updated(_ player: PlayerDetail) {
        isPlayerEdit = true
        playerDetailInfo = player
        reloadListView?()
    }
    
    func checkIfDataWasUpdated() {
        guard isPlayerEdit,
              let player = playerDetailInfo
        else { return }
        playerWasUpdated?(player)
    }
    
    // MARK: Private methods
    
    private func createRows(for section: TableSection) -> [TableGroup.Row] {
        var rows = [TableGroup.Row]()
        section.rows.forEach { [weak self] rowType in
            guard let self else { return }
            switch rowType {
            case .bio:
                if let row = self.createBioTableViewCellRow() {
                    rows.append(row)
                }
            case .playerInfo:
                if let row = self.createPlayerInfoRow() {
                    rows.append(row)
                }
            }
        }
        return rows
    }
    
    private func createBioTableViewCellRow() -> TableField<BioTableViewCell>? {
        guard let player = playerDetailInfo else { return nil }
        let bioTableViewCellModel = BioTableViewCellModel(key: TableRow.bio.key,
                                                          title: "Bio",
                                                          bio: player.description)
        let bioTableViewCellRow: TableField<BioTableViewCell> = TableField(model: bioTableViewCellModel)
        return bioTableViewCellRow
    }
    
    private func createPlayerInfoRow() -> TableField<PlayerInfoTableCell>? {
        guard let player = playerDetailInfo else { return nil }
        let playerInfoRowModel = PlayerInfoTableCellModel(key: TableRow.playerInfo.key,
                                                          nameText: "\(player.firstName) \(player.lastName)",
                                                          dateOfBirthText: player.getStringDateOfBirth(),
                                                          pointsText: player.getPoints().formatedWithSeparator,
                                                          isProfessionalText: player.getStringIsProfessional(),
                                                          photoImageUrl: player.profileImageUrl)
        let playerInfoRow: TableField<PlayerInfoTableCell> = TableField(model: playerInfoRowModel)
        return playerInfoRow
    }
    
    private func createTableGroup(for section: TableSection) -> TableGroup {
        let rows = createRows(for: section)
        let tableGroup = TableGroup(key: section.key, rows: rows)
        return tableGroup
    }
    
    private func setTableSections() {
        defer {
            reloadListView?()
        }
        tableSections.removeAll()
        let section = createTableGroup(for: .base)
        tableSections.append(section)
    }
    
    private func setupNavigationActions() {
        let showButtons: Bool
        if let player = playerDetailInfo,
           player.tournamentId == GlobalConstants.tournomentId {
            showButtons = true
        } else {
            showButtons = false
        }
        showNavigationBar?(showButtons)
    }
    
    // API methods
    func apiGetDetailPlayer(completion: @escaping VoidReturnClosure<ResultBasic>) {
        apiCaller.getDetailPlayer(with: playerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let model):
                self.playerDetailInfo = model
                completion(.success)
            case .failure(let error):
                self.playerDetailInfo = nil
                completion(.failure(error))
            }
        }
    }
    
    func apiDeletePlayer(completion: @escaping VoidReturnClosure<ResultObject<String>>) {
        apiCaller.deletePlayer(with: playerId) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
