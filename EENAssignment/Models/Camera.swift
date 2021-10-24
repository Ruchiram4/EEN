//
//  Camera.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation

struct Camera: Codable {
    let cameraId: Int?
    let name: String?
    let deviceTypeId: Int?
    let ethernetMacAddress: String? //Map
    let zoneId: Int?
    let accountId: Int?
    var streamUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case cameraId
        case name
        case deviceTypeId
        case ethernetMacAddress = "ethMacAddress"
        case zoneId
        case accountId
        case streamUrl
    }
}
