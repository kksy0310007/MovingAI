//
//  BroadCastCreateBodyDataModel.swift
//  MovingAI
//
//  Created by soyoung on 1/8/25.
//

import Foundation

struct BroadcastCreateBodyDataModel: Codable {
    var id: Int?
    var apiType: String?
    var eventKind: String?
    var userId: String?

    // 기본 생성자
    init() {}

    // 매개변수가 있는 생성자
    init(id: Int?, apiType: String?, eventKind: String?, userId: String?) {
        self.id = id
        self.apiType = apiType
        self.eventKind = eventKind
        self.userId = userId
    }
}
