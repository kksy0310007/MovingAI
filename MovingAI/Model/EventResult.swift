//
//  EventResult.swift
//  MovingAI
//
//  Created by soyoung on 2/3/25.
//

import Foundation


struct EventResult: Codable {
    let no: Int?
    let id: Int?
    let eventKind: String?
    let eventName: String?
    let type: String?
    let contractorName: String?
    let siteName: String?
    let assetId: Int?
    let assetName: String?
    let assetSerial: String?
    let regDate: String?
    let regUser: String?
    let actynText: String?
    let actyn: Bool?
    let eventVideoPath: String?
    let eventVideoName: String?
    let actUser: String?
    let actDate: String?
    let actContents: String?
    let beforeEventImageName: String?
    let afterEventImageName: String?
    let minRegDate: String?
    let maxRegDate: String?
    let assetLat: Double?
    let assetLng: Double?
    let siteId: Int?
    let assetOn: Bool?
    
    
    enum CodingKeys: String, CodingKey {
    case no, id, eventName, eventKind, type, contractorName, siteName, assetId, assetName, assetSerial, regDate, regUser, actynText, actyn, eventVideoPath, eventVideoName, actUser, actDate, actContents, beforeEventImageName, afterEventImageName, minRegDate, maxRegDate, assetLat, assetLng, siteId, assetOn
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.no = try container.decodeIfPresent(Int.self, forKey: .no)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        self.eventKind = try container.decodeIfPresent(String.self, forKey: .eventKind)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.contractorName = try container.decodeIfPresent(String.self, forKey: .contractorName)
        self.siteName = try container.decodeIfPresent(String.self, forKey: .siteName)
        self.assetId = try container.decodeIfPresent(Int.self, forKey: .assetId)
        self.assetName = try container.decodeIfPresent(String.self, forKey: .assetName)
        self.assetSerial = try container.decodeIfPresent(String.self, forKey: .assetSerial)
        self.regDate = try container.decodeIfPresent(String.self, forKey: .regDate)
        self.regUser = try container.decodeIfPresent(String.self, forKey: .regUser)
        self.actynText = try container.decodeIfPresent(String.self, forKey: .actynText)
        self.actyn = try container.decodeIfPresent(Bool.self, forKey: .actyn)
        self.eventVideoPath = try container.decodeIfPresent(String.self, forKey: .eventVideoPath)
        self.eventVideoName = try container.decodeIfPresent(String.self, forKey: .eventVideoName)
        self.actUser = try container.decodeIfPresent(String.self, forKey: .actUser)
        self.actDate = try container.decodeIfPresent(String.self, forKey: .actDate)
        self.actContents = try container.decodeIfPresent(String.self, forKey: .actContents)
        self.beforeEventImageName = try container.decodeIfPresent(String.self, forKey: .beforeEventImageName)
        self.afterEventImageName = try container.decodeIfPresent(String.self, forKey: .afterEventImageName)
        self.minRegDate = try container.decodeIfPresent(String.self, forKey: .minRegDate)
        self.maxRegDate = try container.decodeIfPresent(String.self, forKey: .maxRegDate)
        self.assetLat = try container.decodeIfPresent(Double.self, forKey: .assetLat)
        self.assetLng = try container.decodeIfPresent(Double.self, forKey: .assetLng)
        self.siteId = try container.decodeIfPresent(Int.self, forKey: .siteId)
        self.assetOn = try container.decodeIfPresent(Bool.self, forKey: .assetOn)
    }
}
