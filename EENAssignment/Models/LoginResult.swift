//
//  LoginResult.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

typealias RefreshTokenResult = LoginResult

struct LoginResult: Codable {
    
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    
    //Error models
    let error: String?
    let errorDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case error
        case errorDescription = "error_description"
        case httpStatusCode
    }
    
    var httpStatusCode: Int?
}

 
