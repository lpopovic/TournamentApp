//
//  SetDraw.swift
//  TournamentApp
//
//  Created by MacBook on 6/2/21.
//

import Foundation

final class SetDraw {
    
    static let shared = SetDraw()
    
    private func seeding(numPlayers: Int) -> [Int]{
        let rounds = Int(log(Double(numPlayers))/log(2)-1)
        var pls:[Int] = [1, 2]
        
        func nextLayer(_ pls:[Int])->[Int]{
            var out: [Int] = [];
            let length = pls.count*2+1;
            for item in pls {
                out.append(item)
                out.append(length-item);
            }
            return out;
        }
        
        for _ in 0..<rounds {
            pls = nextLayer(pls);
        }
        
        return pls;
    }
    
    func setDrawForPlayer(
        for numberOfMatchInEachBracket: [Int],
        with playerList: inout [PlayerBaseInfo]) -> (
            drawPositionForPlayers: [[Int]],
            matchInEachBracket: [[Match]]
        ) {
        var drawPositionForPlayers:[[Int]] = []
        for i in 0...numberOfMatchInEachBracket.count {
            switch i {
            case 0:
                let firstRound = self.seeding(numPlayers: numberOfMatchInEachBracket[i] * 2)
                drawPositionForPlayers.append(firstRound)
            default:
                let lastRound = drawPositionForPlayers[i-1]
                var nextRound: [Int] = []
                
                var index = 0
                while index < lastRound.count / 2 {
                    let winner = Int.random(in: 1...100) % 5 == 0 ? index : index + 1
                    nextRound.append(lastRound[winner])
                    
                    index += 2
                }
                
                index = lastRound.count / 2
                if index > 1 {
                    while index < lastRound.count {
                        let winner = Int.random(in: 1...100) % 5 == 0 ? index : index + 1
                        nextRound.append(lastRound[winner])
                        
                        index += 2
                    }
                }
                drawPositionForPlayers.append(nextRound)
                
            }
        }
        
        return (
            drawPositionForPlayers: drawPositionForPlayers,
            matchInEachBracket: self.setMatchList(
                with: drawPositionForPlayers,
                from: &playerList
            )
        )
    }
    
    private func setMatchList(with drawPositionForPlayers: [[Int]], from playerList: inout [PlayerBaseInfo]) -> [[Match]] {
        var matchInEachBracket: [[Match]] = []
        
        for section in 0..<(drawPositionForPlayers.count - 1) {
            var bracketMatch = [Match]()
            let bracketPlayer = drawPositionForPlayers[section]
            var bracketPlayerIndex = 0
            
            while bracketPlayerIndex < bracketPlayer.count {
                
                let index = bracketPlayerIndex
                
                let match = Match(
                    playerOne: playerList[bracketPlayer[index] - 1],
                    playerOneRank: bracketPlayer[index],
                    playerSecond: playerList[bracketPlayer[index + 1] - 1],
                    playerSecondRank: bracketPlayer[index + 1]
                )
                bracketMatch.append(match)
                
                bracketPlayerIndex += 2
            }
            
            matchInEachBracket.append(bracketMatch)
            
        }
        
        return matchInEachBracket
    }
}
