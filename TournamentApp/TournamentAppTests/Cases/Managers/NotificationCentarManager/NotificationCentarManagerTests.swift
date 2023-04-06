//
//  NotificationCentarManagerTests.swift
//  TournamentAppTests
//
//  Created by Lazar Popovic on 6.4.23..
//

import XCTest
@testable import TournamentApp

final class NotificationCentarManagerTests: XCTestCase {
    func test_post_whenInvokedAndAddedObserverAndNotificationNameProvided_shouldTriggerNotification() {
        let expected = expectation(description: "trigger notification happened")
        let (sut, mockObserver) = makeSUT(expectedOne: expected)
        let dummyNotificationName = Notification.Name("dummyNotificationName")
        
        sut.addObserver(mockObserver,
                        selector: #selector(mockObserver.dummyNotificationMethodOne),
                        notificationName: dummyNotificationName)
        sut.post(with: dummyNotificationName)
        
        wait(for: [expected], timeout: 1)
    }
    
    func test_post_whenInvokedAndNotAddedObserverAndNotificationNameProvided_shouldNotTriggerNotification() {
        let expected = expectation(description: "trigger notification happened")
        expected.isInverted = true
        let (sut, _) = makeSUT(expectedOne: expected)
        let dummyNotificationName = Notification.Name("dummyNotificationName")
        
        sut.post(with: dummyNotificationName)
        
        wait(for: [expected], timeout: 1)
    }
    
    func test_post_whenInvokedAndObserverProvided_shouldNotTriggerAnyNotificationMethodFromObserver() {
        let expectedOne = expectation(description: "trigger notification one happened")
        expectedOne.isInverted = true
        let expectedSecond = expectation(description: "trigger notification second happened")
        expectedSecond.isInverted = true
        let dummyNotificationNameOne = Notification.Name("dummyNotificationNameOne")
        let dummyNotificationNameSecond = Notification.Name("dummyNotificationNameSecond")
        let (sut, mockObserver) = makeSUT(expectedOne: expectedOne,
                                          expectedSecond: expectedSecond)
        sut.addObserver(mockObserver,
                        selector: #selector(mockObserver.dummyNotificationMethodOne),
                        notificationName: dummyNotificationNameOne)
        sut.addObserver(mockObserver,
                        selector: #selector(mockObserver.dummyNotificationMethodSecond),
                        notificationName: dummyNotificationNameSecond)
        
        sut.removeObserver(mockObserver)
        sut.post(with: dummyNotificationNameOne)
        sut.post(with: dummyNotificationNameSecond)
        
        wait(for: [expectedOne, expectedSecond], timeout: 1)
    }
    
    func test_post_whenInvokedAndObserverAndNotificationNameProvided_shouldNotTriggerNotificationMethodFromObserver() {
        let expectedOne = expectation(description: "trigger notification one happened")
        let expectedSecond = expectation(description: "trigger notification second happened")
        expectedSecond.isInverted = true
        let dummyNotificationNameOne = Notification.Name("dummyNotificationNameOne")
        let dummyNotificationNameSecond = Notification.Name("dummyNotificationNameSecond")
        let (sut, mockObserver) = makeSUT(expectedOne: expectedOne,
                                          expectedSecond: expectedSecond)
        sut.addObserver(mockObserver,
                        selector: #selector(mockObserver.dummyNotificationMethodOne),
                        notificationName: dummyNotificationNameOne)
        sut.addObserver(mockObserver,
                        selector: #selector(mockObserver.dummyNotificationMethodSecond),
                        notificationName: dummyNotificationNameSecond)
        
        sut.removeObserver(mockObserver,
                           notificationName: dummyNotificationNameSecond)
        sut.post(with: dummyNotificationNameOne)
        sut.post(with: dummyNotificationNameSecond)
        
        wait(for: [expectedOne, expectedSecond], timeout: 1)
    }
}

extension NotificationCentarManagerTests {
    private func makeSUT(expectedOne: XCTestExpectation? = nil,
                         expectedSecond: XCTestExpectation? = nil) -> (sut: NotificationCentarManager,
                                                                       mockObserver: MockObserver) {
        let mockObserver = MockObserver(expectedOne: expectedOne,
                                        expectedSecond: expectedSecond)
        let sut = NotificationCentarManager()
        return (sut, mockObserver)
    }
    
    private class MockObserver {
        let expectedOne: XCTestExpectation?
        let expectedSecond: XCTestExpectation?
        
        init(expectedOne: XCTestExpectation?, expectedSecond: XCTestExpectation?) {
            self.expectedOne = expectedOne
            self.expectedSecond = expectedSecond
        }
        
        @objc func dummyNotificationMethodOne() {
            expectedOne?.fulfill()
        }
        
        @objc func dummyNotificationMethodSecond() {
            expectedSecond?.fulfill()
        }
    }
}

