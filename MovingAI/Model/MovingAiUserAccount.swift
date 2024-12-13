//
//  MovingAiUserAccount.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//


import Foundation

//struct UserAttach: Codable {
//
//    let id: Int
//    let name: String
//    let attachType: String
//    let etc1: String?
//    let etc2: String?
//    let etc3: String?
//
//    let parentId: Int?
//    let useyn: Bool
//    let telnum: String?
//    let address: String?
//    let faxnum: String?
//
//}
struct MovingAiUserAccount: Codable {
    
    let id: Int
    let name: String
    let userId: String
    let password: String
    let role: String
    let department: String?
    let position: String?
    let email: String?
    let telnum: String?
    let etc: String?
    let useyn: Bool
    let attach: AttachData
    
    
    enum CodingKeys: CodingKey {
        case id, name, userId, password, role, department, position, email, telnum, etc, useyn, attach
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.password = try container.decode(String.self, forKey: .password)
        self.role = try container.decode(String.self, forKey: .role)
        self.department = try container.decodeIfPresent(String.self, forKey: .department)
        self.position = try container.decodeIfPresent(String.self, forKey: .position)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.telnum = try container.decodeIfPresent(String.self, forKey: .telnum)
        self.etc = try container.decodeIfPresent(String.self, forKey: .etc)
        self.useyn = try container.decode(Bool.self, forKey: .useyn)
        self.attach = try container.decode(AttachData.self, forKey: .attach)
    }
    
}
