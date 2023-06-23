//
//  DebuggingNetworkManager.swift
//  TournamentApp
//
//  Created by Lazar Popovic on 21.6.23..
//

import Foundation
import netfox

typealias DebuggingNetworkProtocol = NFXProtocol

protocol DebuggingNetworkManagerProvider {
    func start()
}

final class DebuggingNetworkManager {
   
    private var manager: NFX {
        NFX.sharedInstance()
    }
    
    init() { }
}

extension DebuggingNetworkManager: DebuggingNetworkManagerProvider {
    func start() {
        #if DEBUG
        manager.start()
        #endif
    }
}
