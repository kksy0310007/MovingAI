//
//  AssetData.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//

import Foundation

struct AssetKind: Codable {
    let id: Int
    let type: String
    let name: String?
    let description: String?
}

struct Attach: Codable {
    let id: Int
    let name: String?
    let attachType: String
    let etc1: String?
    let etc2: String?
    let etc3: String?
    let parentId: Int?
    let useyn: Bool?
    let work_startdate: String?
    let work_enddate: String?
    let telnum: String?
    let address: String?
    let lat: Double?
    let lng: Double?
    let ptb_name: String?
    let ptb_telnum: String?
    let site_image_name1: String?
    let site_image_path1: String?
    let site_image_name2: String?
    let site_image_path2: String?
    let site_image_name3: String?
    let site_image_path3: String?
}

struct AssetData: Codable {
    let id: Int
    let lat: Double?
    let lon: Double?
    let assetkind: AssetKind
    let name: String?
    let description: String?
    let useyn: Bool?
    let serial: String
    let regUser: String?
    let etc1: String?
    let etc2: String?
    let etc3: String?
    let etc4: String?
    let etc5: String?
    let attach: Attach?
    let modDate: String?
    let location: String?
   

enum CodingKeys: CodingKey {
    case id, lat, lon, assetkind, name, description, useyn, serial, regUser, etc1, etc2, etc3, etc4, etc5, attach, modDate, location
}


    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0.0
        self.assetkind = try container.decode(AssetKind.self, forKey: .assetkind)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.useyn = try container.decodeIfPresent(Bool.self, forKey: .useyn) ?? false
        self.serial = try container.decode(String.self, forKey: .serial)
        self.regUser = try container.decodeIfPresent(String.self, forKey: .regUser)
        self.etc1 = try container.decodeIfPresent(String.self, forKey: .etc1)
        self.etc2 = try container.decodeIfPresent(String.self, forKey: .etc2)
        self.etc3 = try container.decodeIfPresent(String.self, forKey: .etc3)
        self.etc4 = try container.decodeIfPresent(String.self, forKey: .etc4)
        self.etc5 = try container.decodeIfPresent(String.self, forKey: .etc5)
        self.attach = try container.decodeIfPresent(Attach.self, forKey: .attach)
        self.modDate = try container.decodeIfPresent(String.self, forKey: .modDate) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
}
