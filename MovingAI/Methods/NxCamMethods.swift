//
//  NxCamMethods.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//

import UIKit

class NxCamMethods {
    
    static let shared = NxCamMethods()
    
    
    // 온라인 장비 전체
    var onlineDeviceList: [NxCamDeviceInfo] = []
    // 전체 장비
    var allAssetDeviceList: [AssetData] = []
    // 계정의 접근 가능한 모든 현장 리스트
    var allAttachList: [AttachData] = []
    
   
    // 선택한 장비 현장 ID
    var selectedSiteID: Int = 0
    // 선택한 현장 데이터
    var selectedSiteData: AttachData? = nil
    
    
    // 온라인 장비 리스트
    var deviceInfoList: [NxCamDeviceInfo] = []
    
    // 선택한 장비  정보
    var selectedDeviceInfo: NxCamDeviceInfo? = nil
    
    func getDeviceInfoList() -> [NxCamDeviceInfo] {
        return deviceInfoList
    }
    
    func setDeviceInfoList(_ list: [NxCamDeviceInfo]) {
        deviceInfoList = list
    }
    
    func setSelectedDeviceInfo(_ device: NxCamDeviceInfo) {
        selectedDeviceInfo = device
    }
    
    func changeScreen(_ context: UIViewController, to viewControllerType: UIViewController.Type) {
        let nextVC = viewControllerType.init()
        context.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    private init() {
        
    }
    
}
