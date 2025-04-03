//
//  AssetAiModelData.swift
//  MovingAI
//
//  Created by soyoung on 3/21/25.
//

import Foundation

struct AssetAiModelData: Codable {
    
    let id: Int?
    let name: String?
    let site_name: String?
    let site_id: Int?
    let aiModelList: [String]?
    
    enum CodingKeys: CodingKey {
        case id, name, site_name, site_id, aiModelList
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.site_name = try container.decodeIfPresent(String.self, forKey: .site_name)
        self.site_id = try container.decodeIfPresent(Int.self, forKey: .site_id)
        self.aiModelList = try container.decodeIfPresent([String].self, forKey: .aiModelList)
    }
}
