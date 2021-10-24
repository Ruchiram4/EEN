//
//  AppDataManagerTest.swift
//  EENAssignmentTests
//
//  Created by Ruchira Macbook on 2021-10-14.
//

import XCTest
@testable import EENAssignment

class AppDataManagerTest: XCTestCase {

    var dataManager: AppDataManager! = AppDataManager.shared
    var apiClient: APIClientProtocol? = Factory.createAPIClient()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        dataManager = nil
        apiClient = nil
        super.tearDown()
    }
    
    func test_tokens_with_user_defaults(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        var tokens: (String, String) = ("","")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            tokens.0 = loginResult!.accessToken!
            tokens.1 = loginResult!.refreshToken!
                
            self.dataManager.saveTokens(accessToken: loginResult?.accessToken, refreshToken: loginResult?.refreshToken)
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        let savedTokens = dataManager.getSavedTokens()
        XCTAssertFalse(savedTokens.0.isEmpty)
        XCTAssertFalse(savedTokens.1.isEmpty)
        XCTAssertEqual(savedTokens.0, tokens.0)
        XCTAssertEqual(savedTokens.1, tokens.1)
        
        
    }
    
    func test_clearTokens() {
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        var tokens: (String, String) = ("","")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            tokens.0 = loginResult!.accessToken!
            tokens.1 = loginResult!.refreshToken!
                
            self.dataManager.saveTokens(accessToken: loginResult?.accessToken, refreshToken: loginResult?.refreshToken)
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        XCTAssertNotNil(tokens.0)
        XCTAssertNotNil(tokens.1)
        
        dataManager.clearTokens()
        
        XCTAssertNil(dataManager.accessToken)
        XCTAssertNil(dataManager.refreshToken)
        
        let deletedTokens = dataManager.getSavedTokens()
        XCTAssert(deletedTokens.0.isEmpty)
        XCTAssert(deletedTokens.1.isEmpty)
    }
    
    func test_get_saved_tokens(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        var tokens: (String, String) = ("","")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            tokens.0 = loginResult!.accessToken!
            tokens.1 = loginResult!.refreshToken!
                
            self.dataManager.saveTokens(accessToken: loginResult?.accessToken, refreshToken: loginResult?.refreshToken)
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        let savedTokens = dataManager.getSavedTokens()
        XCTAssertEqual(savedTokens.0, tokens.0)
        XCTAssertEqual(savedTokens.1, tokens.1)
        
    }

}
