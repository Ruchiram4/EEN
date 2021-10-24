//
//  APIClientTest.swift
//  EENAssignmentTests
//
//  Created by Ruchira Macbook on 2021-10-13.
//

import XCTest
@testable import EENAssignment

class APIClientTest: XCTestCase {

    var apiClient: APIClient? = APIClient(withParser: ObjectParser())
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func test_APICalls(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        let expectationLoginFail = XCTestExpectation(description: "LoginFail expectation")
        apiClient?.login(userName: "abc123", password: "abc123", completion: { loginResult, responseError in
            
            let error = responseError
            XCTAssertEqual(error, .authentication)
            expectationLoginFail.fulfill()

        })
        
        wait(for: [expectationLoginSuccess, expectationLoginFail], timeout: 10.0)
        
        var camera: Camera?
        let expectationGetCameras = XCTestExpectation(description: "Get Cameras expectation")
        
        apiClient?.getCameras(completion: { cameras, responseError in
            
            if let cameras = cameras {
                camera = cameras[0]
                XCTAssertNotNil(camera)
                XCTAssertNotNil(camera?.name)
                XCTAssertNotNil(camera?.cameraId)
                XCTAssertNotNil(camera?.accountId)
                XCTAssertNotNil(camera?.ethernetMacAddress)
                XCTAssertNotNil(camera?.zoneId)
            }
            
            XCTAssertNotNil(cameras)
            XCTAssertEqual(responseError, .none)
            expectationGetCameras.fulfill()
        })
        
        wait(for: [expectationGetCameras], timeout: 10.0)
        
        let expectationGetCameraDetails = XCTestExpectation(description: "Get Camera details")
        
        apiClient?.getCameraStatus(camera: camera!, completion: { cameraStatus, responseError in
            
            XCTAssertNotNil(cameraStatus)
            XCTAssertNotNil(cameraStatus?.firmwareStatus)
            XCTAssertNotNil(cameraStatus?.isOnline)
            XCTAssertNotNil(cameraStatus?.isRecordingOnCloud)
            XCTAssertNotNil(cameraStatus?.isAudioEnabled)
            XCTAssertEqual(responseError, ResponseError.none)
            expectationGetCameraDetails.fulfill()
        })
        
        wait(for: [expectationGetCameraDetails], timeout: 10.0)
        
        let expectationRefreshToken = XCTestExpectation(description: "Get Refresh token")
        apiClient?.refreshToken(refreshToken: AppDataManager.shared.refreshToken!, completion: { loginResult, responseError in
            
            XCTAssertNotNil(loginResult)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            XCTAssertEqual(responseError, .none)
            expectationRefreshToken.fulfill()
        })
        wait(for: [expectationRefreshToken], timeout: 10.0)
        
        let expectationLogout = XCTestExpectation(description: "Logout")
        apiClient?.logOut(completion: { responseError in
            
            XCTAssertEqual(responseError, .none)
            XCTAssertEqual(AppDataManager.shared.accessToken, nil)
            XCTAssertEqual(AppDataManager.shared.refreshToken, nil)
            expectationLogout.fulfill()
        })
        wait(for: [expectationLogout], timeout: 10.0)
        
    }
    
    func test_getPathComponentsForAPI(){
        
        let pathLogin = apiClient?.getPathComponentsForAPI(endpoint: .login, andCameraId: nil)
        let pathCameras = apiClient?.getPathComponentsForAPI(endpoint: .cameras, andCameraId: nil)
        let pathCameraStatus = apiClient?.getPathComponentsForAPI(endpoint: .cameraStatus, andCameraId: 1)
        let pathLogout = apiClient?.getPathComponentsForAPI(endpoint: .logOut, andCameraId: nil)
        let pathRefresh = apiClient?.getPathComponentsForAPI(endpoint: .refreshToken, andCameraId: nil)
        
        XCTAssertEqual(pathLogin?.url?.absoluteString, "https://rest.cameramanager.com/oauth/token")
        XCTAssertEqual(pathCameras?.url?.absoluteString, "https://rest.cameramanager.com/rest/v2.4/cameras")
        XCTAssertEqual(pathCameraStatus?.url?.absoluteString, "https://rest.cameramanager.com/rest/v2.4/cameras/1/status")
        XCTAssertEqual(pathLogout?.url?.absoluteString, "https://rest.cameramanager.com/rest/v2.0/users/self/tokens/current")
        XCTAssertEqual(pathRefresh?.url?.absoluteString, "https://rest.cameramanager.com/oauth/token")
    }

    func test_refresh_token_path(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        //Make error access token
        let accessToken = AppDataManager.shared.accessToken
        XCTAssertNotNil(accessToken)
        
        
        //Get cameras
        AppDataManager.shared.accessToken = "\(AppDataManager.shared.accessToken!)abcd"
        
        let expectationGetCamerasWithAuthError = XCTestExpectation(description: "Get Cameras expectation")
        
        apiClient?.getCameras(completion: { cameras, responseError in
            
            XCTAssertEqual(responseError, .authentication)
            expectationGetCamerasWithAuthError.fulfill()
        })
        
        wait(for: [expectationGetCamerasWithAuthError], timeout: 10.0)
        
        //Get a new access token using the Refresh
        let expectationRefreshToken = XCTestExpectation(description: "Get Refresh token")
        apiClient?.refreshToken(refreshToken: AppDataManager.shared.refreshToken!, completion: { loginResult, responseError in
            
            XCTAssertNotNil(loginResult)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            XCTAssertEqual(responseError, .none)
            expectationRefreshToken.fulfill()
        })
        wait(for: [expectationRefreshToken], timeout: 10.0)
        
        //Get cameras again using the new access token received via the refresh token
        let expectationGetCamerasWithoutAuthError = XCTestExpectation(description: "Get Cameras expectation")
        
        apiClient?.getCameras(completion: { cameras, responseError in
            
            XCTAssertEqual(responseError, .none)
            expectationGetCamerasWithoutAuthError.fulfill()
        })
        
        wait(for: [expectationGetCamerasWithoutAuthError], timeout: 10.0)
    }
    
    func test_getCamerasWithAutoRefreshToken(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        AppDataManager.shared.accessToken = "\(AppDataManager.shared.accessToken!)abcd"
        
        let expectation = XCTestExpectation(description: "Get cameras with auto refreshing token.")
        
        apiClient?.getCamerasWithAutoRefreshingToken(completion: {cameras, responseError in

            XCTAssertEqual(responseError, .none)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getCameraStatusWithAutoRefreshToken(){
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "LoginSuccess expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        let expectation = XCTestExpectation(description: "Get cameras with auto refreshing token.")
        var camera: Camera?
        
        apiClient?.getCamerasWithAutoRefreshingToken(completion: {cameras, responseError in

            XCTAssertEqual(responseError, .none)
            XCTAssertNotNil(cameras)
            camera = cameras![0]
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
        
        AppDataManager.shared.accessToken = "\(AppDataManager.shared.accessToken!)abcd"
        
        let expectation2 = XCTestExpectation(description: "Get camera Status with auto refreshing token.")
        
        apiClient?.getCameraStatusWithAutoRefreshingToken(camera: camera!, completion: { cameraStatus, responseError in
            XCTAssertEqual(responseError, .none)
            expectation2.fulfill()
        })
        
        wait(for: [expectation2], timeout: 10.0)
    }
    
    func test_cameraStreamsWithAutoRefreshingToken(){
        
        print("\nStarting: test_cameraStreamsWithAutoRefreshingToken")
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "Login expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        let expectationGetCameras = XCTestExpectation(description: "Get cameras with auto refreshing token.")
        var camera: Camera?
        
        apiClient?.getCamerasWithAutoRefreshingToken(completion: {cameras, responseError in

            XCTAssertEqual(responseError, .none)
            XCTAssertNotNil(cameras)
            camera = cameras![0]
            expectationGetCameras.fulfill()
        })
        
        wait(for: [expectationGetCameras], timeout: 10.0)
        
        //AppDataManager.shared.accessToken = "\(AppDataManager.shared.accessToken!)abcd"
        
        let expectationGetCameraStreams = XCTestExpectation(description: "Get camera Streams with auto refreshing token.")
        
        apiClient?.getCameraStreamWithAutoRefreshingToken(camera: camera!, completion: { cameraStream, responseError in
            XCTAssertEqual(responseError, ResponseError.none)
            XCTAssertNotNil(cameraStream)
            
            expectationGetCameraStreams.fulfill()
        })
        
        wait(for: [expectationGetCameraStreams], timeout: 10.0)
        
        print("\nEnding: test_cameraStreamsWithAutoRefreshingToken")
    }
    
    func test_getCameraDetailsIncludingStreams() {
        
        print("\nStarting: test_getCameraDetailsIncludingStreams")
        
        let username = "onlinedemo@cameramanager.com"
        let password = "demo1234"
        let expectationLoginSuccess = XCTestExpectation(description: "Login expectation")
        
        apiClient?.login(userName: username, password: password, completion: { loginResult, responseError in
            
            let error = responseError
            
            AppDataManager.shared.accessToken = loginResult?.accessToken
            AppDataManager.shared.refreshToken = loginResult?.refreshToken
            
            XCTAssertEqual(error, .none)
            XCTAssertNotNil(loginResult?.accessToken)
            XCTAssertNotNil(loginResult?.refreshToken)
            expectationLoginSuccess.fulfill()
        })
        
        wait(for: [expectationLoginSuccess], timeout: 10.0)
        
        let expectationGetCameras = XCTestExpectation(description: "Get cameras with auto refreshing token.")
        var camera: Camera?
        
        apiClient?.getCamerasWithAutoRefreshingToken(completion: {cameras, responseError in

            XCTAssertEqual(responseError, .none)
            XCTAssertNotNil(cameras)
            camera = cameras![0]
            expectationGetCameras.fulfill()
        })
        
        wait(for: [expectationGetCameras], timeout: 10.0)
        
        let expectationGetCameraStreams = XCTestExpectation(description: "Get camera Streams with auto refresh token.")
        
        apiClient?.getCameraDetailsIncludingStreams(camera: camera!, completion: { cameraStream, cameraStatus, responseError in
            
            XCTAssertNotNil(cameraStream)
            XCTAssertNotNil(cameraStatus)
            XCTAssertEqual(responseError, .none)
            expectationGetCameraStreams.fulfill()
        })
        
        wait(for: [expectationGetCameraStreams], timeout: 10.0)
        
    }
}
