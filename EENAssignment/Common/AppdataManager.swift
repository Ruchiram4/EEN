//
//  AppdataManager.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-10.
//

import Foundation

class AppDataManager {

    let KEY_ACCESS_TOKEN = "access_token"
    let KEY_REFRESH_TOKEN = "refresh_token"

    var accessToken: String?
    var refreshToken: String?
    
    static let shared = AppDataManager()
    
    private init() {
        self.accessToken = nil
        self.refreshToken = nil

    }
    
    public func clearInMemoryTokens() {
        AppDataManager.shared.accessToken = nil
        AppDataManager.shared.refreshToken = nil
    }
    
    public func clearSavedTokens(){
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: KEY_ACCESS_TOKEN)
        userDefaults.removeObject(forKey: KEY_REFRESH_TOKEN)
    }
    
    public func clearTokens() {
        clearInMemoryTokens()
        clearSavedTokens()
    }
    
    public func hasRefreshToken() -> Bool {
        
        guard let refreshToken = refreshToken else { return false }
        
        return refreshToken.isNonEmpty()
    }
    
    public func saveTokens(accessToken: String?, refreshToken: String?) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(accessToken, forKey: KEY_ACCESS_TOKEN)
        userDefaults.setValue(refreshToken, forKey: KEY_REFRESH_TOKEN)
        
        AppDataManager.shared.accessToken = accessToken
        AppDataManager.shared.refreshToken = refreshToken
    }
    
    public func hasTokens() -> Bool {
        
        if let accessToken = AppDataManager.shared.accessToken,
           let refreshToken = AppDataManager.shared.refreshToken {
           
            return ( accessToken.isNonEmpty() && refreshToken.isNonEmpty() )
        }
        else {
            let (access, refresh) = getSavedTokens()
            
            return (access.isNonEmpty() && refresh.isNonEmpty()) 
        }
    }
    
    public func loadSavedTokensToMemory() {
        let tokens = getSavedTokens()
        AppDataManager.shared.accessToken = tokens.0
        AppDataManager.shared.refreshToken = tokens.1
    }
    
    public func getSavedTokens() -> (String, String) {
        let userDefaults = UserDefaults.standard
        let accessToken = userDefaults.string(forKey: KEY_ACCESS_TOKEN)
        let refreshToken = userDefaults.string(forKey: KEY_REFRESH_TOKEN)
        
        return (accessToken ?? "", refreshToken ?? "")
    }

}
