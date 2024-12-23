//
//  NxCamMethods.swift
//  MovingAI
//
//  Created by soyoung on 12/13/24.
//

import UIKit


var loginApiUrl: String = "https://moving-ai.com/outside/" // 로그인

var baseApiUrl: String = "https://platform.moving-ai.com/api/v1/" // 장비에서 바로 가져오는 데이터 (카메라 회전, 실시간 영상, 음성파일, 현재 켜져있는 모든 장비 리스트 등)
var baseDataApiUrl: String = "https://moving-ai.com/api/v1/" // 그 외 서버에서 가져오는 데이터 (현장 별 장비 리스트 등)


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
