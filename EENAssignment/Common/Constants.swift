//
//  Constants.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-10.
//

import Foundation
import UIKit

extension UIColor {
    static let blueBackground = UIColor(red: 7.0/255, green: 126.0/255, blue: 176.0/255, alpha: 1.0)
    static let loadingViewBackground = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    static let refreshViewTint = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
}

struct Constants {
    
    public static func API_KEY() -> String? {
        let key = Bundle.main.infoDictionary?["API_KEY"] as? String
        return key
    }
    public static func API_SECRET() -> String? {
        let key = Bundle.main.infoDictionary?["API_SECRET"] as? String
        return key
    }
    
    public static let DEMO_USERNAME = "onlinedemo@cameramanager.com"
    public static let DEMO_PASSWORD = "demo1234"
}

enum ResponseError: String {
    case none = "none"
    case server = "server"
    case badrequest = "badrequest"
    case authentication = "authentication"
    case parse = "parse"
    case general = "general"
}
