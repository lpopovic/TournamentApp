//
//  PlayerDataTests.swift
//  TournamentAppTests
//
//  Created by MacBook on 5/26/21.
//

import XCTest
@testable import TournamentApp

class PlayerDataTests: XCTestCase {
    
    // MARK: - Variables
    
    var sut: Player!
    
    // MARK: - Life Cycle
    
    override func setUp() {
        self.sut = Player(
            id: 0,
            firstName: "FirstNameTest",
            lastName: "LastNameTest",
            points: 100,
            tournament_id: nil
        )
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    // MARK: - Actions
    
    func testPlayerModel_whenInitialized_firstName() {
       let firstName = self.sut.firstName
        
        let testData = "FirstNameTest"
        
        XCTAssertEqual(firstName, testData)
    }
    
    func testPlayerModel_whenInitialized_lastName() {
        let firstName = self.sut.lastName
        
        let testData = "LastNameTest"
        
        XCTAssertEqual(firstName, testData)
    }
    
    func testPlayerModel_whenInitialized_points() {
        guard let points = self.sut.points else {
            
            XCTAssertNil(self.sut.points)
            
            return
        }
        
        let testData = 100
        
        XCTAssertEqual(points, testData)
    }
    
    func testPlayerModel_whenInitialized_tournamentId() {
        let tournament_id = self.sut.tournament_id
        
        let testData: Int? = nil
        
        XCTAssertEqual(tournament_id, testData)
    }
    
    func testPlayerModel_whenInitialized_id() {
        let id = self.sut.id
        
        let testData = 0
        
        XCTAssertEqual(id, testData)
    }
    
    func testPlayerModel_whenInitialized_getPoints() {
        guard self.sut.points != nil else {
            XCTAssertEqual(self.sut.getPoints(), 0)
            
            return
        }
        
        let getPoints = self.sut.getPoints()
        
        let testData = 100
        
        XCTAssertEqual(getPoints, testData)
    }
    
}
