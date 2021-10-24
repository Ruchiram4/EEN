//
//  ObjectParser.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-10.
//

import Foundation

protocol ObjectParserProtocol {
    
    func parseLoginResponse(withData: Data?, error: Error?, response: URLResponse?) -> (LoginResult?, ResponseError)
    
    func parseRefreshTokenResponse(withData: Data?, error: Error?, response: URLResponse?) -> (LoginResult?, ResponseError)
    
    func parseCamerasResponse(withData: Data?, error: Error?, response: URLResponse?) -> ([Camera]?, ResponseError)
    
    func parseCameraStatusResponse(withData: Data?, error: Error?, response: URLResponse?) -> (CameraStatus?, ResponseError)
    
    func parseLogoutResponse(withData: Data?, error: Error?, response: URLResponse?) -> (ResponseError)
    
    func parseCameraStreamResponse(withData: Data?, error: Error?, response: URLResponse?) -> (CameraStream?, ResponseError)
}

class ObjectParser: ObjectParserProtocol{
     
    func parseLoginResponse(withData: Data?, error: Error?, response: URLResponse?) -> (LoginResult?, ResponseError) {
        
        if isResponseSuccess(response: response){
            
            guard let _ = response else { return (nil, .general) }
            
            do{
                if let data = withData {
                    let response: LoginResult = try JSONDecoder().decode(LoginResult.self, from: data)

                    AppDataManager.shared.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
                    return (response, .none)
                }
                else{
                    return (nil, .parse)
                }
            }
            catch{
                return (nil, .parse)
            }
        }
        else{
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return (nil, responseError)
        }
    }
    
    func parseCamerasResponse(withData: Data?, error: Error?, response: URLResponse?) -> ([Camera]?, ResponseError) {
        
        if isResponseSuccess(response: response){
            
            guard let _ = response else { return (nil, .general) }
            
            do{
                if let data = withData {
                    let response: [Camera]? = try JSONDecoder().decode([Camera]?.self, from: data)
                    return (response, .none)
                }
                else{
                    return (nil, .parse)
                }
            }
            catch{
                return (nil, .parse)
            }
        }
        else {
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return (nil, responseError)
        }
    }
    
    func parseCameraStatusResponse(withData: Data?, error: Error?, response: URLResponse?) -> (CameraStatus?, ResponseError) {
        
        if isResponseSuccess(response: response){
            
            guard let _ = response else { return (nil, .general) }
            
            do{
                if let data = withData {
                    let response: CameraStatus? = try JSONDecoder().decode(CameraStatus?.self, from: data)
                    return (response, .none)
                }
                else{
                    return (nil, .parse)
                }
            }
            catch{
                return (nil, .parse)
            }
        }
        else {
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return (nil, responseError)
        }
    }
    
    func parseCameraStreamResponse(withData: Data?, error: Error?, response: URLResponse?) -> (CameraStream?, ResponseError) {
        
        if isResponseSuccess(response: response){
            
            guard let _ = response else { return (nil, .general) }
            
            do{
                if let data = withData {
                    let response: [CameraStream]? = try JSONDecoder().decode([CameraStream]?.self, from: data)
                    return (response?.first, .none)//Assume we're interester only on the first object
                }
                else{
                    return (nil, .parse)
                }
            }
            catch{
                return (nil, .parse)
            }
        }
        else {
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return (nil, responseError)
        }
    }
    
    func parseLogoutResponse(withData: Data?, error: Error?, response: URLResponse?) -> (ResponseError) {
        if isResponseSuccess(response: response){
            return .none
        }
        else{
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return responseError
        }
    }
    
    func parseRefreshTokenResponse(withData: Data?, error: Error?, response: URLResponse?) -> (LoginResult?, ResponseError) {
        if isResponseSuccess(response: response){
            
            guard let _ = response else { return (nil, .general) }
            
            do{
                if let data = withData {
                    let response: LoginResult = try JSONDecoder().decode(LoginResult.self, from: data)
                    
                    AppDataManager.shared.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
                    return (response, .none)
                }
                else{
                    return (nil, .parse)
                }
            }
            catch{
                return (nil, .parse)
            }
        }
        else{
            let responseError = performBasicValidationOfReponseErrors(withData: withData, error: error, response: response)
            return (nil, responseError)
        }
    }
    
}

extension ObjectParser {
    
    func isResponseSuccess(response: URLResponse?) -> Bool {
        
        guard let response = response else {return false}
        
        let httpStatusCode = getHttpStatusCode(response: response)
        return (200...299).contains(httpStatusCode)
    }
    
    func getHttpStatusCode(response: URLResponse?) -> Int {
        
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return -1
    }
    
    func performBasicValidationOfReponseErrors(withData: Data?, error: Error?, response: URLResponse?) -> ResponseError {
        
        //We get here if the status code is not in 200 range
        
        let httpStatusCode = getHttpStatusCode(response: response)
        var responseError: ResponseError = .none
        
        if (200...299).contains(httpStatusCode) {
            responseError = .none
        }
        else if httpStatusCode == 400 {
            responseError = .badrequest
        }
        else if httpStatusCode == 401 || httpStatusCode == 403 {
            responseError = .authentication
        }
        else if (500...599).contains(httpStatusCode) {
            responseError = .server
        }
        else {
            responseError = .general
        }
        
        return responseError
   
    }
}
