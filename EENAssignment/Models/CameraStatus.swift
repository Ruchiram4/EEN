//
//  CameraStatus.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

struct CameraStatus: Codable {
    
    let cameraId: Int?
    let isOnline: Bool?
    let isRecordingOnCloud: Bool?
    let isAudioEnabled: Bool?
    let isPasswordKnown: Bool?
    let passwordStatus: String?
    let firmwareStatus: String?
    let connectionType: String?
    let lastConnectionResult: String?
    
    private enum CodingKeys: String, CodingKey {
        case cameraId
        case isOnline = "online"
        case isRecordingOnCloud = "recordingOnCloud"
        case isAudioEnabled = "audioEnabled"
        case isPasswordKnown = "passwordKnown"
        case passwordStatus
        case firmwareStatus
        case connectionType
        case lastConnectionResult
    }
}
