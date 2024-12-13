//
//  NxCamDeviceInfo.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//


import Foundation

struct NxCamDeviceInfo: Codable {
        
        let sessionId: String
        let address: String
        let port: Int
        let deviceIp: String
        let deviceSerial: String
        let deviceStatus: Int
        let lat: String
        let lon: String
        let keepaliveTime: String
        let modemIMEI: String
        let deviceName: String
        let batLevel: String
        let statusCode: Int
        let lastPayload: Int
        let nxcamVER: String
        let eventFile: String?
        let gpuTemp: String
        let cpuTemp: String
        let eventTime: String?
        let sdLowSpace: Int
        let omsVER: String
    
    enum CodingKeys: CodingKey {
        case sessionId, address, port, deviceIp, deviceSerial, deviceStatus, lat, lon, keepaliveTime, modemIMEI, deviceName, batLevel, statusCode, lastPayload, nxcamVER, eventFile, gpuTemp, cpuTemp, eventTime, sdLowSpace, omsVER
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sessionId = try container.decode(String.self, forKey: .sessionId)
        self.address = try container.decode(String.self, forKey: .address)
        self.port = try container.decode(Int.self, forKey: .port)
        self.deviceIp = try container.decode(String.self, forKey: .deviceIp)
        self.deviceSerial = try container.decode(String.self, forKey: .deviceSerial)
        self.deviceStatus = try container.decode(Int.self, forKey: .deviceStatus)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.lon = try container.decode(String.self, forKey: .lon)
        self.keepaliveTime = try container.decode(String.self, forKey: .keepaliveTime)
        self.modemIMEI = try container.decode(String.self, forKey: .modemIMEI)
        self.deviceName = try container.decode(String.self, forKey: .deviceName)
        self.batLevel = try container.decode(String.self, forKey: .batLevel)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.lastPayload = try container.decode(Int.self, forKey: .lastPayload)
        self.nxcamVER = try container.decode(String.self, forKey: .nxcamVER)
        self.eventFile = try container.decodeIfPresent(String.self, forKey: .eventFile) ?? nil
        self.gpuTemp = try container.decode(String.self, forKey: .gpuTemp)
        self.cpuTemp = try container.decode(String.self, forKey: .cpuTemp)
        self.eventTime = try container.decodeIfPresent(String.self, forKey: .eventTime) ?? nil
        self.sdLowSpace = try container.decode(Int.self, forKey: .sdLowSpace)
        self.omsVER = try container.decode(String.self, forKey: .omsVER)
    }
        
}

