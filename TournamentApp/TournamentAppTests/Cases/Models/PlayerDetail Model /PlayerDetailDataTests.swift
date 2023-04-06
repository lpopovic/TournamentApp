//
//  PlayerDetailDataTests.swift
//  TournamentAppTests
//
//  Created by MacBook on 5/26/21.
//

import XCTest
@testable import TournamentApp

class PlayerDetailDataTests: XCTestCase {
    
    // MARK: - Variables
    
    var sut: PlayerDetail!
    
    // MARK: - Life Cycle
    
    override func setUp() {
        self.sut = PlayerDetail(
            id: 0,
            firstName: "-",
            lastName: "-",
            points: 100,
            dateOfBirth: "2017-06-30 21:22:38",
            profileImageUrl: nil,
            isProfessional: 1,
            tournament_id: 312,
            description: "-"
        )
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    // MARK: - Actions
    
    func testPlayerDetailModel_whenInitialized_isId() {
        let id = self.sut.id
        
        XCTAssertEqual(id, 0)
    }
    
    func testPlayerDetailModel_whenInitialized_points() {
        
        let points = self.sut.points
        
        let testData = 100
        
        XCTAssertEqual(points, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_dateOfBirthString() {
        guard let dateOfBirth = self.sut.getStringDateOfBirth() else {
            let date = self.sut.getStringDateOfBirth()
            
            XCTAssertNil(date)
            return
        }
        
        let testData = "2017-06-30"
        
        XCTAssertEqual(dateOfBirth, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_dateOfBirth() {
        guard let dateOfBirthString = self.sut.dateOfBirth,
              let dateOfBirth = dateOfBirthString.toDate() else {
            
            XCTAssertNil(self.sut.dateOfBirth)
            
            return
        }
        let testDate = "2017-06-30 21:22:38".toDate()
        
        XCTAssertEqual(dateOfBirth, testDate)
        
    }
    
    func testPlayerDetailModel_whenInitialized_profileImageUrl() {
        guard let profileImageUrl = self.sut.profileImageUrl else {
            
            XCTAssertNil(self.sut.profileImageUrl)
            
            return
        }
        
        let testData = "https://homepages.cae.wisc.edu/~ece533/images/baboon.png"
        
        XCTAssertEqual(profileImageUrl, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_isProfessional() {
        guard let isProfessional = self.sut.isProfessional else {
            
            XCTAssertNil(self.sut.isProfessional)
            
            return
        }
        
        let testData = 1
        
        XCTAssertEqual(isProfessional, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_tournamentId() {
        guard let tournament_id = self.sut.tournamentId else {
            
            XCTAssertNil(self.sut.tournamentId)
            
            return
        }
        
        let testData = 312
        
        XCTAssertEqual(tournament_id, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_description() {
        guard let description = self.sut.description else {
            
            XCTAssertNil(self.sut.description)
            
            return
        }
        
        let testData = "-"
        
        XCTAssertEqual(description, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_firstName() {
        let firstName = self.sut.firstName
        
        let testData = "-"
        
        XCTAssertEqual(firstName, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_lastName() {
         let lastName = self.sut.lastName
        
        let testData = "-"
        
        XCTAssertEqual(lastName, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_getPoints() {
       
        guard let _ = self.sut.points else {
            let getPoints = self.sut.getPoints()
            
            XCTAssertEqual(getPoints, 0)
            
            return
        }
        let getPoints = self.sut.getPoints()
        
        let testData = 100
        
        XCTAssertEqual(getPoints, testData)
    }
    
    func testPlayerDetailModel_whenInitialized_getStringIsProfessional() {
        let stringIsProfessional = self.sut.getStringIsProfessional()
        guard let isProfessional = self.sut.isProfessional else {
            XCTAssertEqual(stringIsProfessional, "undefined")
            
            return
        }
        
        let testData = isProfessional > 0 ? "yes" : "no"
        
        XCTAssertEqual(stringIsProfessional, testData)
        
    }
    
}
