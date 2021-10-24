//
//  Factory.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

class Factory {
    
    static func createAPIClient() -> APIClientProtocol {
        return APIClient(withParser: ObjectParser())
    }
    
    static func createHomeViewController() -> HomeViewController {
        return HomeViewController(withAPIClient: createAPIClient())
    }
    
    static func createLoginScreen() -> LoginViewController {
        let loginController = LoginViewController(withAPIClient: createAPIClient())
        loginController.hideLogoutButton()
        return loginController
    }
    
    static func createDetailsViewController(withCamera: Camera?) -> CameraDetailViewController {
        return CameraDetailViewController(withClient: createAPIClient(), andCamera: withCamera)
    }
    
    static func createPlayerViewController(withUrl: String?) -> PlayerViewController {
        guard let url = withUrl else { return PlayerViewController(withUrl: "") }
        return PlayerViewController(withUrl: url)
    }
}
