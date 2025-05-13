//
//  UserAccountMethods.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//


//enum attachType {
//    case Company // 회사 계정
//    case Contractor // 시공사 계정
//    case Site // 현장계정
//}


class UserAccountMethods {
    static let shared = UserAccountMethods()
    
    var id: Int?
    var name: String?
    var isAutoLogin: Bool = true
    var movingAIUserAccount: MovingAiUserAccount?
    
    
    // attach //
    
    // 장비 id
    var attachId: Int = 0
    
    // 계정의 현장 타입
    var attachType: String = ""
//    var attachType: attachType = .Company
    
    // 현장 title
    var title: String = ""
    
    
    // 선택한 현장 데이터
    var selectedSiteData: AttachData? = nil
    
    private init() {
        
    }
    
    func removeAll() {
        id = nil
        name = nil
        isAutoLogin = false
        movingAIUserAccount = nil
        attachId = 0
        attachType = ""
        title = ""
        selectedSiteData = nil
    }
}
