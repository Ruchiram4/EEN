//
//  URLs.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation



struct URLs {
    
    private static let SCHEME = "https"
    private static let HOST = "rest.cameramanager.com"
    private static let LOGIN = "/oauth/token"
    private static let REFRESH_TOKEN = "/oauth/token"
    private static let LOGOUT = "/rest/v2.0/users/self/tokens/current"
    private static let CAMERAS = "/rest/v2.4/cameras"
    private static let CAMERA_STATUS_1 = "/rest/v2.4/cameras"
    private static let CAMERA_STATUS_2 = "/status"
    private static let CAMERA_STREAMS_1 = "/rest/v2.2/cameras"
    private static let CAMERA_STREAMS_2 = "/streams"
    
    static func scheme() -> String {
        return SCHEME
    }
    static func host() -> String {
        return HOST
    }
    static func login() -> String {
        return LOGIN
    }
    static func refreshToken() -> String {
        return REFRESH_TOKEN
    }
    static func logOut() -> String {
        return LOGOUT
    }
    static func cameras() -> String {
        return CAMERAS
    }
    static func cameraStatus(cameraId: Int?) -> String{
        guard let cameraId = cameraId else { return "" }
        return "\(CAMERA_STATUS_1)/\(cameraId)\(CAMERA_STATUS_2)"
    }
    static func cameraStream(cameraId: Int?) -> String {
        guard let cameraId = cameraId else { return "" }
        return "\(CAMERA_STREAMS_1)/\(cameraId)\(CAMERA_STREAMS_2)"
    }
    
}
