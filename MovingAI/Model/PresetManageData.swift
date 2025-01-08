//
//  PresetManageData.swift
//  MovingAI
//
//  Created by soyoung on 1/7/25.
//

import Foundation

struct PresetManageData: Codable {

    let id: Int
    let eventKind: String?
    let title: String
    let filepath: String
    let filename: String
    let oriFilename: String
    let audioPlay: String?
    let sourceType: String
    let applyNxCam: String
    let applyNxCamCnt: String
    let username: String
    let attachType: String
    let attachName: String
    let useyn: Bool
    let regDate: String
    let delFile: Bool
    let useynText: String

    enum CodingKeys: String, CodingKey {
            case id, eventKind, title, filepath, filename, oriFilename, audioPlay, sourceType, applyNxCam, applyNxCamCnt, username, attachType, attachName, useyn, regDate, delFile
            case useynText = "useyn_text"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.eventKind = try container.decodeIfPresent(String.self, forKey: .eventKind)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.filepath = try container.decode(String.self, forKey: .filepath)
        self.filename = try container.decode(String.self, forKey: .filename)
        self.oriFilename = try container.decode(String.self, forKey: .oriFilename)
        self.audioPlay = try container.decodeIfPresent(String.self, forKey: .audioPlay)
        self.sourceType = try container.decode(String.self, forKey: .sourceType)
        self.applyNxCam = try container.decode(String.self, forKey: .applyNxCam)
        self.applyNxCamCnt = try container.decode(String.self, forKey: .applyNxCamCnt)
        
        self.username = try container.decode(String.self, forKey: .username)
        self.attachType = try container.decode(String.self, forKey: .attachType)
        self.attachName = try container.decode(String.self, forKey: .attachName)
        
        self.useyn = try container.decode(Bool.self, forKey: .useyn)
        self.regDate = try container.decode(String.self, forKey: .regDate)
        self.delFile = try container.decode(Bool.self, forKey: .delFile)
        self.useynText = try container.decode(String.self, forKey: .useynText)
        
    }
}
