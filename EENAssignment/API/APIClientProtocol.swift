//
//  APIClientProtocol.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

protocol APIClientProtocol {
    
    func login(userName: String, password: String, completion: @escaping (LoginResult?, ResponseError) -> () )
    
    func refreshToken(refreshToken: String, completion: @escaping (LoginResult?, ResponseError) -> () )
    
    func logOut(completion: @escaping (ResponseError) -> () )
    
    func getCamerasWithAutoRefreshingToken(completion: @escaping ([Camera]?, ResponseError) -> () )
    
    func getCameraStatusWithAutoRefreshingToken(camera: Camera, completion: @escaping (CameraStatus?, ResponseError) -> ())
    
    func getCameraStreamWithAutoRefreshingToken(camera: Camera, completion: @escaping (CameraStream?, ResponseError) -> ())
    
    func getCameraDetailsIncludingStreams(camera: Camera, completion: @escaping (CameraStream?, CameraStatus?, ResponseError) -> ())
}
