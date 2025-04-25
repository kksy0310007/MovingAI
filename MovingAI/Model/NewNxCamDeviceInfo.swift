//
//  NewNxCamDeviceInfo.swift
//  MovingAI
//
//  Created by soyoung on 4/22/25.
//

import Foundation

//newOnlineDeviceList
struct NewNxCamDeviceInfo: Codable {
    let deviceData: NxCamDeviceInfo
    let name: String
    
    
    enum CodingKeys: CodingKey {
        case deviceData, name
    }
    
    init(deviceData: NxCamDeviceInfo, name: String) {
        self.deviceData = deviceData
        self.name = name
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deviceData = try container.decode(NxCamDeviceInfo.self, forKey: .deviceData)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
