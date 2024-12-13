//
//  AttachData.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//

import Foundation

struct AttachData: Codable {
    
    let no: Int?
    let id: Int
    let attachType: String?
    let etc1: String?
    let etc2: String?
    let etc3: String?
    let parentId: Int?
    let name: String
    
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
    
    let faxnum: String?
    let useyn_text: String?
    let useyn: Bool?
    
    

    enum CodingKeys: CodingKey {
        case no, id, attachType, etc1, etc2, etc3, parentId, name, work_startdate, work_enddate, telnum, address, lat, lng, ptb_name, ptb_telnum, site_image_name1, site_image_path1, site_image_name2, site_image_path2, site_image_name3, site_image_path3, faxnum, useyn_text, useyn
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.no = try container.decodeIfPresent(Int.self, forKey: .no)
        self.id = try container.decode(Int.self, forKey: .id)
        self.attachType = try container.decodeIfPresent(String.self, forKey: .attachType)
        self.etc1 = try container.decodeIfPresent(String.self, forKey: .etc1)
        self.etc2 = try container.decodeIfPresent(String.self, forKey: .etc2)
        self.etc3 = try container.decodeIfPresent(String.self, forKey: .etc3)
        self.parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        self.name = try container.decode(String.self, forKey: .name)
        
        self.work_startdate = try container.decodeIfPresent(String.self, forKey: .work_startdate)
        self.work_enddate = try container.decodeIfPresent(String.self, forKey: .work_enddate)
        
        self.telnum = try container.decodeIfPresent(String.self, forKey: .telnum)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        self.lng = try container.decodeIfPresent(Double.self, forKey: .lng)
        self.ptb_name = try container.decodeIfPresent(String.self, forKey: .ptb_name)
        self.ptb_telnum = try container.decodeIfPresent(String.self, forKey: .ptb_telnum)
        
        self.site_image_name1 = try container.decodeIfPresent(String.self, forKey: .site_image_name1)
        self.site_image_path1 = try container.decodeIfPresent(String.self, forKey: .site_image_path1)
        
        self.site_image_name2 = try container.decodeIfPresent(String.self, forKey: .site_image_name2)
        self.site_image_path2 = try container.decodeIfPresent(String.self, forKey: .site_image_path2)
        
        self.site_image_name3 = try container.decodeIfPresent(String.self, forKey: .site_image_name3)
        self.site_image_path3 = try container.decodeIfPresent(String.self, forKey: .site_image_path3)
        
        
        self.faxnum = try container.decodeIfPresent(String.self, forKey: .faxnum)
        self.useyn_text = try container.decodeIfPresent(String.self, forKey: .useyn_text)
        self.useyn = try container.decodeIfPresent(Bool.self, forKey: .useyn)
        
        
    }
}
