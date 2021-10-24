//
//  CameraStreams.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-17.
//

import Foundation

struct CameraStream: Codable {
    
    let streamId: StreamId
    let urls: URLs?
    
    struct StreamId: Codable {
        let value: Int?
    }
    
    struct URLs: Codable {
        let rtsp: String?
        let rtspHttp: String?
        let rtspHttps: String?
        let hlsHttp: String?
        let hlsHttps: String?
        let multipartHttp: String?
        let multipartHttps: String?
        let multipartaudioHttp: String?
        let multipartaudioHttps: String?
        let mjpegHttp: String?
        let mjpegHttps: String?
        let audioPushHttp: String?
        let audioPushHttps: String?
    }
    
}
