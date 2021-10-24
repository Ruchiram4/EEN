//
//  APIClient.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

enum APIEndpoint: String {
    case login
    case refreshToken
    case logOut
    case cameras
    case cameraStatus
    case cameraStream
}

class APIClient: APIClientProtocol {
    
    let parser: ObjectParserProtocol
    
    init(withParser: ObjectParserProtocol) {
        self.parser = withParser
    }
    
    func login(userName: String, password: String, completion: @escaping (LoginResult?, ResponseError) -> () ) {
        
        var components = getPathComponentsForAPI(endpoint: .login, andCameraId: nil)
        components.path = URLs.login()
        
        let grantType = URLQueryItem(name: "grant_type", value: "password")
        let scope = URLQueryItem(name: "scope", value: "write")
        let username = URLQueryItem(name: "username", value: userName)
        let password = URLQueryItem(name: "password", value: password)
        components.queryItems = [grantType, scope, username, password]
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .login, url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                
                return
            }
            
            var (result, responseError) = self.parser.parseLoginResponse(withData: data, error: error, response: urlResponse)
            DispatchQueue.main.async {
                
                //Since the API returns 400 reponse for an authentication error.
                if responseError == .badrequest {
                    responseError = .authentication
                }
                completion(result, responseError)
            }
            
        }.resume()
        
    }
    
    func refreshToken(refreshToken: String, completion: @escaping (LoginResult?, ResponseError) -> () ){
        
        var components = getPathComponentsForAPI(endpoint: .refreshToken, andCameraId: nil)
        components.path = URLs.refreshToken()
        
        let grantType = URLQueryItem(name: "grant_type", value: "refresh_token")
        let scope = URLQueryItem(name: "scope", value: "write")
        let refreshToken = URLQueryItem(name: "refresh_token", value: AppDataManager.shared.refreshToken)
        components.queryItems = [grantType, scope, refreshToken]
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .refreshToken, url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                
                return
            }
            
            let (loginResult, responseError) = self.parser.parseRefreshTokenResponse(withData: data, error: error, response: urlResponse)
            completion(loginResult, responseError)
            
        }.resume()
    }
    
    func logOut(completion: @escaping (ResponseError) -> () ) {
        
        var components = getPathComponentsForAPI(endpoint: .logOut, andCameraId: nil)
        components.path = URLs.logOut()
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .logOut, url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(.general)
                }
                
                return
            }
            
            let responseError = self.parser.parseLogoutResponse(withData: data, error: error, response: urlResponse)
            AppDataManager.shared.clearTokens()
            
            DispatchQueue.main.async {
                completion(responseError)
            }
            
        }.resume()
    }
    
    func getCamerasWithAutoRefreshingToken(completion: @escaping ([Camera]?, ResponseError) -> () ){
        
        getCameras {[weak self] cameras, responseError in
            
            guard let refreshToken = AppDataManager.shared.refreshToken else {
                completion(nil, .authentication)
                return
            }
            
            if responseError == .authentication && AppDataManager.shared.hasRefreshToken(){
                
                self?.refreshToken(refreshToken: refreshToken) { [weak self] loginResult, responseErrorRefreshToken in
                    
                    guard let _ = loginResult else {
                        DispatchQueue.main.async {
                            completion(cameras, responseError)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.getCameras(completion: completion)
                    }
                    
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(cameras, responseError)
                }
            }
        }
    }
    
    func getCameras(completion: @escaping ([Camera]?, ResponseError) -> () ) {
        
        var components = getPathComponentsForAPI(endpoint: .cameras, andCameraId: nil)
        components.path = URLs.cameras()
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .cameras, url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                
                return
            }
            
            let (result, responseError) = self.parser.parseCamerasResponse(withData: data, error: error, response: urlResponse)
                        
            DispatchQueue.main.async {
                
                completion(result, responseError)
            }
            
        }.resume()
    }
    
    func getCameraStatusWithAutoRefreshingToken(camera: Camera, completion: @escaping (CameraStatus?, ResponseError) -> ()) {
    
        getCameraStatus(camera: camera) { [weak self] cameraStatus, responseError in
            
            guard let refreshToken = AppDataManager.shared.refreshToken
            else{
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                return
            }
            
            if responseError == .authentication  && AppDataManager.shared.hasRefreshToken() {
                self?.refreshToken(refreshToken: refreshToken) { [weak self] loginResult, responseErrorRefreshToken in
                    guard let _ = loginResult
                    else {
                        DispatchQueue.main.async {
                            completion(nil, responseErrorRefreshToken)
                        }
                        return
                    }
                    
                    self?.getCameraStatus(camera: camera, completion: completion)
                    
                }
            }
            else {
                completion(cameraStatus, responseError)
            }
        }
    }
    
    func getCameraStatus(camera: Camera, completion: @escaping (CameraStatus?, ResponseError) -> ()) {
        
        var components = getPathComponentsForAPI(endpoint: .cameraStatus, andCameraId: nil)
        components.path = URLs.cameraStatus(cameraId: camera.cameraId)
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .cameraStatus, url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                return
            }
            
            let (result, responseError) = self.parser.parseCameraStatusResponse(withData: data, error: error, response: urlResponse)
            
            DispatchQueue.main.async {
                completion(result, responseError)
            }
            
        }.resume()
        
    }
    
    func getCameraDetailsIncludingStreams(camera: Camera, completion: @escaping (CameraStream?, CameraStatus?, ResponseError) -> ()) {
        
        var cameraStatusValue: CameraStatus?
        var cameraStreamValue: CameraStream?
        var reponseErrorCameraStatusValue: ResponseError = .none
        var reponseErrorCameraStreamValue: ResponseError = .none
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getCameraStatusWithAutoRefreshingToken(camera: camera) { [weak self] cameraStatus, responseCameraStatus in
            
            guard let _ = self else {
                DispatchQueue.main.async {
                    completion(nil, nil, .general)
                }
                return
            }
            
            cameraStatusValue = cameraStatus
            reponseErrorCameraStatusValue = responseCameraStatus
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getCameraStreamWithAutoRefreshingToken(camera: camera) { cameraStream, responseCameraStream in
            cameraStreamValue = cameraStream
            reponseErrorCameraStreamValue = responseCameraStream
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if reponseErrorCameraStatusValue == .none && reponseErrorCameraStreamValue == .none {
                completion(cameraStreamValue, cameraStatusValue, .none)
            }
            else {
                completion(cameraStreamValue, cameraStatusValue, .general)
            }
        }
    }
    
    func getCameraStreamWithAutoRefreshingToken(camera: Camera, completion: @escaping (CameraStream?, ResponseError) -> ()) {
        
        var components = getPathComponentsForAPI(endpoint: .cameraStream, andCameraId: camera.cameraId)
        components.path = URLs.cameraStream(cameraId: camera.cameraId)
        
        let url = components.url
        guard let url = url else { return }
        
        var request = getRequestHeadersForAPI(endpoint: .cameraStream, url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil, .general)
                }
                
                return
            }
            
            let (result, responseError) = self.parser.parseCameraStreamResponse(withData: data, error: error, response: urlResponse)
            
            DispatchQueue.main.async {
                completion(result, responseError)
            }
            
        }.resume()
    }
    
    //MARK: Helper functions for class
    func getBasicAuthenticationValues() -> String {
        
        let apiKey = Constants.API_KEY()
        let apiSecret = Constants.API_SECRET()
        
        guard let apiKey = apiKey, let apiSecret = apiSecret else {
            return ""
        }
        
        let keyValuePair = "\(apiKey):\(apiSecret)"
        let base64EncodedToken = keyValuePair.base64Encode()
        
        return base64EncodedToken
    }
    
    func getBearerAuthenticationToken() -> String {
        
        if let token = AppDataManager.shared.accessToken {
            return token
        }
        else{
            return ""
        }
    }
    
    func getPathComponentsForAPI(endpoint: APIEndpoint, andCameraId: Int?) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = URLs.scheme()
        components.host = URLs.host()
        
        switch endpoint {
        case .login:
            components.path = URLs.login()
        case .refreshToken:
            components.path = URLs.refreshToken()
        case .logOut:
            components.path = URLs.logOut()
        case .cameras:
            components.path = URLs.cameras()
        case .cameraStatus:
            components.path = URLs.cameraStatus(cameraId: andCameraId)
        case .cameraStream:
            components.path = URLs.cameraStream(cameraId: andCameraId)
        }
        return components
    }
    
    func getRequestHeadersForAPI(endpoint: APIEndpoint, url: URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if endpoint == .login || endpoint == .refreshToken {
            request.addValue("Basic \(getBasicAuthenticationValues())", forHTTPHeaderField: "Authorization")
        }
        else {
            request.addValue("Bearer \(getBearerAuthenticationToken())", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
