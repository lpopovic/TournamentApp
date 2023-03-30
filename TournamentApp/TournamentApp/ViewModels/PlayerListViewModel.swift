//
//  PlayerListViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 30.3.23..
//

import Foundation

final class PlayerListViewModel {
    
    // MARK: - Properties
    
    let navigationTitle = "Player List"
    let drawButtonTitle = "Draw"
    let refreshViewTitle = "Pull to refresh"
    
    private(set) var playerList: [Player] = [Player]()
    private(set) var isMoreLoading: Bool = false
    private var page: Int = 1
    private let limit: Int = 20
    
    // MARK: Service
    
    private let apiCaller: PlayerNetworkServiceProvider = PlayerNetworkService()
    
    // MARK: Handlers
    
    var onError: VoidReturnClosure<String>?
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var reloadListView: NoArgsClosure?
    var onSwipeRefresh: NoArgsClosure?
    var onSelectItem: VoidReturnClosure<Player>?

    // MARK: - Public methods
    
    func fetchInitData() {
        showProgress?()
        page = 1
        apiGetPlayerList { [weak self] result in
            guard let self else { return }
            self.hideProgress?()
            self.reloadListView?()
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
            self.reloadListView?()
            if case .failure(let error) = result {
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func numberOfItems() -> Int {
        playerList.count
    }
    
    func getItem(at index: Int) -> (model: Player, rank: Int)? {
        guard index < playerList.count else { return nil }
        let model = playerList[index]
        let rank = index + 1
        return(model, rank)
    }
    
    func playerIsDeleted(_ id: Int) {
        self.playerList = self.playerList.filter{ $0.id != id }
        self.reloadListView?()
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
                                        tournament_id: player.tournament_id)
        self.playerList.sort{ $0.getPoints() > $1.getPoints() }
        reloadListView?()
        completion?(index)
    }
    
    func didSelectItem(at index: Int) {
        guard index < playerList.count else { return }
        onSelectItem?(playerList[index])
    }
    
    func getItemsForBracket() -> [Player]? {
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
    
    // MARK: - Private methods
    
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
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }

}