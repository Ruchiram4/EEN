//
//  URLsTest.swift
//  EENAssignmentTests
//
//  Created by Ruchira Macbook on 2021-10-17.
//

import XCTest
@testable import EENAssignment

class URLsTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Urls() {
        
        let cameraId = "1729057"
        let loginUrl = "/oauth/token"
        let logoutUrl = "/rest/v2.0/users/self/tokens/current"
        let refreshTokenUrl = "/oauth/token"
        let camerasUrl = "/rest/v2.4/cameras"
        let cameraStatus = "/rest/v2.4/cameras/\(cameraId)/status"
        let cameraStreams = "/rest/v2.2/cameras/\(cameraId)/streams"
        
        XCTAssertEqual(loginUrl, URLs.login())
        XCTAssertEqual(logoutUrl, URLs.logOut())
        XCTAssertEqual(refreshTokenUrl, URLs.refreshToken())
        XCTAssertEqual(camerasUrl, URLs.cameras())
        XCTAssertEqual(cameraStatus, URLs.cameraStatus(cameraId: Int(cameraId)!))
        XCTAssertEqual(cameraStreams, URLs.cameraStream(cameraId: Int(cameraId)!))
    }

}
