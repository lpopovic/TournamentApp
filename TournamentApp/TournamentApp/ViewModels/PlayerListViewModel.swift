//
//  PlayerListViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

final class PlayerListViewModel {
    
    // MARK: - Properties
    
    enum TableSection {
        case base
        
        var key: String {
            switch self {
            case .base:
                return "baseKey"
            }
        }
    }
    
    enum TableRow  {
        case player(Int)
        var key: String {
            switch self {
            case .player(let id):
                return "\(id)Key"
            }
        }
    }
    
    let navigationTitle = "Player List"
    let drawButtonTitle = "Draw"
    let refreshViewTitle = "Pull to refresh"
    
    private(set) var tableSections = [TableGroup]()
    private var playerList = [Player]()
    private var isMoreLoading = false
    private var detectEmptyResponse = false
    private var page: Int = 1
    private let limit: Int = 20

    // MARK: Service
    
    private let apiCaller: PlayerNetworkServiceProvider
    
    // MARK: Handlers
    
    var onError: VoidReturnClosure<String>?
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var reloadListView: NoArgsClosure?
    var onSwipeRefresh: NoArgsClosure?
    var onSelectItem: VoidReturnClosure<Player>?
    var showTournamentBracketScreen: VoidReturnClosure<[Player]>?
    var showAddPlayerScreen: NoArgsClosure?
    var showPlayerScreen: VoidReturnClosure<Int>?

    // MARK: - Initialization

    init(apiCaller: PlayerNetworkServiceProvider) {
        self.apiCaller = apiCaller
    }
    
    // MARK: - Public methods
    
    func fetchInitData(from swipeRefresh: Bool = false) {
        if !swipeRefresh {
            showProgress?()
        }
        page = 1
        isMoreLoading = false
        detectEmptyResponse = false
        apiGetPlayerList { [weak self] result in
            guard let self else { return }
            self.hideProgress?()
            self.setTableSections()
            if case .failure(let error) = result {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func fetchMoreData() {
        isMoreLoading = true
        apiGetMorePlayerList { [weak self] result in
            guard let self else { return }
            self.isMoreLoading = false
            self.hideProgress?()
            self.setTableSections()
            if case .failure(let error) = result {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func playerIsDeleted(_ id: Int) {
        self.playerList = self.playerList.filter{ $0.id != id }
        self.setTableSections()
    }
    
    func playerIsUpdated(with id: Int, player: PlayerDetail, _ completion: VoidReturnClosure<Int>?) {
        guard let index = self.playerList.firstIndex(where: { $0.id == id }) else { return }
        let item = self.playerList[index]
        guard item.firstName != player.firstName ||
                item.lastName != player.lastName ||
                item.points != player.points
        else { return }
        self.playerList[index] = Player(id: id,
                                        firstName: player.firstName,
                                        lastName: player.lastName,
                                        points: player.points,
                                        tournament_id: player.tournamentId)
        self.playerList.sort{ $0.getPoints() > $1.getPoints() }
        self.setTableSections()
        completion?(index)
    }
    
    func checkIfCanLoadMore() -> Bool {
        guard !isMoreLoading, playerList.count >= limit, !detectEmptyResponse
        else {
            return false
        }
        return true
    }
    
    func pushTournamentBracketViewController() {
        guard let playersForDraw = getItemsForBracket()
        else { return }
        showTournamentBracketScreen?(playersForDraw)
    }
    
    // MARK: - Private methods
    
    private func createRows() -> [TableGroup.Row] {
        var rows: [TableGroup.Row] = []
        for (index, element) in playerList.enumerated() {
            let row = createPlayerTableRow(from: element, index: index)
            rows.append(row)
        }
        
        return rows
    }
    
    private func createPlayerTableRow(from player: Player, index: Int) -> TableField<PlayerTableViewCell> {
        let playerInfoRowModel = PlayerTableViewCellModel(key: TableRow.player(player.id).key,
                                                          rank: index + 1,
                                                          firstName: player.firstName,
                                                          lastName: player.lastName,
                                                          pointsPreview: player.getPoints().formatedWithSeparator)
        let playerInfoRow: TableField<PlayerTableViewCell> = TableField(model: playerInfoRowModel) { [weak self] rowKey in
            guard let self,
                  let player = self.playerList.first(where: { TableRow.player($0.id).key == rowKey })
            else { return }
            self.onSelectItem?(player)
        }
        return playerInfoRow
    }
    
    private func setTableSections() {
        tableSections.removeAll()
        let rows = createRows()
        let section = TableGroup(key: TableSection.base.key, rows: rows)
        tableSections.append(section)
        reloadListView?()
    }
    
    private func getItemsForBracket() -> [Player]? {
        var playersForDraw = [Player]()
        for item in playerList {
            if playersForDraw.count == 32 {
                break
            } else if item.tournament_id == nil {
                playersForDraw.append(item)
            }
        }
        
        if playersForDraw.count == 32 {
            return playersForDraw
        } else {
            onError?("There is not enough players, please load more.")
            return nil
        }
    }
    
    private func apiGetPlayerList(completion: @escaping VoidReturnClosure<ResultBasic>) {
        apiCaller.getPlayerList(from: page, with: limit) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.playerList = model
                self.playerList.sort{ $0.getPoints() > $1.getPoints() }
                self.page += 1
                completion(.success)
            case .failure(let error):
                self.playerList.removeAll()
                completion(.failure(error.localizedDescription))
            }
        }
    }
    
    private func apiGetMorePlayerList(completion: @escaping VoidReturnClosure<ResultBasic>) {
        apiCaller.getPlayerList(from: page, with: limit) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                if model.count > 0 {
                    self.playerList = self.playerList + model
                    self.playerList.sort{ $0.getPoints() > $1.getPoints() }
                    self.page += 1
                    completion(.success)
                } else {
                    self.detectEmptyResponse = true
                    completion(.failure(NetworkError.runtimeError(message: "Empty list!")))
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
}
