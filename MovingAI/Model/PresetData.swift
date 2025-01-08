//
//  PresetData.swift
//  MovingAI
//
//  Created by soyoung on 1/7/25.
//

import Foundation

struct PresetData: Codable {
    
    let fileName: String?
    let fileSize: Int?
    let filePath: String?
    let fileDate: String?


    enum CodingKeys: CodingKey {
        case fileName, fileSize, filePath, fileDate
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
        self.fileSize = try container.decodeIfPresent(Int.self, forKey: .fileSize)
        self.filePath = try container.decodeIfPresent(String.self, forKey: .filePath)
        self.fileDate = try container.decodeIfPresent(String.self, forKey: .fileDate)
    }
}
