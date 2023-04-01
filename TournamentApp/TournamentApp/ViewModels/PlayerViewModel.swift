//
//  PlayerViewModel.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 1.4.23..
//

import Foundation

final class PlayerViewModel {
   
    // MARK: - Properties
    
    let playerId: Int
    private(set) var playerDetailInfo: PlayerDetail?
    private(set) var isPlayerEdit = false
    
    // MARK: Service
    
    private let apiCaller: ApiCallerProvider
    
    // MARK: Handlers
    
    var showProgress: NoArgsClosure?
    var hideProgress: NoArgsClosure?
    var reloadListView: NoArgsClosure?
    var playerWasUpdated: VoidReturnClosure<PlayerDetail>?
    var onError: VoidReturnClosure<String>?
    var onDelete: VoidReturnClosure<String>?
    var showNavigationBar: VoidReturnClosure<Bool>?


    // MARK: - Initialization

    init(playerId: Int,
         apiCaller: ApiCallerProvider = ApiCaller.shared) {
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
            self.reloadListView?()
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
    
    private func setupNavigationActions() {
        let showButtons: Bool
        if let player = playerDetailInfo,
           player.tournament_id == GlobalConstants.tournomentId {
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
